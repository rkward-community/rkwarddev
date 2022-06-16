# rkwarddev

The R package rkwarddev is a collection of tools for [RKWard](https://rkward.kde.org) plugin development.

RKWard is a powerful GUI and IDE for [R](https://www.r-project.org/), and most of it's functionality is provided by plugins.
These plugins can be [distributed as R packages](https://files.kde.org/rkward/R/) (or added to them), and there's comprehensive
[documentation](https://docs.kde.org/trunk5/en/rkward/rkwardplugins/index.html) on how to extend RKWard with your own plugins.

rkwarddev is intended to make plugin development more comfortable and much faster. It automates a lot of the neccessary steps
like setting up correct directory structures or maintaining mandatory files. With rkwarddev, you can write a plugin generator
script in R -- have a look at the [vignette](inst/doc/rkwarddev_vignette.html "rkwarddev vignette").
It also adds a GUI dialog to RKWard'S export menu to help you write your script.

It will **only work in conjunction with RKWard**. However, RKWard is free software, please [check it out](https://rkward.kde.org).

## Installation

### Installation via R

You can install the package directly from [RKWard's package repository](https://files.kde.org/rkward/R/):

```
install.packages("rkwarddev", repos="https://files.kde.org/rkward/R/")
```

There are also pre-built [Debian/Ubuntu packages](https://files.kde.org/rkward/R/pckg/rkwarddev/deb_repo.html).

### Installation via GitHub

To install it directly from GitHub, you can use `install_github()` from the [devtools](https://github.com/r-lib/devtools) package:

```
devtools::install_github("rkward-community/rkwarddev") # stable release
devtools::install_github("rkward-community/rkwarddev", ref="develop") # development release
```

### Installation via RKWard

If you're running RKWard >= 0.7.3, the following links should open an installation dialog:

* <a href="rkward://runplugin/Installfromgit::cmp_InstallfromgitInstllfrmgt/frm_Prvtrpst.checked=0%0AgitRepo.text=rkwarddev%0AgitUser.text=rkward-community%0Ainp_Cmmttgbr.text=%0Ainp_Sbdrctry.text=%0ApackageSource.string=github">Install stable release</a>
* <a href="rkward://runplugin/Installfromgit::cmp_InstallfromgitInstllfrmgt/frm_Prvtrpst.checked=0%0AgitRepo.text=rkwarddev%0AgitUser.text=rkward-community%0Ainp_Cmmttgbr.text=develop%0Ainp_Sbdrctry.text=%0ApackageSource.string=github">Install development release</a>

## Contributing

To ask for help, report bugs, suggest feature improvements, or discuss the global
development of the package, please use the issue tracker on GitHub.
Alternatively, you can subscribe to the [RKWard development mailing list](https://mail.kde.org/mailman/listinfo/rkward-devel)
for help, reports and requests.

### Branches

Please note that all development happens in the `develop` branch. Pull requests against the `master`
branch will be rejected, as it is reserved for the current stable release.

## Licence

Copyright 2010-2022 Meik Michalke <meik.michalke@hhu.de>

rkwarddev is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

rkwarddev is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with rkwarddev.  If not, see <http://www.gnu.org/licenses/>.
