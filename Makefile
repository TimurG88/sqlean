# Copyright (c) 2021 Anton Zhiyanov, MIT License
# https://github.com/nalgeon/sqlean

.PHONY: prepare-dist download-sqlite download-external compile-linux compile-windows compile-macos test test-all

prepare-dist:
	mkdir -p dist
	rm -f dist/*

download-sqlite:
	curl -L http://sqlite.org/$(SQLITE_RELEASE_YEAR)/sqlite-amalgamation-$(SQLITE_VERSION).zip --output src.zip
	unzip src.zip
	mv sqlite-amalgamation-$(SQLITE_VERSION)/* src

download-external:
	curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/compress.c --output src/compress.c
	curl -L https://github.com/daschr/sqlite3_extensions/raw/master/cron.c --output src/cron.c
	curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/eval.c --output src/eval.c
	curl -L https://github.com/jakethaw/pivot_vtab/raw/main/pivot_vtab.c --output src/pivotvtab.c
	curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/sqlar.c --output src/sqlar.c
	curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/uint.c --output src/uint.c
	curl -L https://github.com/jakethaw/xml_to_json/raw/master/xml_to_json.c --output src/xmltojson.c
	curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/zipfile.c --output src/zipfile.c

compile-linux:
	gcc -fPIC -shared src/besttype.c -o dist/besttype.so
	gcc -fPIC -shared src/cbrt.c -o dist/cbrt.so -lm
	gcc -fPIC -shared src/compress.c -o dist/compress.so -lz
	gcc -fPIC -shared src/cron.c -o dist/cron.so
	gcc -fPIC -shared src/envfuncs.c -o dist/envfuncs.so
	gcc -fPIC -shared src/eval.c -o dist/eval.so
	gcc -fPIC -shared src/fcmp.c -o dist/fcmp.so
	gcc -fPIC -shared src/isodate.c -o dist/isodate.so
	gcc -fPIC -shared src/math2.c -o dist/math2.so
	gcc -fPIC -shared src/pearson.c -o dist/pearson.so
	gcc -fPIC -shared src/pivotvtab.c -o dist/pivotvtab.so
	gcc -fPIC -shared src/recsize.c -o dist/recsize.so
	gcc -fPIC -shared src/sqlar.c -o dist/sqlar.so -lz
	gcc -fPIC -shared src/stats2.c -o dist/stats2.so
	gcc -fPIC -shared src/uint.c -o dist/uint.so
	gcc -fPIC -shared src/unhex.c -o dist/unhex.so
	gcc -fPIC -shared src/xmltojson.c -o dist/xmltojson.so -DSQLITE
	gcc -fPIC -shared src/zipfile.c -o dist/zipfile.so -lz

compile-windows:
	gcc -shared -I. src/besttype.c -o dist/besttype.dll
	gcc -shared -I. src/cbrt.c -o dist/cbrt.dll -lm
	# gcc -shared -I. src/compress.c -o dist/compress.dll -lz
	gcc -shared -I. src/cron.c -o dist/cron.dll
	gcc -shared -I. src/envfuncs.c -o dist/envfuncs.dll
	gcc -shared -I. src/eval.c -o dist/eval.dll
	gcc -shared -I. src/fcmp.c -o dist/fcmp.dll
	gcc -shared -I. src/isodate.c -o dist/isodate.dll
	gcc -shared -I. src/math2.c -o dist/math2.dll
	gcc -shared -I. src/pearson.c -o dist/pearson.dll
	gcc -shared -I. src/pivotvtab.c -o dist/pivotvtab.dll
	gcc -shared -I. src/recsize.c -o dist/recsize.dll
	# gcc -shared -I. src/sqlar.c -o dist/sqlar.dll -lz
	gcc -shared -I. src/stats2.c -o dist/stats2.dll
	gcc -shared -I. src/uint.c -o dist/uint.dll
	gcc -shared -I. src/unhex.c -o dist/unhex.dll
	gcc -shared -I. src/xmltojson.c -o dist/xmltojson.dll -DSQLITE
	# gcc -shared -I. src/zipfile.c -o dist/zipfile.dll -lz

compile-macos:
	gcc -fPIC -dynamiclib -I src src/besttype.c -o dist/besttype.dylib
	gcc -fPIC -dynamiclib -I src src/cbrt.c -o dist/cbrt.dylib -lm
	gcc -fPIC -dynamiclib -I src src/compress.c -o dist/compress.dylib -lz
	gcc -fPIC -dynamiclib -I src src/cron.c -o dist/cron.dylib
	gcc -fPIC -dynamiclib -I src src/envfuncs.c -o dist/envfuncs.dylib
	gcc -fPIC -dynamiclib -I src src/eval.c -o dist/eval.dylib
	gcc -fPIC -dynamiclib -I src src/fcmp.c -o dist/fcmp.dylib
	gcc -fPIC -dynamiclib -I src src/isodate.c -o dist/isodate.dylib
	gcc -fPIC -dynamiclib -I src src/math2.c -o dist/math2.dylib
	gcc -fPIC -dynamiclib -I src src/pearson.c -o dist/pearson.dylib
	gcc -fPIC -dynamiclib -I src src/pivotvtab.c -o dist/pivotvtab.dylib
	gcc -fPIC -dynamiclib -I src src/recsize.c -o dist/recsize.dylib
	gcc -fPIC -dynamiclib -I src src/sqlar.c -o dist/sqlar.dylib -lz
	gcc -fPIC -dynamiclib -I src src/stats2.c -o dist/stats2.dylib
	gcc -fPIC -dynamiclib -I src src/uint.c -o dist/uint.dylib
	gcc -fPIC -dynamiclib -I src src/unhex.c -o dist/unhex.dylib
	gcc -fPIC -dynamiclib -I src src/xmltojson.c -o dist/xmltojson.dylib -DSQLITE
	gcc -fPIC -dynamiclib -I src src/zipfile.c -o dist/zipfile.dylib -lz

test-all:
	make test suite=besttype
	make test suite=cbrt
	make test suite=compress
	make test suite=cron
	make test suite=envfuncs
	make test suite=eval
	make test suite=fcmp
	make test suite=isodate
	make test suite=math2
	make test suite=pearson
	make test suite=pivotvtab
	make test suite=recsize
	make test suite=sqlar
	make test suite=stats2
	make test suite=uint
	make test suite=unhex
	make test suite=xmltojson
	make test suite=zipfile

# fails if grep does find a failed test case
# https://stackoverflow.com/questions/15367674/bash-one-liner-to-exit-with-the-opposite-status-of-a-grep-command/21788642
test:
	sqlite3 < test/$(suite).sql | (! grep -Ex "[0-9]+.0")

