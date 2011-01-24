if test $# -ne 2; then
  echo "Usage: $0 branch-name folder-name"
  echo "Example: $0 master dev"
  exit 0
fi

branch=$1
name=$2

echo
echo "Setup..."
cd `dirname $0`
root=`pwd`
docs_root="$root/docs"
echo "  Docs root: $docs_root"
files_root="$root/files"
echo "  Files root: $files_root"
bottle_rep="$root/bottle.git"
echo "  Bottle repository: $bottle_rep"
archive="$docs_root/$name/bottle-docs"
echo "  Archive base: $archive"

echo
echo "Update repository and checkout branch..."
test -d $bottle_rep || git clone git://github.com/defnull/bottle.git $bottle_rep | sed "s/^/  /"
cd $bottle_rep
git fetch origin | sed "s/^/  /"
git checkout "origin/$branch" 2>&1 | sed "s/^/  /"
git clean -d -f | sed "s/^/  /"

echo
echo "Build bottle.py..."
cd $bottle_rep
python setup.py build sdist | sed "s/^/  /"
release=`PYTHONPATH="build/lib" python -c "import bottle;print bottle.__version__"`
echo "  Release is: Bottle-$release"

echo
echo "Sphinx run..."
cd "$bottle_rep/apidoc" || cd "$bottle_rep/docs"
rm -rf /tmp/sphinx

echo "Build documentation (HTML)..."
sphinx-build -b html -c sphinx -d /tmp/sphinx/doctree . /tmp/sphinx/html 2>/dev/null | sed 's/^/  /'
cp -a /tmp/sphinx/html "$docs_root/$name"

echo "Build documentation (PDF)..."
sphinx-build -b latex -c sphinx -d /tmp/sphinx/doctree -D latex_paper_size=a4 . /tmp/sphinx/latex 2>/dev/null | sed 's/^/  /'
make -C /tmp/sphinx/latex all-pdf &>/dev/null | sed 's/^/  /'
cp /tmp/sphinx/latex/Bottle.pdf "$docs_root/$name/bottle-docs.pdf"
echo "  PDF: $_"

echo
echo "Make file downloads..."
echo "  $archive.tar.gz"
tar -czf "$archive.tar.gz" -C /tmp/sphinx html
echo "  $archive.tar.bz2"
tar -cjf "$archive.tar.bz2" -C /tmp/sphinx html
echo "  $archive.zip"
(cd /tmp/sphinx; zip -q -r -9 "$archive.zip" html)
echo "  $docs_root/$name/bottle-$release.tar.gz"
cp "$bottle_rep/dist/bottle-$release.tar.gz" "$docs_root/$name/"
echo "  $docs_root/$name/bottle.py"
cp "$bottle_rep/build/lib/bottle.py" "$docs_root/$name/"


echo
echo "Cleaning up..."
echo "  Sphinx builds..."
rm -rf /tmp/sphinx
echo "  Bottle builds..."
rm -rf "$bottle_rep/build"
rm -rf "$bottle_rep/dist"

