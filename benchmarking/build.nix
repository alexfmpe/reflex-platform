{ reflex-platform ? import ../. {} }:
let pkgs = reflex-platform.nixpkgs;
in pkgs.writeScript "build.sh" ''
#!/usr/bin/env bash
set -euo pipefail

exec 3>&1
exec 1>&2

PATH="${pkgs.nodejs-8_x}/bin:${pkgs.nodePackages.npm}/bin:${pkgs.chromedriver}/bin:$PATH"

SANDBOX=$(mktemp -d 2>/dev/null || mktemp -d -t 'clean') # This crazy workaround ensures that it will work on both Mac OS and Linux; see https://unix.stackexchange.com/questions/30091/fix-or-alternative-for-mktemp-in-os-x

cd "$SANDBOX"

cp -a "${reflex-platform.js-framework-benchmark-src}/"* .
chmod -R +w .

npm install
for package in webdriver-ts webdriver-ts-results vanillajs-keyed; do
    cd $package
    npm install
    npm run build-prod
    cd ..
done

REFLEX_DOM_DIST=reflex-dom-v0.4-keyed/dist
mkdir -p "$REFLEX_DOM_DIST"
cp -a "${reflex-platform.ghcjs.reflex-dom}/bin/krausest.jsexe/"* "$REFLEX_DOM_DIST"

exec 1>&3

echo "$SANDBOX"

''
