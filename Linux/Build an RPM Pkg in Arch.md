---
tags: [linux/arch, linux/endeavour]
---

REF: https://www.baeldung.com/linux/install-rpm-arch-based-distros

- Download software.rpm
- Create PKGBUILD

```shell
pkgname=softwaretoinstall
pkgver=2.89
pkgrel=1
pkgdesc="A powerful software to install"
arch=('x86_64')

source=('software.rpm')

sha256sums=('SKIP')

package() {
  find $srcdir/ -mindepth 1 -maxdepth 1 -type d | xargs cp -r -t "$pkgdir"
}
```

- Open terminal there and then
```shell
makepkg -si
```
