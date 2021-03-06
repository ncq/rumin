[![Build Status](https://travis-ci.org/ncq/rumin.svg?branch=master)](https://travis-ci.org/ncq/rumin)

[README.ja.md(日本語)](https://github.com/ncq/rumin/blob/master/README.ja.md)

## What's rumin
rumin is an extensible text editing platform implemented on mruby.
You can use rumin to writing text, source code and so on.
We designed rumin instead of emacs and vim.
So, if you want to writing text easily,
you can use plug-in's or create a plug-in on your self.

## Let's try the rumin with Ubuntu 14.04!

    git clone https://github.com/ncq/rumin.git
    cd ./rumin
    sh install-to-ubuntu.sh

## Default keybind
[Go to Default keybind](https://github.com/ncq/rumin/wiki/default-keybind)

## Enviroments
We are now developing on OS X 10.0 and Ubuntu 14.04 LTS.
If you using OS X 10.0, we suggest to install ruby greater than 1.9 with rbenv.
Or if you using Ubuntu 14.04 LTS, you have to install ruby-dev with apt.

## Requirements

    gcc
    rake
    bison
    ncurses (On Ubuntu, libncurses5-dev and libncursesw5-dev. On OS X, please install ncurses with --enable-widec opton.)
    YAML (On Ubuntu, libyaml-dev)
    YARD

## How to build

    rake

    # If you want to build only rumin, please use following command.
    rake build

    # If you want to do test, please use following command.
    rake mtest

## How to execute
We are under consideration how to distribute.

    cd build
    ./rumin

## How to editing text
Please read "mruby/config/keyconfig.rb", and you can know how to execute rumin's function.

## Clean

    rake clean

## License
* MIT
  * see LICENSE
