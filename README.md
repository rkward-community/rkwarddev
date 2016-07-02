# rkwarddev

[![Flattr this git repo](https://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=tfry&url=https://github.com/rkward-community/rkwarddev&title=rkwarddev&language=en_GB&tags=github&category=software)

The R package rkwarddev is a collection of tools for [RKWard](https://rkward.kde.org) plugin development.

RKWard is a powerful GUI and IDE for [R](https://r-project.org), and most of it's functionality is provided by plugins.
These plugins can be [distributed as R packages](https://files.kde.org/rkward/R) (or added to them), and there's comprehensive
[documentation](http://api.kde.org/doc/rkwardplugins/) on how to extend RKWard with your own plugins.

rkwarddev is intended to make plugin development more comfortable and much faster. It automates a lot of the neccessary steps
like setting up correct directory structures or maintaining mandatory files. With rkwarddev, you can write a plugin generator
script in R -- have a look at the [vignette](/inst/doc/rkwarddev_vignette.pdf?raw=true "rkwarddev vignette").
It also adds a GUI dialog to RKWard'S export menu to help you write your script.

It will **only work in conjunction with RKWard**. However, RKWard is free software, please [check it out](https://rkward.kde.org).

## Installation

### Installation via R

You can install the package directly from [RKWard's package repository](https://files.kde.org/rkward/R):

```
install.packages("rkwarddev", repos="https://files.kde.org/rkward/R/")
```

There are also pre-built [Debian/Ubuntu packages](https://files.kde.org/rkward/R/pckg/rkwarddev/deb_repo.html).

### Installation via GitHub

To install it directly from GitHub, you can use `install_github()` from the [devtools](https://github.com/hadley/devtools) package:

```
library(devtools)
install_github("rkward-community/rkwarddev") # stable release
install_github("rkward-community/rkwarddev", ref="develop") # development release
```
 
## Licence

Copyright 2010-2015 Meik Michalke <meik.michalke@hhu.de>

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