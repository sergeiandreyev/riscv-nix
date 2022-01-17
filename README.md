# Full RISC-V + SpinalHDL development environment, powered by Nix

(Basically, a nixified version of https://github.com/sea212/QuantumRisc-VM-Build-Tools)

Includes:

- Hardware description: Spinal, Verilog, GHDL
- Synthesis: Yosys, Icestorm toolchains
- Simulation: GtkWave, Verilator
- Formal verification: TODO
- Testing: OpenOCD (including RISC-V forks), JTAG and serial tools
- RISC-V embedded compiler toolchain for C and Rust

Features:

- Deterministic thanks to Nix. Guaranteed to work on any machine \*.
- Easy to deploy on existing machines (see below, "Nix shell" or "Overlay") if desired

\* at the moment, this only applies to the shell, since the versions in the VM are not pinned.

## Installation

Nix can be installed on any machine. A single-user install is recommended for non-NixOS systems,
in which the user of the device has to own `/nix`. This usually requires `sudo` during installation,
but never after that. The installation in `/nix` is tangential to the FHS and thus does not interfere
with any of the existing package managers.

```sh
# Run the installation script
curl -L https://nixos.org/nix/install | sh

# You need to call this in you shell to bring `nix` commands into scope. Ideally, put it in your
# ~/.bashrc or equivalent.
source ~/.nix-profile/etc/profile.d/nix.sh
```

See [the manual](https://nixos.org/manual/nix/stable/index.html#sect-single-user-installation) for
more detailed instructions.

### GNOME VM

Build a QEMU VM running GNOME with all these tools installed. It can also be deployed on hosts without
Nix installation or as a standalone OS. Login: `alice`:`foobar`

```sh
# Build (must be called in the `riscv-nix` directory)
nix-build -A vm -I nixos-config=./vm.nix ./default.nix

# Run
./result/bin/run-nixos-vm
```

### Nix shell

Spawn a sub-shell having all these tools in `$PATH`: `nix-shell shell.nix`.

### Overlay

If you are already on NixOS or using Home-Manager, you can do the following to bring these tools into your global
(or user) system environment:

- add `nixpkgs.overlays = [ (import ./overlay.nix) (import (import ./nix/sources.nix).moz-overlay)];` to get all the software
  (the second one is the [Mozially overlay](https://github.com/mozilla/nixpkgs-mozilla), you need it too)
  - Alternatively, you can use `(import ./default.nix).pkgs` to get a pinned and configured version of `nixpkgs`
- `(import ./default.nix).packages pkgs` will give you a list of packages. Add it to `environment.systemPackages` or some equivalent.
  You need to call it with some `pkgs`, either use your own or the pinned one as above.
- Use [Niv](https://github.com/nmattia/niv) to manage the dependency on this repository

## Maintenance

Run `niv update`. Manually packaged applications must be checked for updates manually.
The pinned Rust nightly toolchain must be updated manually.
Test with `nix-shell --pure`, because that's the one with pinned dependencies.
TODO add automatic tests for the different applications.
