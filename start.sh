#!/usr/bin/env bash

basepath=$(
    cd $(dirname $0)
    pwd
)

if [ -z $@ ]; then
    version='2.2.8'
else
    version="$@"
fi

mkdir apps
app_name="haproxy"
app_dir="$app_name-$version"
app_pkg_name="$app_name-$version"
MAKE_OPT="make -j $(nproc) ARCH=x86_64 TARGET=generic USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1 USE_CPU_AFFINITY=1 PREFIX=$basepath-$app_dir"

_make_install() {
    wget -c http://www.haproxy.org/download/${version%.[0-9]}/src/${app_name}-${version}.tar.gz
    ls
}

_make_install "$@"

gh release delete ${app_pkg_name} -y

# gh release create ${PKGNAME} ./*.tar.xz --title "${PKGNAME} (beta)" --notes "this is a nginx beta release" --prerelease
gh release create ${app_pkg_name} $app_pkg_name.tar.xz --title "${app_pkg_name}" --notes "this is a make haproxy release"