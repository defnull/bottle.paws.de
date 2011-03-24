# Make sure we are in the right directory
cd `dirname $0`

# Update homepage
git checkout master
git pull

# Copy bottle executable
rm bottle.py
wget --no-check-certificate https://github.com/defnull/bottle/raw/master/bottle.py

#config
ssdopts="--background --startas ./app.py --group www-data --chuid www-data --make-pidfile"
ssdopts="$ssdopts --chdir `pwd`"

#Start 4 instances of the server (8080-8084)
for n in 0 1 2 3; do
  echo "$n: Killing old instance..."
  pid="/var/run/bottle.$n.pid"
  kill `cat $pid` &>/dev/null && sleep 1
  echo "$n: Starting new one..."
  start-stop-daemon --start $ssdopts --pidfile $pid -- "808$n"
done
echo 'Done'

