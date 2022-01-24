{ config, pkgs, lib, ... }:

let
  default = import ./default.nix;
  sources = import ./nix/sources.nix;
in {
  imports = [
    "${sources.pkgs}/nixos/tests/common/user-account.nix"
    "${sources.pkgs}/nixos/modules/profiles/qemu-guest.nix"
    "${sources.pkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    "${sources.pkgs}/nixos/modules/virtualisation/virtualbox-image.nix"
  ];
  
  # Pin nixpkgs
  _module.args = {
      inherit (default) pkgs;
  };

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

  virtualbox.baseImageSize = 60 * 1024;
  virtualbox.params.usb = "off";

  system.stateVersion = "21.05"; # Did you read the comment?
}
