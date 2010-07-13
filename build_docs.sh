if test $# -ne 2; then
  echo "Usage: $0 branch-name folder-name"
  echo "Example: $0 master dev"
  exit 0
fi

branch=$1
name=$2

cd `dirname $0`
root=`pwd`
docs_root="$root/docs"
files_root="$root/files"
bottle_rep="$root/bottle.git"

# Update repository and checkout branch
test -d $bottle_rep || git clone git://github.com/defnull/bottle.git $bottle_rep
cd $bottle_rep
git fetch origin
git checkout "origin/$branch"
git clean -d -f
rm -rf apidoc/sphinx/build/*

# Make documentation
cd apidoc
rm -rf html &> /dev/null
make html
rm -rf "$docs_root/$name" &> /dev/null
cp -a html "$docs_root/$name"

# Make file downloads
tar -czf "$docs_root/$name/bottle-docs.tar.gz" -C "$bottle_rep/apidoc" html
tar -cjf "$docs_root/$name/bottle-docs.tar.bz2" -C "$bottle_rep/apidoc" html

# Make builds
cd $bottle_rep
python setup.py build
cp build/lib/bottle.py "$docs_root/$name/"
