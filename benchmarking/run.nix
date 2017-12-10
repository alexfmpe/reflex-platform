{ reflex-platform ? import ../. {} }:
let pkgs = reflex-platform.nixpkgs;
in pkgs.writeScript "run.sh" ''
#!/usr/bin/env bash
set -euo pipefail

exec 3>&1
exec 1>&2

PATH="${pkgs.nodejs-8_x}/bin:${pkgs.nodePackages.npm}/bin:${pkgs.chromedriver}/bin:$PATH"

SANDBOX="$1"
cd "$SANDBOX"

CHROME_BINARY="${if reflex-platform.system == "x86_64-darwin"
  then ""
  else ''--chromeBinary "${pkgs.chromium}/bin/chromium"''
}"
CHROMEDRIVER="${if reflex-platform.system == "x86_64-darwin"
  then ""
  else ''--chromeDriver "${pkgs.chromedriver}/bin/chromedriver"''
}"

npm start &
SERVER_PID=$!

cd webdriver-ts

npm run selenium -- --framework vanillajs-keyed reflex --count 1 --headless $CHROME_BINARY $CHROMEDRIVER

kill "$SERVER_PID"

exec 1>&3

echo "[";
paste -d ',' results/reflex-dom*;
echo "]";
''
