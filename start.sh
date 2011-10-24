# Make sure we are in the right directory
cd `dirname $0`

# Update homepage
#git checkout master
#git pull
git fetch
git status

# Download bottle module
wget -O bottle.py --no-check-certificate https://github.com/defnull/bottle/raw/master/bottle.py

#config

# Start 4 new processes
for n in 0 1 2 3; do
  pidfile="/var/run/bottlepy.$n.pid"
  echo "$n: Killing old instance..."
  /sbin/start-stop-daemon --stop  --pidfile $pidfile --group www-data --chuid www-data
  echo "$n: Starting new instance..."
  /sbin/start-stop-daemon --start --background --startas ./app.py \
                            --group www-data --chuid www-data --chdir `pwd` \
                            --make-pidfile --pidfile $pidfile -- "808$n"
done
echo 'Done'

