# dirx [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
Select a directory from an options list and change into it.

# Install

```bash
$ npm install -g dirx
$ dirx-cli install

$ git clone https://github.com/Gyumeijie/dirx.git
$ cd dirx
$ npm install
$ ./install.sh
```

# Usage
```bash
$ dirx
```
![](./dirx.png)

# Feature

Support sorting accessed directories by `frequence` and `access time`. You can use different sorting strategy by:

```bash
$ dirx-cli set-strategy "frequence"

$ dirx-cli set-strategy "accessTime"
```