[![Build Status](https://travis-ci.org/ncq/rumin.svg?branch=master)](https://travis-ci.org/ncq/rumin)

## What's rumin
rumin is an extensible text editing platform implemented on mruby.
You can use rumin to writing text, source code and so on.
We designed rumin instead of emacs and vim.
So, if you want to writing text easily, 
you can use plug-in's or create a plug-in on your self.

## Enviroments
We are now developing on OS X 10.0 and Ubuntu 14.04 LTS.
If you using OS X 10.0, we suggest to install ruby greater than 1.9 with rbenv.
Or if you using Ubuntu 14.04 LTS, you have to install ruby-dev with apt.

## Requirements

    clang
    rake
    bison
    ncurses (On Ubuntu, libncurses5-dev and libncursesw5-dev)
    YAML (On Ubuntu, libyaml-dev)

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
