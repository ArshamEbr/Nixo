{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  #dotfiles = {
  #  username = "${user.name}";
  #  files = {
  #    ".config/uwsm/default-id".text = ''
  #      hyprland-uwsm.desktop
  #    '';
  #  };
  #};
  programs.uwsm = {
    enable = true;
    package = pkgs-unstable.uwsm; # works better... for some reason -_-
  #  waylandCompositors = {
  #    hyprland = {
  #      prettyName = "Hyprland";
  #      comment = "Hyprland compositor managed by UWSM";
  #      binPath = "/etc/profiles/per-user/arsham/bin/hyprland";
  #    };
  #    wayfire = {
  #      prettyName = "Wayfire";
  #      comment = "Wayfire compositor managed by UWSM";
  #      binPath = "/run/current-system/sw/bin/wayfire";
  #    };
  #  };
  };
}