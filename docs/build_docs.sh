cd `dirname $0`
root=`pwd`

test -d bottle || git clone git://github.com/defnull/bottle.git
git fetch origin

function build { # branch, name
  cd "$root/bottle"
  git checkout "origin/$1"
  cd apidoc
  rm -rf html &> /dev/null
  make html
  cp -a html "$root/$2/"
  tar -cvzf "$root/$2/bottle-docs-$2.tar.gz" html
  tar -cvjf "$root/$2/bottle-docs-$2.tar.bz2" html
  cp -p ../bottle.py "$root/$2/"
}

build release-0.8 0.8
build master dev
