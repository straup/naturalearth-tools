#!/bin/sh

OGR2OGR=`which ogr2ogr`
SHP2PGSQL=`which shp2pgsql`
PSQL=`which psql`

ROOT=$1
MERC="${ROOT}/900913"

mkdir -p ${MERC}

for SHP in `ls -a ${ROOT}/*.shp`
do
    DIR=`dirname ${SHP}`
    BASE=`basename ${SHP}`

    TABLE=`echo ${BASE} | awk '{split($0, parts, "."); print parts[1]}'`

    echo "[${TABLE}] reproject"

    # ${OGR2OGR} -f "ESRI Shapefile" -t_srs EPSG:900913 ${MERC}/900913_${BASE} ${DIR}/${BASE} 

    echo "[${TABLE}] prepare sql"

    ${SHP2PGSQL} -s 900913 -c -I ${MERC}/900913_${BASE} ${TABLE} > ${MERC}/900913_${TABLE}.sql

    echo "[${TABLE}] import sql"

    ${PSQL} -U naturalearth < ${MERC}/900913_${TABLE}.sql

done
    