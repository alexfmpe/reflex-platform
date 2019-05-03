sudo mkdir /etc/nix
sudo echo 'use-sqlite-wal = false' > /etc/nix/nix.conf
./try-reflex
