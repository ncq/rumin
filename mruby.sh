#!/bin/bash

if test -e ./runtime; then
    echo 'mruby is already exists in runtime directory. Then skip to clone mruby.'
else
    git clone https://github.com/mruby/mruby.git runtime
    cp mruby/config/build_config.rb runtime
fi

if test -e ./runtime/build/host/lib/libmruby.a; then
    echo 'mruby is already compiled. Then skip to compile mruby.'
else
    cd runtime && ruby ./minirake
fi
