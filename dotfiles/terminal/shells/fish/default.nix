{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
        ".config/fish/config.fish".text = ''
          function fish_prompt -d "Write out the prompt"
              # This shows up as USER@HOST /home/user/ >, with the directory colored
              # $USER and $hostname are set by fish, so you can just use them
              # instead of using `whoami` and `hostname`
              printf '%s@%s %s%s%s > ' $USER $hostname \
                  (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
          end
          
          if status is-interactive
              # Commands to run in interactive sessions can go here
              set fish_greeting
          
          end
          
          starship init fish | source
          if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
              cat ~/.cache/ags/user/generated/terminal/sequences.txt
          end
          
          # Add your shell aliases
          alias dwd="aria2c -x 16 -s 16"
          alias gic="git clone"
          alias cle="clear"
        '';

        ".config/fish/fish_variables".text = ''
          # This file contains fish universal variable definitions.
          # VERSION: 3.0
          SETUVAR __fish_initialized:3400
          SETUVAR _fisher_jorgebucaran_2F_fisher_files:\x7e/\x2econfig/fish/functions/fisher\x2efish\x1e\x7e/\x2econfig/fish/completions/fisher\x2efish
          SETUVAR _fisher_plugins:jorgebucaran/fisher
          SETUVAR _fisher_upgraded_to_4_4:\x1d
          SETUVAR fish_color_autosuggestion:555\x1ebrblack
          SETUVAR fish_color_cancel:\x2dr
          SETUVAR fish_color_command:blue
          SETUVAR fish_color_comment:red
          SETUVAR fish_color_cwd:green
          SETUVAR fish_color_cwd_root:red
          SETUVAR fish_color_end:green
          SETUVAR fish_color_error:brred
          SETUVAR fish_color_escape:brcyan
          SETUVAR fish_color_history_current:\x2d\x2dbold
          SETUVAR fish_color_host:normal
          SETUVAR fish_color_host_remote:yellow
          SETUVAR fish_color_normal:normal
          SETUVAR fish_color_operator:brcyan
          SETUVAR fish_color_param:cyan
          SETUVAR fish_color_quote:yellow
          SETUVAR fish_color_redirection:cyan\x1e\x2d\x2dbold
          SETUVAR fish_color_search_match:\x2d\x2dbackground\x3d111
          SETUVAR fish_color_selection:white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
          SETUVAR fish_color_status:red
          SETUVAR fish_color_user:brgreen
          SETUVAR fish_color_valid_path:\x2d\x2dunderline
          SETUVAR fish_key_bindings:fish_default_key_bindings
          SETUVAR fish_pager_color_completion:normal
          SETUVAR fish_pager_color_description:B3A06D\x1eyellow\x1e\x2di
          SETUVAR fish_pager_color_prefix:cyan\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
          SETUVAR fish_pager_color_progress:brwhite\x1e\x2d\x2dbackground\x3dcyan
          SETUVAR fish_pager_color_selected_background:\x2dr
        '';

        ".config/fish/auto-Hypr.fish".text = ''
          # Auto start Hyprland on tty1
          if test -z "$DISPLAY" ;and test "$XDG_VTNR" -eq 1
              mkdir -p ~/.cache
              exec Hyprland > ~/.cache/hyprland.log ^&1
          end
        '';
      };
    };
    programs.fish.enable = true;
  }
