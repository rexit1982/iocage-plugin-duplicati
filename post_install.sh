#!/bin/sh

# Enable the service
chmod u+x /usr/local/etc/rc.d/duplicati
sysrc "duplicati_enable=YES"

# Start the service
if $(service duplicati start) ; then
    echo "Starting duplicati."
fi
