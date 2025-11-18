# Astrid van der Merwe's [NixOS] configuration using [flakes] and [Home Manager].

**Machines**

|   Hostname  |            Board            |               CPU              |  RAM  |         Primary GPU         | Role | OS  | State |
| :---------: | :-------------------------: | :----------------------------: | :---: | :-------------------------: | :--: | :-: | :---: |
| `ion`     | [ASrock B550M Pro4]           | [AMD Ryzen 7 5600]             | 32GB | [Nvidia RTX 3070]            | 🖥️ 🎮️| ❄️   | ✅    |
| `hera`    | [Asus TUF A17 FA706QM]        | [AMD Ryzen 5 5800H]            | 32GB | [Nvidia RTX 3060]            | 💻️ 🎮️| ❄️   | ✅    |
| `ceres`   | [MSI X99A SLI Plus]           | [Intel i7-5820k]               | 16GB | [Nvidia GTX 650]             | ☁️    | ❄️   | ✅    |
| `polaris` | [Raspberry Pi 4B]             | [ARM-Cortex A72]               | 4GB  | []                           | ☁️    | ❄️   | ✅    |

**Key**

- 🖥️ : Desktop
- 💻️ : Laptop
- 🎮️ : Games Machine
- ☁️ : Server


## Instructions
```
git clone https://github.com/astridvdm/nixos.git

cd nixos
```
### Please see the above table to select a hostname.
```
sudo nixos-rebuild boot --flake .#hostname
```
### Then reboot your system
## Inspirations 🧑‍🏫

Before prepping and during the creation of my NixOS and Home Manager config I looked at what other Nix users are doing.

Inpiration included [nix-starter-configs], [Alex Kretzschmar], Ana Hoverbear's [Declarative GNOME configuration with NixOS] blog post which I plan to use extensively and wish I knew about sooner.

A big thank you to [Martin Wimpress] for the format of this readme file and inspiration for NixOS configurations, as well as the continued entertainment and knowledge provided by them in their various podcasts.

Of course a thank you to the wonderful [NixOS] project along with [Home Manager].

[NixOS]: https://nixos.org
[Home Manager]: https://github.com/nix-community/home-manager
[flakes]: https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes

[ASrock B550M Pro4]: https://www.asrock.com/mb/AMD/B550M%20Pro4/
[Asus TUF A17 FA706QM]: https://www.asus.com/laptops/for-gaming/tuf-gaming/2021-asus-tuf-gaming-a17/
[Dell OptiPlex 7050]: https://i.dell.com/sites/csdocuments/Shared-Content_data-Sheets_Documents/en/OptiPlex-7050-Towers-Technical-Specifications.pdf
[MSI X99A SLI Plus]: https://www.msi.com/Motherboard/X99A-SLI-PLUS/Specification
[Raspberry Pi 4B]: https://www.raspberrypi.com/products/raspberry-pi-4-model-b/specifications/
[AMD Ryzen 7 5600]: https://www.amd.com/en/products/processors/desktops/ryzen/5000-series/amd-ryzen-5-5600x.html
[AMD Ryzen 5 5800H]: https://www.amd.com/en/products/apu/amd-ryzen-7-5800h
[Intel i7-5820k]: https://www.intel.com/content/www/us/en/products/sku/82932/intel-core-i75820k-processor-15m-cache-up-to-3-60-ghz/specifications.html?wapkw=i7%205820k
[Intel i5-7500T]: https://ark.intel.com/content/www/us/en/ark/products/97121/intel-core-i5-7500t-processor-6m-cache-up-to-3-30-ghz.html
[Nvidia RTX 3060]: https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3060-3060ti/
[Nvidia RTX 3070]:https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3070-3070ti/
[Nvidia GTX 650]: https://www.nvidia.com/en-us/geforce/graphics-cards/geforce-gtx-650/ 
[Intel HD Graphics 630]: https://ark.intel.com/content/www/us/en/ark/products/97121/intel-core-i5-7500t-processor-6m-cache-up-to-3-30-ghz.html
[ARM-Cortex A72]: https://www.arm.com/products/silicon-ip-cpu/cortex-a/cortex-a72

[Martin Wimpress]: https://github.com/wimpysworld
[Alex Kretzschmar]: https://github.com/ironicbadge
[nix-starter-configs]: https://github.com/Misterio77/nix-starter-configs
[Declarative GNOME configuration with NixOS]: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos
