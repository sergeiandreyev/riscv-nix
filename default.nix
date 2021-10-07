rec {
  # Pinned things with Niv
  sources = (import ./nix/sources.nix);

  # Pinned nixpkgs with overlays applied
  # don't switch back to stable before 21.11
  pkgs = import sources.pkgsUnstable {
    overlays = [
      (import ./overlay.nix)
      (import sources.moz-overlay)
    ];
  };
  
  # Ugly hack. Sometimes I just hate Nix
  vm = ((import "${sources.pkgsUnstable}/nixos") {}).vm;

  # This takes a `pkgs` as input in case you don't want to use the pinned versions.
  # besaid `pkgs` needs to have both overlays (above) in some way or another nevertheless.
  packages = pkgs: with pkgs; [
    # GCC & Rust
    pkgs.pkgsCross.riscv32-embedded.stdenv.cc 
    pkgs.pkgsCross.riscv32-embedded.stdenv.cc # Cross-GCC for riscv32-none-elf; rv32im
    pkgs.pkgsCross.arm-embedded.stdenv.cc # Cross-GCC for arm-none-eabi
    pkgs.latest.rustChannels.nightly.cargo
    (pkgs.latest.rustChannels.nightly.rust.override {
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

    # Debugging
    gdb-multitarget
    openocd
    openocd-vexriscv
    #riscv-openocd
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
  ];
}
