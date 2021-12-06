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
      rev = "a985acb3481e4d5369182b5544ac82f9ec461e0b";
      fetchSubmodules = true;
      sha256 = "07rjdv1pdlc7c1x2s2ya1qgzz207xa4a0yvwjpl9fynjvz8dcz8l";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ which libtool automake autoconf git libyaml ]);
    preConfigure = "./bootstrap nosubmodule";
    postInstall = ''
      mv $out/bin/openocd $out/bin/openocd-vexriscv
    '';
  });
  riscv-openocd = pkgs.openocd.overrideAttrs (old: {
    pname = "riscv-openocd";
    src = pkgs.fetchFromGitHub {
      owner = "riscv";
      repo = "riscv-openocd";
      rev = "cb4876d80cbeaa70bba326a9411c875b48d314e4"; # master
      fetchSubmodules = true;
      sha256 = "135x6sz99qbqmpmiw4hf04mchllmiz41gr5y0v3x0sp08ymapbpb";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ which libtool automake autoconf git ]);
    preConfigure = "./bootstrap nosubmodule";
    postInstall = ''
      mv $out/bin/openocd $out/bin/riscv-openocd
    '';
  });

  # Other custom packages
  ujprog = pkgs.callPackage ./pkgs/ujprog.nix {};
  gtkterm = pkgs.callPackage ./pkgs/gtkterm.nix {};
})
