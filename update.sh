# NixOS Flake update script

echo "NixOS Flake update script"

cd /etc/nixos

nix flake update

sudo nixos-rebuild boot
echo $?

if exit=0
then
git add * && git commit -m "Update" && git push origin
else
echo "Update failed"
fi

exit 0