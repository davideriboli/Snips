---
tags: [linux, server, amp]
---
- Recupero proprietà

```shell
sudo chown -R ID:GROUP /opt/lampp/htdocs
``` 

- Permessi scrittura

```shell
sudo chmod -R 777 /opt/lampp/htdocs
``` 

- E se è necessario, stessa cosa per WP.

```shell
sudo chmod -R 777 /opt/lampp/htdocs/wordpress
```