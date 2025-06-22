{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.fish = {
      enable = true;
      package = pkgs-unstable.fish;
      interactiveShellInit = ''
        # Fisher plugin manager
        set -U _fisher_plugins jorgebucaran/fisher
        set -U _fisher_jorgebucaran_2F_fisher_files \
          ~/.config/fish/functions/fisher.fish \
          ~/.config/fish/completions/fisher.fish
        set -U _fisher_upgraded_to_4_4
      '';

      shellInit = ''
        function fish_prompt -d "Write out the prompt"
            printf '%s@%s %s%s%s > ' $USER $hostname \
                (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        end
    
        if status is-interactive
            set fish_greeting
        end
    
        starship init fish | source
    
        if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
            cat ~/.cache/ags/user/generated/terminal/sequences.txt
        end
      '';

      shellAliases = {
        dwd = "aria2c -x 16 -s 16";
        gic = "git clone";
        cle = "clear";
      };
      
      variables = {
        __fish_initialized = "3400";
        fish_key_bindings = "fish_default_key_bindings";
    
        fish_color_autosuggestion = "555 brblack";
        fish_color_cancel = "--reverse";
        fish_color_command = "blue";
        fish_color_comment = "red";
        fish_color_cwd = "green";
        fish_color_cwd_root = "red";
        fish_color_end = "green";
        fish_color_error = "brred";
        fish_color_escape = "brcyan";
        fish_color_history_current = "--bold";
        fish_color_host = "normal";
        fish_color_host_remote = "yellow";
        fish_color_normal = "normal";
        fish_color_operator = "brcyan";
        fish_color_param = "cyan";
        fish_color_quote = "yellow";
        fish_color_redirection = "cyan --bold";
        fish_color_search_match = "--background=111";
        fish_color_selection = "white --bold --background=brblack";
        fish_color_status = "red";
        fish_color_user = "brgreen";
        fish_color_valid_path = "--underline";
    
        fish_pager_color_completion = "normal";
        fish_pager_color_description = "B3A06D yellow --italic";
        fish_pager_color_prefix = "cyan --bold --underline";
        fish_pager_color_progress = "brwhite --background=cyan";
        fish_pager_color_selected_background = "--reverse";
      };
    };
  }