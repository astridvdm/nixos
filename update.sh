# NixOS Flake update script

echo "NixOS Flake update script"

cd /etc/nixos

nix flake update

sudo nixos-rebuild boot
echo $?

if exit=0
then
git add * && git commit -m "Update" && git push
else
echo "Update failed"
fi

cat /etc/hostname
if hera
then
ssh polaris
cd /etc/nixos
git pull
else
exit 0

