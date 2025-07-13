{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:"
    '';
    sessionVariables = {
      EDITOR = "nano";
    };
  };
}