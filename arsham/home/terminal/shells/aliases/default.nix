{
  pkgs,
  user,
  ...
}:

let
  commonAliases = {
    ls = "eza";
    tree = "eza --tree --git-ignore";
    ll = "ls -alF";
    la = "ls -A";
    l = "eza -lah";
    ".." = "cd ..";
    grep = "grep --color=auto";
    rm = "gio trash";
    c = "clear";
    h = "history";
    cat = "bat";
    
    man = "batman";
    y = "yazi";
    
    gs = "git status";
    gic = "git clone";
    gconv = "nix hash convert --to sri --hash-algo sha256";
    
    dwd = "aria2c -x 16 -s 16";
    
    nr = "sudo nixos-rebuild switch --flake ~/nixo/${user.name}#${user.host}";
    nb = "sudo nixos-rebuild build --flake ~/nixo/${user.name}#${user.host}";
  };
in
  {
    config = {
      programs.bash.shellAliases = commonAliases;
      programs.zsh.shellAliases = commonAliases;
      programs.fish.shellAliases = commonAliases; # fish uses functions, but this works
    };
  }