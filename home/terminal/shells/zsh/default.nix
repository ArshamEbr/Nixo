{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.zsh = {
      enable = true;
  
      # Set Zsh as the default shell
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
  
      shellAliases = {
        ll = "ls -alF";
        la = "ls -A";
        l = "ls -CF";
        gs = "git status";
        ".." = "cd ..";
      };
  
      initExtra = ''
        # Path tweaks
        export PATH="$HOME/.local/bin:$PATH"
  
        # Prompt for Powerlevel10k
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  
        # Custom history settings
        HISTFILE=~/.zsh_history
        HISTSIZE=10000
        SAVEHIST=10000
        setopt append_history
        setopt hist_ignore_dups
        setopt share_history
  
        # Performance boost
        zstyle ':completion:*' rehash true
  
        # Less startup lag
        zstyle ':completion:*' cache-path ~/.zsh/cache
      '';
  
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
        }
      ];
    };
  }