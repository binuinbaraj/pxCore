#!/bin/bash -e

EXT_INSTALL_PATH=$PWD/extlibs

CWD=$PWD

DIRECTORY=$(cd `dirname $0` && pwd)

pushd $DIRECTORY
    if [[ "$#" -eq "1" && "$1" == "--clean" ]]; then
        quilt pop -afq || test $? = 2
        make distclean
    elif [[ "$#" -eq "1" && "$1" == "--force-clean" ]]; then
        git clean -fdx .
        git checkout .
    else
        tar --strip-components=1 -xf glib-2.48.2.tar.xz
        PATH=$EXT_INSTALL_PATH/bin:$PATH LD_LIBRARY_PATH=$EXT_INSTALL_PATH/lib:$LD_LIBRARY_PATH PKG_CONFIG_PATH=$EXT_INSTALL_PATH/lib/pkgconfig:$PKG_CONFIG_PATH CFLAGS="-I$EXT_INSTALL_PATH/include" LDFLAGS="-L$EXT_INSTALL_PATH/lib" ./configure \
        --prefix=$EXT_INSTALL_PATH --disable-dependency-tracking \
        --disable-gtk-doc --enable-included-printf=no --disable-dtrace --disable-fam --disable-libelf \
        --disable-systemtap --disable-man  --with-pcre=system --enable-nls --disable-installed-tests
        PATH=$EXT_INSTALL_PATH/bin:$PATH make -j$(getconf _NPROCESSORS_ONLN)
        make install
    fi
popd

