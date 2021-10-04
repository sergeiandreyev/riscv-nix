(pkgs: super: {
  # Specify the sub-architecture for the RISC-V gcc
  pkgsCross = super.pkgsCross // {
    # Our platform requires to set the gcc.arch
    riscv32-embedded = import super.path (super.config // {
      crossSystem = {
        config = "riscv32-none-elf";
        libc = "newlib";
        gcc.arch = "rv32im";
      };
    });
  };

  # OpenOCD forks
  openocd-vexriscv = pkgs.openocd.overrideAttrs (old: {
    pname = "openocd-vexriscv";
    src = pkgs.fetchFromGitHub {
      owner = "SpinalHDL";
      repo = "openocd_riscv";
      rev = "9e92cd194381a5d9180fd1aef4f570f698340595";
      fetchSubmodules = true;
      sha256 = "1qvvxw9bl6247a4lynry2hq2kj1dx7jfk0yqrlxbnb1qv9rnbj3p";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ which libtool automake autoconf git libyaml ]);
    preConfigure = "./bootstrap nosubmodule";
  });
  riscv-openocd = pkgs.openocd.overrideAttrs (old: {
    pname = "riscv-openocd";
    src = pkgs.fetchFromGitHub {
      owner = "riscv";
      repo = "riscv-openocd";
      rev = "41ffb2dee645834c71b8ebda4cacf9187b3fe686"; # master
      fetchSubmodules = true;
      sha256 = "0jw929mv5y7ff9hiyfj3ibqry6081aikmjjh3fbank7idhrafqzz";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ which libtool automake autoconf git ]);
    preConfigure = "./bootstrap nosubmodule";
  });

  # Other custom packages
  ujprog = pkgs.callPackage ./pkgs/ujprog.nix {};
  gtkterm = pkgs.callPackage ./pkgs/gtkterm.nix {};
})
