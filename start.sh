#!/bin/bash
set -e

# Make sure we are in the right directory
cd `dirname $0`

# Download bottle module
wget -nv -O bottle.py --no-check-certificate http://bottlepy.org/bottle.py

# Start 4 new processes
for n in 0 1 2 3; do
  pidfile="run-$n.pid"
  /sbin/start-stop-daemon --stop --oknodo --pidfile $pidfile
  /sbin/start-stop-daemon --start --background --startas ./app.py --chdir `pwd`  \
                          --make-pidfile --pidfile $pidfile -- "808$n"
done

