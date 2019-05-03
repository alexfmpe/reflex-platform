#https://github.com/NixOS/nix/issues/2292#issuecomment-443933924
sudo mkdir /etc/nix; echo 'use-sqlite-wal = false' | sudo tee -a /etc/nix/nix.conf && sh <(curl https://nixos.org/nix/install)
