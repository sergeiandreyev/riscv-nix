let
  default = import ./default.nix;
  pkgs = default.pkgs;
  packages = default.packages pkgs;
in
  pkgs.mkShell {
    buildInputs = packages;
  }
