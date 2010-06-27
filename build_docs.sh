cd docs || exit

test -d bottle || git clone git://github.com/defnull/bottle.git
cd bottle
git pull

for r in "0.8"; do
  git checkout "release-$r"
  cd apidoc
  make html
  cp -a html "../../$r"
  cd ..
done

cd .. # bottle

