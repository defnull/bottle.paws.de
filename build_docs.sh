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
rm -rf html sphinx/build/*

echo "Build documentation (HTML)..."
make html &>build-html.log || echo "  Sphinx html build failed."
rm -rf "$docs_root/$name" &> /dev/null
cp -a html "$docs_root/$name"

echo "Build documentation (PDF)..."
make latex &>build-latex.log || echo "  Sphinx latex build failed."
cd sphinx/build/latex
make all-pdf &>build-pdf.log || echo "  Sphinx pdf build failed."
echo "  PDF: $docs_root/$name/bottle-docs.pdf"
cp Bottle.pdf "$docs_root/$name/bottle-docs.pdf"
cd ../../../

echo
echo "Make file downloads..."
cd "$bottle_rep/apidoc" || cd "$bottle_rep/docs"
echo "  $archive.tar.gz"
tar -czf "$archive.tar.gz" -C "$bottle_rep/apidoc" html
echo "  $archive.tar.bz2"
tar -cjf "$archive.tar.bz2" -C "$bottle_rep/apidoc" html
echo "  $archive.zip"
(cd "$bottle_rep/apidoc"; zip -q -r -9 "$archive.zip" html)
echo "  $docs_root/$name/bottle-$release.tar.gz"
cp "$bottle_rep/dist/bottle-$release.tar.gz" "$docs_root/$name/"
echo "  $docs_root/$name/bottle.py"
cp "$bottle_rep/build/lib/bottle.py" "$docs_root/$name/"


echo
echo "Cleaning up..."
echo "  Sphinx builds..."
rm -rf "$bottle_rep/apidoc/html"
echo "  Bottle builds..."
rm -rf "$bottle_rep/build"

