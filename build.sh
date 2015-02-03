#!/usr/bin/env bash

# Install globally needed tooling
npm install -g grunt-cli uglifyjs
npm install

# Update submodules
git submodule update

# Install Readium.js dependencies
cd ./readium-js
npm install
git submodule init && git submodule update #readium-js is a submodule. We need it.

# Compile Readium.js
grunt

# Copy the genearted lib file for further processing
cp out/Readium.js ../lib/readium.js

cd ..

# Get libs
cp node_modules/requirejs/require.js lib/require.js
wget http://backbonejs.org/backbone-min.js -O lib/backbone.min.js
wget http://code.jquery.com/jquery-2.1.3.min.js -O lib/jquery.min.js
wget http://underscorejs.org/underscore-min.js -O lib/underscore.min.js
wget https://github.com/jrburke/almond/raw/latest/almond.js -O lib/almond.js

cat <<EOF
**********
IMPORTANT.
**********

Before you can compile Readium you need to replace a little part of it by hand otherwise
r.js will throw an error, it's a weird one and there aren't docs to sort it out :/.


The file is at lib/readium.js.


Find a line containing: "text!version.json", it will probably look like this:

  define('text!version.json',[],function () { return '{"readiumJs":{"sha":"428b2956dce052598a73f8558b8a686600eabbd2","clean":true},"readiumSharedJs":{"sha":"e3d096dabe6d6ea188c9af97fc28fc7c410982b2","clean":true}}';});

Copy the Object inside the String it returns, in the example:

  {"readiumJs":{"sha":"428b2956dce052598a73f8558b8a686600eabbd2","clean":true},"readiumSharedJs":{"sha":"e3d096dabe6d6ea188c9af97fc28fc7c410982b2","clean":true}}

And remove that "define" line.


After that, find the last line containing text!version.json, it will probably look like this:

  define('Readium',['require', 'text!version.json', ...

Remove the 'text!version.json' parameter from it (the comma as well).

Right after that line there will be a function definition as follows:

    function (require, versionText, 

Remove the 'versionText' parameter from it (the comma as well).


The last bit. Find a line that reads:

  Readium.version = JSON.parse(versionText);

Replace JSON.parse(versionText) with the content of the Object you copied above. In the example
it will look like:

  Readium.version = {"readiumJs":{"sha":"428b2956dce052598a73f8558b8a686600eabbd2","clean":true},"readiumSharedJs":{"sha":"e3d096dabe6d6ea188c9af97fc28fc7c410982b2","clean":true}}

**********
IMPORTANT.
**********

EOF

read -p "When you're done, press [enter] to continue with the compilation step..."

# Build Readium not to use requirejs through almondjs
./node_modules/requirejs/./bin/r.js -o build.js

# Compile all the assets into a minified file that include all the vendor libs
uglifyjs lib/jquery.min.js \
  lib/underscore.min.js \
  lib/backbone.min.js \
  dist/readium.js \
  -o dist/readium.min.js --source-map dist/readium.min.js.map -p 5 -c -m

# Provide a gzipped version for whomever wants it
gzip -c dist/readium.min.js > dist/readium.min.js.gz

cat <<EOF


Done. Your build is at dist/


EOF
ls -lha dist
