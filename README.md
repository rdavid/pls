# Pls [![Build Status](https://travis-ci.org/rdavid/pls.svg)](https://travis-ci.org/rdavid/pls) [![Build status](https://ci.appveyor.com/api/projects/status/yqxb43ltxrjj776a?svg=true)](https://ci.appveyor.com/project/rdavid/pls) ![Ruby](https://github.com/rdavid/pls/workflows/Ruby/badge.svg) [![Gem Version](https://badge.fury.io/rb/pls.svg)](https://badge.fury.io/rb/pls) [![Maintainability](https://api.codeclimate.com/v1/badges/5e21a1c1f8a3923584e3/maintainability)](https://codeclimate.com/github/rdavid/pls/maintainability) [![Hits-of-Code](https://hitsofcode.com/github/rdavid/pls)](https://hitsofcode.com/view/github/rdavid/pls) [![License](https://img.shields.io/badge/license-0BSD-green)](https://github.com/rdavid/pls/blob/master/LICENSE)
Prints the full NodeJS package dependency tree based on a given package name.

* [About](#about)
* [Installation](#installation)
* [Usage](#usage)
* [License](#license)

## About
Developers working with NodeJS use packages in their code. A package is a
functional NodeJS module that includes versioning, documentation, dependencies
(in the form of other packages), and more. NodeJS has a managed packages
environment called npm. npm is regularly updated with new packages and new
versions of existing packages. The user provides the name of the package for
analysis. The tool fetches the overall set of dependencies from the relevant
package manager, for the given package.

## Installation
The tool is designed to work on macOS, GNU/Linux, Windows, Unix-like OS. It is
packaged as a Gem and require Ruby version 2.6 or later.  See “[Installing
Ruby](https://www.ruby-lang.org/en/documentation/installation/)” if you don't
have the proper version on your platform.

Use this command to install:

    gem install pls

### Updating
Use this command to update the package:

    gem update pls

## Usage
    pls [options]
      -p, --pac package                Package name.
      -v, --version                    Shows version.

### Example
    pls -p express

## License
Pls is copyright [David Rabkin](http://cv.rabkin.co.il) and
available under a [Zero-Clause BSD license](https://github.com/rdavid/pls/blob/master/LICENSE).
