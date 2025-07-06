{ 
  pkgs,
  ... 
}:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#8be9fd,bold,underline";
      strategy = [
        "history"
        "completion" 
      #  "match_prev_cmd"
      ];
    };
    history = {
      save = 10000;
      share = true;
      ignoreAllDups = true;
      extended = true;
    };
  
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      gs = "git status";
      ".." = "cd ..";
      cle = "clear";
      dwd = "aria2c -x 16 -s 16";
      gic = "git clone";
      gconv = "nix hash convert --to sri --hash-algo sha256";
    };

    initContent = ''
      # Prompt for Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Path tweaks
      export PATH="$HOME/.local/bin:$PATH"

      # Custom history settings
      HISTFILE=~/.zsh_history
      HISTSIZE=10000
      setopt append_history
      setopt HIST_FIND_NO_DUPS
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward

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
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
      }
    ];
  };
  home.file.".p10k.zsh".text = ''
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
    typeset -g POWERLEVEL9K_MODE=nerdfont-complete
    typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="└╼ "
    
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      os_icon
      context
      dir
      vcs
      virtualenv
      pyenv
      nvm
    # node_version
      go_version
      rust_version
      status
      battery
    )
    
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      command_execution_time
      background_jobs
      time
    )
    
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=white
    typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=magenta
    typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=cyan
    typeset -g POWERLEVEL9K_DIR_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
    typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=black
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
    typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=black
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=magenta
    typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_PYENV_FOREGROUND=magenta
    typeset -g POWERLEVEL9K_PYENV_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_NVM_FOREGROUND=blue
    typeset -g POWERLEVEL9K_NVM_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=blue
    typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=cyan
    typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=red
    typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=green
    typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=black
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
    typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_BATTERY_FOREGROUND=blue
    typeset -g POWERLEVEL9K_BATTERY_BACKGROUND=black
    typeset -g POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND=green
    
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=red
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=magenta
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=black
    
    typeset -g POWERLEVEL9K_TIME_FOREGROUND=white
    typeset -g POWERLEVEL9K_TIME_BACKGROUND=black
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
    
    # Other settings
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
    typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
    
    typeset -g POWERLEVEL9K_BATTERY_CHARGED_VISUAL_IDENTIFIER_EXPANSION='⚡'
    typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=25
  '';
}