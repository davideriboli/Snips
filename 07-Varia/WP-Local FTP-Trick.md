---
tags: [wordpress, php, ftp, trick]
os: cross
aggiornato: 2024-11-21
---
Add this in _wp-config.php_.

```php
/** FTP trick. **/
define('FS_METHOD', 'direct');
```