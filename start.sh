# Make sure we are in the right directory
cd `dirname $0`

# Update homepage
git checkout master
git pull

# Build documentation
./build_docs.sh release-0.8 0.8
./build_docs.sh plugins plugins
./build_docs.sh master dev

# Copy bottle executable
cp files/dev/bottle.py .

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

