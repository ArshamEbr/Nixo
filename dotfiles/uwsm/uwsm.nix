{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
    username = "${user.name}";
    files = {
      ".config/exp".text = ''
      '';
    };
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/etc/profiles/per-user/arsham/bin/hyprland";
      };
    #  wayfire = {
    #    prettyName = "Wayfire";
    #    comment = "Wayfire compositor managed by UWSM";
    #    binPath = "/etc/profiles/per-user/arsham/bin/hyprland";
    #  };
    };
  };
  #users.users.${user.name}.packages = with pkgs-unstable; [
  #];
}