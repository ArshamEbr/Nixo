{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = false;

    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
        linemode = "size";
        scrolloff = 3;
      };

      preview = {
        max_width = 120;
        max_height = 40;
        cache = true;
      };

      opener = {
        edit = [ "nvim" ];
        open = [ "xdg-open" ];
        play = [ "mpv" ];
      };

      plugin = {
        prepend_previewers = true;
      };
    };

    theme = {
      manager.cwd = { fg = "#b8c0e0"; bold = true; };
      manager.hovered = { fg = "#f2cdcd"; bg = "#575268"; };
      manager.preview_hovered = { fg = "#f2cdcd"; bg = "#302d41"; };

      status.mode = { fg = "#cba6f7"; bold = true; };
      status.progress = { fg = "#a6e3a1"; };

      filetype.dir = { fg = "#89b4fa"; };
      filetype.file = { fg = "#cdd6f4"; };
      filetype.executable = { fg = "#94e2d5"; bold = true; };

      preview.border = { fg = "#6c7086"; };

      selection.selected = { fg = "#f38ba8"; bg = "#313244"; bold = true; };
    };

    plugins = {
      preview = pkgs.stdenv.mkDerivation {
        name = "yazi-preview-plugin";
        src = null;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          echo 'return {' > $out/init.lua
          echo '  image = { use_kitty = false, use_sixel = false },' >> $out/init.lua
          echo '  video = { use_ffmpegthumbnailer = true },' >> $out/init.lua
          echo '  pdf = { use_poppler = true },' >> $out/init.lua
          echo '}' >> $out/init.lua
        '';
      };
    };
  };
}