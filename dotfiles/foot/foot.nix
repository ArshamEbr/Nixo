{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/foot/foot.ini".text = ''
        shell=fish
        term=xterm-256color
        
        title=foot
        
        font=SpaceMono Nerd Font:size=11
        letter-spacing=0
        # horizontal-letter-offset=0
        # vertical-letter-offset=0
        # underline-offset=<font metrics>
        # box-drawings-uses-font-glyphs=no
        dpi-aware=no
        
        # initial-window-size-pixels=700x500  # Or,
        # initial-window-size-chars=<COLSxROWS>
        # initial-window-mode=windowed
        pad=25x25                          # optionally append 'center'
        # resize-delay-ms=100
        
        # notify=notify-send -a $app-id -i $app-id $title $body
        
        bold-text-in-bright=no
        # word-delimiters=,│`|:"'()[]{}<>
        selection-target=both
        # workers=<number of logical CPUs>
        
        [scrollback]
        lines=10000
        
        [url]
        # launch=xdg-open $url
        # label-letters=sadfjklewcmpgh
        # osc8-underline=url-mode
        # protocols=http, https, ftp, ftps, file, gemini, gopher
        # uri-characters=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'
        
        [cursor]
        style=beam
        color=0F131C DFE2EF
        # blink=no
        beam-thickness=1.5
        # underline-thickness=<font underline thickness>
        
        
        [colors]
        alpha=0.7
        background=0F131C
        foreground=DFE2EF
        regular0=0F131C
        regular1=FFB4AB
        regular2=005CBA
        regular3=D7E3FF
        regular4=D7E3FF
        regular5=E0E2FF
        regular6=AAC7FF
        regular7=C1C6D6
        bright0=0F131C
        bright1=FFB4AB
        bright2=005CBA
        bright3=D7E3FF
        bright4=D7E3FF
        bright5=E0E2FF
        bright6=AAC7FF
        bright7=C1C6D6
        
        [csd]
        # preferred=server
        # size=26
        # font=<primary font>
        # color=<foreground color>
        # button-width=26
        # button-color=<background color>
        # button-minimize-color=<regular4>
        # button-maximize-color=<regular2>
        # button-close-color=<regular1>
        
        [key-bindings]
        scrollback-up-page=Page_Up
        # scrollback-up-half-page=none
        # scrollback-up-line=none
        scrollback-down-page=Page_Down
        # scrollback-down-half-page=none
        # scrollback-down-line=none
        clipboard-copy=Control+c
        clipboard-paste=Control+v
        # primary-paste=Shift+Insert
        search-start=Control+f
        # font-increase=Control+plus Control+equal Control+KP_Add
        # font-decrease=Control+minus Control+KP_Subtract
        # font-reset=Control+0 Control+KP_0
        # spawn-terminal=Control+Shift+n
        # minimize=none
        # maximize=none
        # fullscreen=none
        # pipe-visible=[sh -c "xurls | fuzzel | xargs -r firefox"] none
        # pipe-scrollback=[sh -c "xurls | fuzzel | xargs -r firefox"] none
        # pipe-selected=[xargs -r firefox] none
        # show-urls-launch=Control+Shift+u
        # show-urls-copy=none
        
        [search-bindings]
        cancel=Escape
        find-prev=Shift+F3
        find-next=F3 Control+G
        # commit=Return
        # cursor-left=Left Control+b
        # cursor-left-word=Control+Left Mod1+b
        # cursor-right=Right Control+f
        # cursor-right-word=Control+Right Mod1+f
        # cursor-home=Home Control+a
        # cursor-end=End Control+e
        # delete-prev=BackSpace
        # delete-prev-word=Control+BackSpace
        # delete-next=Delete
        # delete-next-word=Mod1+d Control+Delete
        # extend-to-word-boundary=Control+w
        # extend-to-next-whitespace=Control+Shift+w
        # clipboard-paste=Control+v Control+y
        # primary-paste=Shift+Insert
        
        [url-bindings]
        # cancel=Control+g Control+c Control+d Escape
        # toggle-url-visible=t
        
        [mouse-bindings]
        # primary-paste=BTN_MIDDLE
        # select-begin=BTN_LEFT
        # select-begin-block=Control+BTN_LEFT
        # select-extend=BTN_RIGHT
        # select-extend-character-wise=Control+BTN_RIGHT
        # select-word=BTN_LEFT-2
        # select-word-whitespace=Control+BTN_LEFT-2
        # select-row=BTN_LEFT-3
        
        [text-bindings]
        \x01 = Mod4+a
        \x03 = Mod4+c
        \x0C = Mod4+l
        \x0f = Mod4+w
        \x12 = Mod4+r
        \x1A = Mod4+z
        \x16 = Mod4+v
        \x18 = Mod4+x
      '';
      };
    };
    users.users.${user.name}.packages = with pkgs; [
      foot
    ];
  }
