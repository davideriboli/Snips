---
title: Processing in Sublime sotto Linux
pub date: 2024-06-13 | 17:27
tags:
  - linux
  - processing
---

1. Installare il supporto a Processing via PackageControl

2. Esportare il PATH della cartella di Processing

```shell
export PATH=$PATH:/home/stormy/Apps/processing-4.3
```

3. Creare un alias di processing-java in bin

```shell
sudo ln -s /home/stormy/Apps/processing-4.3/processing-java /bin/processing-java
```