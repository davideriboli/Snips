---
tags:
  - linux/arch
  - linux/endeavour
  - mkdocs
  - mkdocs/material
  - site
  - generator
  - python
---
Installing [MkDocs](https://www.mkdocs.org/) or [Material MkDocs](https://squidfunk.github.io/mkdocs-material/) used to take no more than thirty seconds, but since it has become mandatory in several linux distros to run Python in virtual environments, things have gotten a little more complicated. These are the commands I use, under [Arch](https://archlinux.org/) or [EndeavourOS](https://endeavouros.com/).

#### Create the Venv

This one is to add the venv to your working directory:

```python
python -m venv YOUR-FUTURE-SITE-DIR
```

#### Activate the Venv

Engine start:

```shell
source YOUR-FUTURE-SITE-DIR/bin/activate
```

#### Upgrade PIP

There's no life without it : )

```python
pip install --upgrade pip
``` 

#### Install everything

This is what I need. You can add other extensions or remove what you don't use.

```python
pip install mkdocs-material mkdocs-material-extensions mkdocs-glightbox Pillow cairosvg
``` 

#### Create your site

Now you can [create your basic site](https://squidfunk.github.io/mkdocs-material/creating-your-site/) that will grow with your contents and your graphics. If there's no output, probably you'll need another _activate_ command.


#### Render your site

Generate the HTML and CSS for your site with:

```shell
mkdocs build
```

The script will create a new _site_ folder to upload to your server.

#### Stop everything

Don't leave your box without deactivating the venv. Launch cmd in the venv folder.

```shell
deactivate
```