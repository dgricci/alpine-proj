#!/bin/bash

# Exit on any non-zero status.
trap 'exit' ERR
set -E

echo "Compiling PROJ-${PROJ_VERSION}..."
01-install.sh

NPROC=$(nproc)
cd /tmp
wget --no-verbose "$PROJ_DOWNLOAD_URL"
wget --no-verbose "$PROJ_DOWNLOAD_URL.md5"
md5sum --strict -c proj-$PROJ_VERSION.tar.gz.md5
tar xzf proj-$PROJ_VERSION.tar.gz
rm -f proj-$PROJ_VERSION.tar.gz*
mkdir -p proj-$PROJ_VERSION/nad
wget --no-verbose "$PROJ_DATUM_DOWNLOAD_URL"
tar xzf proj-datumgrid-1.8.tar.gz -C proj-$PROJ_VERSION/nad
rm -f proj-datumgrid-1.8.tar.gz
wget --no-verbose "$PROJ_EUROPE_DATUM_DOWNLOAD_URL"
tar xzf proj-datumgrid-europe-1.1.tar.gz -C proj-$PROJ_VERSION/nad
rm -f proj-datumgrid-europe-1.1.tar.gz
wget --no-verbose "$PROJ_NORTHAMERICA_DATUM_DOWNLOAD_URL"
tar xzf proj-datumgrid-north-america-1.1.tar.gz -C proj-$PROJ_VERSION/nad
rm -f proj-datumgrid-north-america-1.1.tar.gz
{ \
    cd proj-$PROJ_VERSION ; \
    ./configure --prefix=/usr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr proj-$PROJ_VERSION ; \
}

# uninstall and clean
01-uninstall.sh y

exit 0

