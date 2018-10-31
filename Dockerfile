## PROJ.4 - Cartographic Projections Library 
FROM dgricci/alpine-dev:1.0.0
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL       version="1.0.0" \
            proj="v5.2.0" \
            os="Alpine Linux 3.8" \
            description="PROJ library and software with datum installed"

## arguments
ARG PROJ_VERSION
ENV PROJ_VERSION ${PROJ_VERSION:-5.2.0}
ARG PROJ_DOWNLOAD_URL
ENV PROJ_DOWNLOAD_URL ${PROJ_DOWNLOAD_URL:-http://download.osgeo.org/proj/proj-$PROJ_VERSION.tar.gz}
ARG PROJ_DATUM_DOWNLOAD_URL
ENV PROJ_DATUM_DOWNLOAD_URL ${PROJ_DATUM_DOWNLOAD_URL:-http://download.osgeo.org/proj/proj-datumgrid-1.8.tar.gz}
ARG PROJ_EUROPE_DATUM_DOWNLOAD_URL
ENV PROJ_EUROPE_DATUM_DOWNLOAD_URL ${PROJ_EUROPE_DATUM_DOWNLOAD_URL:-http://download.osgeo.org/proj/proj-datumgrid-europe-1.1.tar.gz}
ARG PROJ_NORTHAMERICA_DATUM_DOWNLOAD_URL
ENV PROJ_NORTHAMERICA_DATUM_DOWNLOAD_URL ${PROJ_NORTHAMERICA_DATUM_DOWNLOAD_URL:-http://download.osgeo.org/proj/proj-datumgrid-north-america-1.1.tar.gz}

COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && rm -f /tmp/build.sh

# Externally accessible data is by default put in /geodata
# use -v at run time !
WORKDIR /geodata

# Output capabilities by default.
CMD ["proj", "-l"]

