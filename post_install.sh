#!/bin/sh

#vars
dlurl="https://updates.duplicati.com/beta/duplicati-2.0.5.1_beta_2020-01-18.zip"
duplicati_dir="/usr/local/share/duplicati"
duplicati_conf_dir="/config"

# Enable the service
chmod u+x /usr/local/etc/rc.d/duplicati
sysrc "duplicati_enable=YES"

# Set rc.conf values for plugin editable values
sysrc "duplicati_port=8200"
sysrc "duplicati_web_pass=duplicati"

# Create config and db dirs
mkdir -p $duplicati_conf_dir
mkdir -p $duplicati_dir
cd $duplicati_dir
fetch $dlurl -o duplicati.zip
unzip duplicati.zip
rm duplicati.zip
pw user add duplicati -c duplicati -d /nonexistent -s /usr/bin/nologin
chown -R duplicati:duplicati $duplicati_dir
chown -R duplicati:duplicati $duplicati_conf_dir

echo "Default Web password: duplicati" > /root/PLUGIN_INFO
echo "Default web port: 8200" >> /root/PLUGIN_INFO
echo "Service user and group: duplicati" >> /root/PLUGIN_INFO
echo "To change settings until the UI is fixed use the command line.  Example: iocage get -P port PLUGIN" >> /root/PLUGIN_INFO
echo "Configurable settings are port and webpass." >> /root/PLUGIN_INFO

#Thank you Asigra via ConorBeh for this hack
echo "Find Network IP"
#Very Dirty Hack to get the ip for dhcp, the problem is that IOCAGE_PLUGIN_IP doesent work on DCHP clients
netstat -nr | grep lo0 | grep -v '::' | grep -v '127.0.0.1' | awk '{print $1}' | head -n 1 > /root/dhcpip
IP=`cat /root/dhcpip`

# Start the service
service duplicati start

echo "------Plugin Info------"
echo "Access Web interface to configure http://${IP}:8200"
echo "Default Web Password: duplicati"
echo "Default web port: 8200"
echo "Service user and group: duplicati" 
echo "To change settings until the UI is fixed use the command line.  Example: iocage get -P port PLUGIN"
echo "Configurable settings are port and webpass." 