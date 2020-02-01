#!/bin/sh
echo 'Set vars'
dlurl="https://updates.duplicati.com/beta/duplicati-2.0.5.1_beta_2020-01-18.zip"
duplicati_dir="/usr/local/share/duplicati"
duplicati_conf_dir="/config"

echo 'enable svc'
# Enable the service
chmod u+x /usr/local/etc/rc.d/duplicati
sysrc "duplicati_enable=YES"

echo 'make dirs'
mkdir -p $duplicati_conf_dir
mkdir -p $duplicati_dir
echo 'get installer'
cd $duplicati_dir
fetch $dlurl -o duplicati.zip
unzip duplicati.zip
rm duplicati.zip
echo 'create user and set perms'
pw user add duplicati -c duplicati -d /nonexistent -s /usr/bin/nologin
chown -R duplicati:duplicati $duplicati_dir
chown -R duplicati:duplicati $duplicati_conf_dir

echo 'start service'
# Start the service
if $(service duplicati start) ; then
    echo "Starting duplicati."
fi
