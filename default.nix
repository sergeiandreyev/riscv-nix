let
  # Pinned things with Niv
  sources = (import ./nix/sources.nix);

  # Pinned nixpkgs with overlays applied
  pkgs = import sources.pkgs {
    overlays = [
      (import ./overlay.nix)
      (import sources.moz-overlay)
    ];
  };

  # Evaluate our NixOS configuration
  config = (import "${sources.pkgs}/nixos" {
    configuration = ./vm.nix;
  });
  
  # NixOS virtualization using Qemu. Image relies on the local /nix/store
  vm = config.vm;
  # Full VirtualBox image
  vm-image = config.config.system.build.virtualBoxOVA;
in rec {
  inherit sources pkgs vm vm-image config;

  # This takes a `pkgs` as input in case you don't want to use the pinned versions.
  rustChannel = pkgs: pkgs.rustChannelOf { date = "2022-01-04"; channel = "nightly"; };

  # This takes a `pkgs` as input in case you don't want to use the pinned versions.
  # besaid `pkgs` needs to have both overlays (above) in some way or another nevertheless.
  packages = pkgs: let
    rustChannel2 = rustChannel pkgs;
  in with pkgs; [
    # Compilers
    pkgs.pkgsCross.riscv32-embedded.stdenv.cc # Cross-GCC for riscv32-none-elf; rv32im
    pkgs.pkgsCross.arm-embedded.stdenv.cc # Cross-GCC for arm-none-eabi
    rustChannel2.cargo
    (rustChannel2.rust.override {
        targets = [
            "armv7-unknown-linux-gnueabihf" # Cross-compile for a Pi with NixOS
            "armv7-unknown-linux-musleabihf" # Cross-compile for a Pi with Raspbian
            # Cross-compile for RISC-V. See https://www.reddit.com/r/rust/comments/ke8w6t/modular_riscv_isa_target_for_rust/
            # and https://users.rust-lang.org/t/compile-for-riscv32im-unknown-none-elf/64597
            "riscv32i-unknown-none-elf"
            "riscv32imc-unknown-none-elf"
            "riscv32imac-unknown-none-elf"
        ];
        extensions = ["rust-src"];
    })
    clang
    cargo-bloat

    # Synthesis
    ghdl
    verilog # This is icarusverilog
    yosys
    icestorm
    nextpnr
    trellis

    # Testing/Simlation
    gtkwave
    verilator
    python3Packages.cocotb
    spike
    
    # Formal verification
    symbiyosys
    yices
    abc-verifier

    # Debugging
    gdb-multitarget
    openocd
    openocd-vexriscv
    riscv-openocd
    ujprog
    fujprog
    gtkterm

    # Spinal/Java stuff
    jdk8
    sbt
    scala_2_13
    
    # Command runners
    gnumake
    just
    
    # Unsorted
    LSOracle
    OpenROAD
    klayout
    magic-vlsi
    ecpprog
  ];
}
