{ config, pkgs, lib, ... }:

let
  default = import ./default.nix;
  sources = (import ./nix/sources.nix);
in {
  imports = [
    <nixpkgs/nixos/tests/common/user-account.nix>
  ];
  
  nixpkgs.overlays = [
    (import ./overlay.nix)
    (import sources.moz-overlay)
  ];

  services.xserver.enable = true;
  services.xserver.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
    autoLogin = {
      enable = true;
      user = "alice";
    };
  };
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.shell]
      favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'gtkwave.desktop' ]
    '';
  };

  environment.systemPackages = (with pkgs; [
    firefox
    (pkgs.makeAutostartItem {
      name = "org.gnome.Terminal";
      package = pkgs.gnome.gnome-terminal;
    })
  ]) ++ (default.packages pkgs);

  services.qemuGuest.enable = true;
  virtualisation.memorySize = 2048;

  system.stateVersion = "21.05"; # Did you read the comment?
}
