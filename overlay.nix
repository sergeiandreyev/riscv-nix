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
    src = pkgs.fetchFromGitHub {
      owner = "SpinalHDL";
      repo = "openocd_riscv";
      rev = "c974c1b70348b59146bb87a1cfb829296240a509";
      fetchSubmodules = true;
      sha256 = "1cp7gas3q4hjh60hvf0alp6y0h6515l598ig2y7xccdfh0jk8zv2";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ which libtool automake autoconf git ]);
    preConfigure = "./bootstrap nosubmodule";
  });
  riscv-openocd = pkgs.openocd.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "riscv";
      repo = "riscv-openocd";
      rev = "6edf98db7f98c5e24bc51cf98419bdf5bbc530e6";
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
