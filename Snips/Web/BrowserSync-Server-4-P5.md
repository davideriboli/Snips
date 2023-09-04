---
tags: [javascript, p5]
---
REF: [https://browsersync.io/docs/command-line](https://browsersync.io/docs/command-line).

1. Instal Node.js via regular download regolare or with Chocolatey/Brew. Choose the _Long Time Support_ version.

```shell
choco install nodejs-lts
``` 

2. Install browser-sync via nodejs.

```shell
npm install -g browser-sync
``` 

3. Code a P5 sketch P5.js.
4. Open the folder of your P5 sketch in terminal and cmd:

```shell
browser-sync start --server --directory --files "*"
``` 

5. Stop browser-sync with: **CTRL + C**.