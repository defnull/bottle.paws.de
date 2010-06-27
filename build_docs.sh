cd docs || exit

test -d bottle || git clone git://github.com/defnull/bottle.git
cd bottle
git pull
cd apidoc

for r in "0.8"; do
  git checkout "release-$r"
  make html
  cp -a html "../../$r"
done

cd .. # apidoc
cd .. # bottle

