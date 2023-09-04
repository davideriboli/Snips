---
tags: [dirty tricks, ftp, worddpress]
---
Add this in _wp-config.php_.

```php
/** FTP trick. **/
define('FS_METHOD', 'direct');
```