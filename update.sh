#!/usr/bin/env bash

set -e

cd /etc/nixos

nix flake update

git fetch

git add *

git commit -m "Update"

git push origin main

hosts=($(echo $(nix eval .#nixosConfigurations --apply 'pkgs: builtins.concatStringsSep " " (builtins.attrNames pkgs)') | xargs))
skip=(

)

rsa_key="$HOME/.ssh/max-a17"
export NIX_SSHOPTS="-t -i $rsa_key"
reboot=0

while getopts ":r" option; do
    case $option in
    r)
        reboot=1
        ;;
    esac
done

for host in "${hosts[@]}"; do
    # Check if the host is in the skip list
    if [[ " ${skip[*]} " =~ " ${host} " ]]; then
        continue
    fi
    fqdn="$host.tail14bcea.ts.net"
    if [ $reboot -eq 0 ]; then
        echo "Update $fqdn"
        ssh -o ConnectTimeout=3 -t -i $rsa_key $fqdn 'cd /etc/nixos; git fetch; git pull; sudo nixos-rebuild boot --flake .#$host'
    fi
    echo
    echo
done    

# for host in "${hosts[@]}"; do
#     # Check if the host is in the skip list
#     if [[ " ${skip[*]} " =~ " ${host} " ]]; then
#         continue
#     fi
#     fqdn="$host.tail14bcea.ts.net"
#     if [ $reboot -eq 0 ]; then
#         echo "Reboot $fqdn"
#         ssh -t -i $rsa_key $fqdn 'sudo reboot'
#     fi
#     echo
#     echo
# done