#!/bin/sh

dlurl="https://updates.duplicati.com/beta/duplicati-2.0.5.1_beta_2020-01-18.zip"
duplicati_dir="/usr/local/share/duplicati"
duplicati_conf_dir="/config"

# Enable the service
chmod u+x /usr/local/etc/rc.d/duplicati
sysrc "duplicati_enable=YES"

mkdir -p $duplicati_conf_dir
mkdir -p $duplicati_dir
cd $duplicati_dir
curl -o duplicati.zip $dlurl
unzip duplicati.zip
rm duplicati.zip
pw user add duplicati -c duplicati -d /nonexistent -s /usr/bin/nologin
chown -R duplicati:duplicati $duplicati_dir
chown -R duplicati:duplicati $duplicati_conf_dir

# Start the service
if $(service duplicati start) ; then
    echo "Starting duplicati."
fi
