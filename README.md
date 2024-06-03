# Max van der Merwe's [NixOS] configuration using [flakes] and [Home Manager].

**Machines**

|   Hostname  |            Board            |               CPU              |  RAM  |         Primary GPU         | Role | OS  | State |
| :---------: | :-------------------------: | :----------------------------: | :---: | :-------------------------: | :--: | :-: | :---: |
| `ion`     | [ASrock B550M Pro4]           | [AMD Ryzen 7 5600]             | 32GB | [Nvidia RTX 3070]            | 🖥️ 🎮️| ❄️   | ✅    |
| `hera`    | [Asus TUF A17 FA706QM]        | [AMD Ryzen 5 5800H]            | 32GB | [Nvidia RTX 3060]            | 💻️ 🎮️| ❄️   | ✅    |
| `ceres`   | [Dell OptiPlex 7050]          | [Intel i5-7500T]               | 16GB | [Intel HD Graphics 630]      | ☁️    | ❄️   | ✅    |

**Key**

- 🖥️ : Desktop
- 💻️ : Laptop
- 🎮️ : Games Machine
- ☁️ : Server


## Inspirations 🧑‍🏫

Before prepping and during the creation of my NixOS and Home Manager config I looked at what other Nix users are doing.

Inpiration included [nix-starter-configs], [Alex Kretzschmar], Ana Hoverbear's [Declarative GNOME configuration with NixOS] blog post which I plan to use extensively and wish I knew about sooner.

A big thank you to [Martin Wimpress] for the format of this readme file and insiration for NixOS configuration, as well as the continued entertainment and knowledge provided by them in their various podcasts.

Of course a thank you to the wonderful project [NixOS] along with [Home Manager].

[NixOS]: https://nixos.org
[Home Manager]: https://github.com/nix-community/home-manager
[flakes]: https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes

[ASrock B550M Pro4]: https://www.asrock.com/mb/AMD/B550M%20Pro4/
[Asus TUF A17 FA706QM]: https://www.asus.com/laptops/for-gaming/tuf-gaming/2021-asus-tuf-gaming-a17/
[Dell OptiPlex 7050]: https://i.dell.com/sites/csdocuments/Shared-Content_data-Sheets_Documents/en/OptiPlex-7050-Towers-Technical-Specifications.pdf
[AMD Ryzen 7 5600]: https://www.amd.com/en/products/processors/desktops/ryzen/5000-series/amd-ryzen-5-5600x.html
[AMD Ryzen 5 5800H]: https://www.amd.com/en/products/apu/amd-ryzen-7-5800h
[Intel i5-7500T]: https://ark.intel.com/content/www/us/en/ark/products/97121/intel-core-i5-7500t-processor-6m-cache-up-to-3-30-ghz.html
[Nvidia RTX 3060]: https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3060-3060ti/
[Nvidia RTX 3070]:https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3070-3070ti/
[Intel HD Graphics 630]: https://ark.intel.com/content/www/us/en/ark/products/97121/intel-core-i5-7500t-processor-6m-cache-up-to-3-30-ghz.html

[Martin Wimpress]: https://github.com/wimpysworld
[Alex Kretzschmar]: https://github.com/ironicbadge
[nix-starter-configs]: https://github.com/Misterio77/nix-starter-configs
[Declarative GNOME configuration with NixOS]: https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos