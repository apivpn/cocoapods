#!/bin/bash

rm -f ApiVPN/site.dat
rm -f ApiVPN/geo.mmdb
rm -f /tmp/mmdb.tar.gz
rm -f /tmp/geo.mmdb
rm -rf /tmp/GeoLite2-Country_20191224

curl -L -o "ApiVPN/site.dat" "https://github.com/v2fly/domain-list-community/releases/download/20230106031328/dlc.dat"

curl -L -o "/tmp/mmdb.tar.gz" "https://web.archive.org/web/20191227182412/https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz"
wd=`pwd`
cd /tmp/
tar -xf mmdb.tar.gz
mv GeoLite2-Country_20191224/GeoLite2-Country.mmdb geo.mmdb
cd $wd
mv /tmp/geo.mmdb ApiVPN/geo.mmdb
