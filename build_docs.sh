cd docs || exit

test -d bottle || git clone git://github.com/defnull/bottle.git
git fetch origin
cd bottle

for r in "0.8"; do
  git checkout -b "release-$r" "origin/release-$r" &>/dev/null || git merge "origin/release-$r"
  cd apidoc
  make html
  cp -a html "../../$r"
  cd ..
done

cd .. # bottle

