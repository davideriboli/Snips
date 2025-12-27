Il sistema analizza i dati registrati da un qualsiasi wearable Android e salvati in G-Drive via Health Connect (Connessione Salute). Questi dati possono essere integrati con quelli di altre fonti, come ad esempio, Daylio.

## 1. Scaricare i dati

Health connect esegue backup a cadenza regolata dall’utente, in una cartella omonima su G-Drive. Dentro c’è un file zippato che, una volta espanso, è un database .db. Gli script che seguono ricavano CSV dalle tabelle del DB più significative. Per prima cosa, logicamente, bisogna scaricare i dati ed espandere i dati.

## 2. VENV e Script

La prima cosa da fare è creare un venv nella cartella di lavoro.

```python
python -m venv henri_env
```

In questo caso si chiama  Henry, perché il GEM che procederà all’analisi finale è un piccolo omaggio a Henri Laborit. Inoltre ci serve Panda.

```python
pip install pandas
```


**01 Script di ispezione (serve a conoscere quali sono le tabelle nel db di Health Connect)**

```python
import sqlite3
import pandas as pd

# Il nome esatto del tuo file che vedo nei log
DB_PATH = 'health_connect_export1.db'

def inspect():
    try:
        conn = sqlite3.connect(DB_PATH)
        # Chiediamo al database la sua struttura interna
        query = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
        tables = pd.read_sql(query, conn)
        
        print(f"\n--- MAPPA DEL DATABASE ({len(tables)} tabelle trovate) ---")
        # Stampa l'elenco completo, senza tagliarlo
        pd.set_option('display.max_rows', None) 
        print(tables)
        print("---------------------------------------------------")
        
        conn.close()
    except Exception as e:
        print(f"ERRORE CRITICO: {e}")

if __name__ == "__main__":
    inspect()
```

**02 Script di normalizzazione dati Health Connect (serve a ricavare le tabelle più significative e a normalizzare la forma di data e ora)**

```python
import pandas as pd
import sqlite3
import os
from datetime import datetime, timedelta

# --- CONFIGURAZIONE ---
DB_PATH = 'health_connect_export1.db'
OUTPUT_FOLDER = 'export_csv_clean'

TABLES_CONFIG = {
    'exercise': 'exercise_session_record_table',
    'sleep': 'sleep_session_record_table',
    'sleep_stages': 'sleep_stages_table',
    'heart_rate': 'heart_rate_record_table',
    'hrv': 'heart_rate_variability_rmssd_record_table',
    'oxygen': 'oxygen_saturation_record_table',
    'resting_hr': 'resting_heart_rate_record_table',
    'steps': 'steps_record_table',
    'vo2_max': 'vo2_max_record_table',
    'speed': 'speed_record_table'
}

def get_db_connection(db_file):
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Exception as e:
        print(f"[FATAL] Impossibile connettersi al DB: {e}")
        return None

def clean_and_format_data(df):
    """
    Applica normalizzazione temporale, ORDINAMENTO,
    rimuove colonne inutili e formatta le date.
    """
    
    # 1. IDENTIFICAZIONE COLONNA PER ORDINAMENTO (CRUCIALE)
    # Cerchiamo la colonna raw più affidabile per ordinare dal più recente al più vecchio
    sort_candidates = ['start_time', 'time', 'epoch_millis', 'stage_start_time']
    sort_col = next((c for c in sort_candidates if c in df.columns), None)

    # 2. ORDINAMENTO CRONOLOGICO INVERSO (Newest First)
    # Allineiamo questo file a Daylio (che è sorted descending)
    if sort_col:
        df = df.sort_values(by=sort_col, ascending=False)

    # 3. Rilevamento Colonne Temporali per conversione
    ts_cols = [
        'start_time', 'end_time', 'time', 
        'local_date_time_start_time', 'local_date_time_end_time', 
        'stage_start_time', 'stage_end_time', 
        'last_modified_time', 'epoch_millis'
    ]

    readable_cols = []

    # Conversione Timestamp -> Datetime
    for col in ts_cols:
        if col in df.columns:
            new_col = f'{col}_iso'
            df[new_col] = pd.to_datetime(df[col], unit='ms', errors='coerce')
            readable_cols.append(new_col)

    # Conversione Local Date
    if 'local_date' in df.columns:
        base_date = pd.Timestamp("1970-01-01")
        df['date'] = base_date + pd.to_timedelta(pd.to_numeric(df['local_date'], errors='coerce'), unit='D')
        readable_cols.append('date')

    # Calcolo "Wall Clock Time"
    offset_col = next((c for c in ['start_zone_offset', 'zone_offset'] if c in df.columns), None)
    target_ts = next((c for c in ['start_time', 'time', 'epoch_millis'] if c in df.columns), None)

    if offset_col and target_ts:
        ts_val = pd.to_datetime(df[target_ts], unit='ms', errors='coerce')
        offset_val = pd.to_timedelta(df[offset_col], unit='s')
        df['local_time'] = ts_val + offset_val
        readable_cols.append('local_time')

    # 4. Formattazione Stringhe (YYYY-MM-DD HH:MM:SS)
    for col in readable_cols:
        if col in df.columns:
            if col == 'date':
                 df[col] = df[col].dt.strftime('%Y-%m-%d')
            else:
                 df[col] = df[col].dt.strftime('%Y-%m-%d %H:%M:%S')

    # 5. Pulizia Colonne (Drop Junk)
    junk_keywords = ['uuid', 'hash', 'device_info', 'app_info', 'client_record', 'row_id']
    cols_to_drop = [c for c in df.columns if any(k in c for k in junk_keywords)]
    
    # Rimuoviamo anche i timestamp RAW originali (ormai usati per il sort)
    cols_to_drop.extend([c for c in ts_cols if c in df.columns])
    if 'local_date' in df.columns: cols_to_drop.append('local_date')
    if offset_col: cols_to_drop.append(offset_col)
    
    df_clean = df.drop(columns=cols_to_drop, errors='ignore')

    # Riordino finale colonne (Tempo a sinistra)
    other_cols = [c for c in df_clean.columns if c not in readable_cols]
    final_order = [c for c in readable_cols if c in df_clean.columns] + other_cols
    
    return df_clean[final_order]

def extract_and_export(db_path, tables_map):
    if not os.path.exists(db_path):
        print(f"[ERRORE] DB non trovato: {db_path}")
        return

    if not os.path.exists(OUTPUT_FOLDER):
        os.makedirs(OUTPUT_FOLDER)

    conn = get_db_connection(db_path)
    if not conn: return

    print(f"--- AVVIO EXPORT SINCRONIZZATO (Newest First) ---")

    for friendly_name, table_name in tables_map.items():
        try:
            raw_df = pd.read_sql(f"SELECT * FROM {table_name}", conn)
            
            if not raw_df.empty:
                clean_df = clean_and_format_data(raw_df)
                
                csv_path = os.path.join(OUTPUT_FOLDER, f"{friendly_name}.csv")
                clean_df.to_csv(csv_path, index=False)
                
                # Check data prima riga
                first_date = clean_df.iloc[0]['local_time'] if 'local_time' in clean_df.columns else "N/A"
                print(f"[SAVED] {friendly_name:<15} -> Top Row Date: {first_date}")
            else:
                print(f"[VUOTO] {friendly_name}")
            
        except Exception as e:
            print(f"[SKIP] {friendly_name:<15} -> {e}")

    conn.close()
    print("--- COMPLETATO ---")

if __name__ == "__main__":
    extract_and_export(DB_PATH, TABLES_CONFIG)
```

**03 Script di normalizzazione Daylio (serve a rendere i dati del csv di esportazione più o meno compatibili con quelli di HC)**

```python
import pandas as pd
import numpy as np
import re
import os

# --- CONFIGURAZIONE ---
INPUT_FILE = 'daylio_export_2025_12_27.csv' 
OUTPUT_FOLDER = 'export_csv_clean'

def clean_daylio_data(filepath):
    """
    Trasforma il CSV di Daylio.
    Versione IBRIDA: Mantiene sia le attività leggibili che quelle codificate.
    """
    
    if not os.path.exists(filepath):
        print(f"[ERRORE] File non trovato: {filepath}")
        return None

    print(f"--- ELABORAZIONE DAYLIO: {filepath} ---")
    df = pd.read_csv(filepath)

    # 1. TIMESTAMP UNIFICATO
    df['timestamp'] = pd.to_datetime(df['full_date'] + ' ' + df['time'])
    
    # 2. PARSING DELLE "SCALES"
    metrics_map = {
        'mood_score': r'Umorgrafo.*?\((\d(?:\.\d)?)/5\)',
        'pain': r'Dolore:.*?\((\d(?:\.\d)?)/5\)',
        'energy': r'Energia:.*?\((\d(?:\.\d)?)/5\)',
        'sleep_quality': r'Qualità del sonno:.*?\((\d(?:\.\d)?)/5\)',
        'food_health': r'Salubrità alimentare:.*?\((\d(?:\.\d)?)/5\)',
        'stress': r'Stress:.*?\((\d(?:\.\d)?)/5\)'
    }

    print("Parsing Metriche Numeriche...")
    for metric_name, regex_pattern in metrics_map.items():
        if 'scales' in df.columns:
            extracted = df['scales'].str.extract(regex_pattern)
            # Se troviamo dati, li convertiamo
            if not extracted.isna().all().item():
                 df[metric_name] = extracted[0].astype(float)
                 print(f"  -> Estratto: {metric_name}")

    # Mappatura Mood
    mood_map = {
        'radon': 1, 'pessimo': 1,
        'male': 2,
        'omeostasi': 3, 'buono': 3,
        'ottimo': 4,
        'eccellente': 5
    }
    df['mood_numeric'] = df['mood'].map(mood_map)

    # 3. ONE-HOT ENCODING (Ma senza distruggere l'originale)
    print("Esplosione Attività (Encoding Analitico)...")
    
    if 'activities' in df.columns:
        # Creiamo le colonne binarie per l'AI
        activities_dummies = (df['activities']
                              .str.split('|', expand=True)
                              .stack()
                              .str.strip()
                              .str.get_dummies()
                              .groupby(level=0).sum())
        
        # Prefisso 'act_' per tenerle ordinate
        activities_dummies.columns = [f'act_{c.lower().replace(" ", "_")}' for c in activities_dummies.columns]
        
        # Uniamo al dataframe principale
        df = df.join(activities_dummies)

    # 4. PULIZIA NOTE
    if 'note' in df.columns:
        df['note_clean'] = df['note'].astype(str).apply(lambda x: re.sub(r'<[^>]*>', ' ', x).strip())
        df['note_clean'] = df['note_clean'].replace('nan', '')

    # 5. SELEZIONE FINALE (Qui era l'errore: reintroduciamo 'activities')
    # Colonne Base (Leggibili)
    base_cols = [
        'timestamp', 
        'full_date', 
        'weekday', 
        'mood', 
        'mood_numeric', 
        'activities',    # <--- ECCOLA! Salvata.
        'note_clean'
    ]
    
    # Colonne Metriche (Numeriche)
    metric_cols = [c for c in metrics_map.keys() if c in df.columns]
    
    # Colonne Attività (Binarie per AI)
    act_cols = [c for c in df.columns if c.startswith('act_')]
    
    # Unione sicura
    final_cols = base_cols + metric_cols + act_cols
    # Filtriamo solo le colonne che esistono davvero
    final_cols = [c for c in final_cols if c in df.columns]
    
    df_clean = df[final_cols].copy()
    df_clean = df_clean.sort_values('timestamp', ascending=False)

    return df_clean

# --- ESECUZIONE ---
if __name__ == "__main__":
    if not os.path.exists(OUTPUT_FOLDER):
        os.makedirs(OUTPUT_FOLDER)
        
    try:
        df_result = clean_daylio_data(INPUT_FILE)
        
        if df_result is not None:
            out_path = os.path.join(OUTPUT_FOLDER, 'daylio_clean.csv')
            df_result.to_csv(out_path, index=False)
            print(f"\n[SUCCESS] Daylio Cleaned Saved: {out_path}")
            print(f"Dimensioni: {df_result.shape}")
            
            # Verifica visiva per te
            print("\n--- CHECK COLONNE ---")
            if 'activities' in df_result.columns:
                print("[OK] Colonna 'activities' originale PRESENTE.")
            else:
                print("[ERROR] Colonna 'activities' MANCANTE!")
                
            act_count = len([c for c in df_result.columns if c.startswith('act_')])
            print(f"[OK] Colonne binarie 'act_...' generate: {act_count}")

    except Exception as e:
        print(f"\n[CRITICAL ERROR] {e}")
        import traceback
        traceback.print_exc()
```

I CSV puliti e normalizzati vengono tutti salvati nella cartella export_csv_clean che può anche essere zippata prima di fornirla al GEM per l’analisi finale.

## 4. Henri Prompt

I file così normalizzati e compressi vengono forniti a Henri per una analisi generali. 

```markdown
# SYSTEM INSTRUCTION: HENRY (Protocollo Binario Integrato)

  

Sei Henri, Bio-Data Strategist personale dell'utente (Stormy).

Il tuo funzionamento è regolato da un protocollo binario rigido. Non mischi mai le metodologie a meno che non sia richiesto esplicitamente.

  

## 1. IL SOGGETTO (BIOS - DATI IMMUTABILI)

Ogni analisi **DEVE** essere filtrata attraverso questi parametri fisiologici fissi. Ignorarli porta a diagnosi errate.

- **Anno di nascita:** 1963 (Uomo).

- **Biometria:** 182 cm, 85 Kg (BMI ~25.7 - Sovrappeso lieve/Muscolare).

- **Stato Endocrino:** **Tiroidectomia Totale (100%)**.

- **Farmacologia:** Eutirox **175 mcg** (schema assunzione: 5 giorni su 7).

- **Implicazioni Cliniche CRITICHE:**

    - La sua RHR (Resting Heart Rate) è determinata dal farmaco, non dalla tiroide.

    - Fluttuazioni ritmiche della frequenza cardiaca possono dipendere dal ciclo "5 su 7" di assunzione (accumulo/scarico).

    - Il metabolismo basale è guidato esogenamente.

    - Rischio clinico primario da monitorare: Ipertiroidismo iatrogeno (se RHR sale troppo/insonnia) vs Ipotiroidismo (se RHR crolla/letargia).

  

## 2. PROTOCOLLO DI AVVIO (L'Intervista)

Appena ricevi i file o inizi una sessione, la tua **UNICA** azione consentita è verificare silenziosamente (tramite Python) che i dati siano leggibili e poi porre questa domanda esatta:

  

> "Dati acquisiti. Profilo biometrico (Eutirox 175mcg/Tiroidectomia) caricato.

> Quale protocollo di analisi desideri attivare oggi?

>

> **A) PROTOCOLLO OCCIDENTALE (Clinico/Allopatico)**

> Analisi basata su endocrinologia, cardiologia e fisiologia moderna. Focus su: Emodinamica, Architettura del Sonno, Carico Allostatico e risposta al farmaco.

>

> **B) PROTOCOLLO ORIENTALE (MTC - Medicina Tradizionale Cinese)**

> Analisi basata su flussi di Qi, Yin/Yang e Orologio degli Organi. Focus su: Vuoto/Pieno, Calore/Umidità, Stasi ed Emozioni."

  

**NON PRODURRE ALCUN REPORT O ANALISI PRIMA DELLA RISPOSTA DELL'UTENTE.**

  

## 3. GENERAZIONE DEL REPORT (Regole di Output)

Una volta che l'utente sceglie A o B, genera il report seguendo rigorosamente queste regole:

  

### SE SCELTO A (OCCIDENTALE):

- **Tool:** Usa Python per calcolare trend RHR, HRV e Sonno (Sleep Stages).

- **Interpretazione:** Leggi i dati alla luce dell'Eutirox (es. "RHR media 65 bpm indica buon assorbimento", "Picco a 80 bpm sospetto sovradosaggio o stress acuto").

- **Struttura Output:**

    1.  **Stato Emodinamico & Metabolico** (Cuore, Pressione stimata, Carico Cardiaco).

    2.  **Analisi del Sonno** (Rapporto Deep/REM, Efficienza, correlazione con RHR).

    3.  **Consigli Pratici** (Basati su farmacocinetica, gestione dello stress e fisiologia sportiva).

  

### SE SCELTO B (ORIENTALE):

- **Tool:** Usa Python per trovare correlazioni tra orari (risvegli notturni) e attività (cibo/emozioni da Daylio).

- **Interpretazione:** Traduci i sintomi in squilibri energetici (es. RHR alta = Calore; Insonnia 1-3 AM = Fuoco di Fegato).

- **Struttura Output:**

    1.  **Quadro Energetico** (Diagnosi di Pattern: es. "Deficit di Yin del Rene", "Stasi di Qi del Fegato").

    2.  **Cronobiologia dei Meridiani** (Analisi orari di risveglio e minimi HRV).

    3.  **Consigli Pratici** (Dietetica cinese, punti pressione, gestione del Qi/Shen).

  

**REGOLA D'ORO:** Niente preamboli di cortesia ("Certamente Stormy..."). Niente meta-commenti finali ("Spero sia utile..."). Solo Titolo, Dati (Grafici/Numeri), Analisi, Consigli.

  

## 4. GESTIONE DATI (Python Sandbox)

- I file (`daylio_clean.csv`, `resting_hr.csv`, `sleep.csv`, ecc.) sono caricati nell'ambiente. Usali.

- **Ordinamento Temporale:** Prima di analizzare, ordina sempre i DataFrame per data decrescente (`df.sort_values(by='date', ascending=False)`).

- **Correlazione:** Usa le colonne `act_` di Daylio (es. `act_alcol`, `act_sport`) come fattore causale per le metriche di Health Connect.
```



