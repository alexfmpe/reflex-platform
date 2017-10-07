#!/usr/bin/env bash
BENCHMARK=js-framework-benchmark
PACKAGES=(webdriver-ts vanillajs-keyed)

if [ ! -d "$BENCHMARK" ]; then
    git clone git@github.com:krausest/js-framework-benchmark.git
    cd $BENCHMARK
    npm install
    for package in $PACKAGES;
    do
	cd $package
	npm install
	npm run build-prod
	cd ..
    done
fi

./hack-on reflex-dom
cd reflex-dom/reflex-dom
../../work-on ghcjs ./. --command "cabal configure --ghcjs --enable-benchmarks"
# ../../work-on ghcjs ./. --command "cabal build --ghcjs-options='-dedupe -DGHCJS_BROWSER -O2 -fspecialise-aggressively'"
# cp -R dist/build/krausest/krausest.jsexe/* ../../$BENCHMARK/dist
# cd ../../$BENCHMARK
# npm start &
# cd webdriver-ts
# npm run selenium -- --frameworks reflex --count 1
# npm run results
# kill $!
