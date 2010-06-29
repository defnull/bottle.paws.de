cd `dirname $0`

test -d bottle || git clone git://github.com/defnull/bottle.git
git fetch origin
cd bottle

for r in "0.8"; do
  git checkout "origin/release-$r"
  cd apidoc
  make html
  cp -a html "../../$r"
  cd ..
  cp -p bottle.py "../$r"
done

# snapshot
git checkout "origin/master"
cd apidoc
make html
cp -a html "../../dev"
cp -a ../bottle.py "../../dev"
