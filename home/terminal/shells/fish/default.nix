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

      # Variables
      set __fish_initialized 3400
      set fish_key_bindings fish_default_key_bindings
      set fish_color_autosuggestion "555 brblack"
      set fish_color_cancel --reverse
      set fish_color_command blue
      set fish_color_comment red
      set fish_color_cwd green
      set fish_color_cwd_root red
      set fish_color_end green
      set fish_color_error brred
      set fish_color_escape brcyan
      set fish_color_history_current --bold
      set fish_color_host normal
      set fish_color_host_remote yellow
      set fish_color_normal normal
      set fish_color_operator brcyan
      set fish_color_param cyan
      set fish_color_quote yellow
      set fish_color_redirection "cyan --bold"
      set fish_color_search_match --background=111
      set fish_color_selection "white --bold --background=brblack"
      set fish_color_status red
      set fish_color_user brgreen
      set fish_color_valid_path --underline
      set fish_pager_color_completion normal
      set fish_pager_color_description "B3A06D yellow --italic"
      set fish_pager_color_prefix "cyan --bold --underline"
      set fish_pager_color_progress "brwhite --background=cyan"
      set fish_pager_color_selected_background --reverse
    '';

    shellAliases = {
      dwd = "aria2c -x 16 -s 16";
      gic = "git clone";
      cle = "clear";
    };
  };
}