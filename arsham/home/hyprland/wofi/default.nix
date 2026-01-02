{
  programs.wofi = {
    enable = true;
    settings = {
      width = 640;
      height = 400;
      padding = 10;
      border = 10;
      spacing = 10;
      show-icons = true;
      location = "center";
      allow-markup = true;
      hide-scroll = true;
      insensitive = true;
      prompt = "+Whats up? >:)";
      always_parse_args = true;
      allow_images = true;
      show = "drun";
    };
    
    style = ''
      * {
        all: unset;
        font-family: "IBM Plex Mono", "JetBrainsMono Nerd Font", monospace;
        font-size: 16px;
        transition: all 1ms ease;
        box-sizing: border-box;
      }
      
      window {
        margin: 0;
        padding: 12px;
        border-radius: 24px;
        background-color: rgba(15, 13, 25, 0.08);
        border: 2px solid rgba(200, 180, 255, 0.08);
        box-shadow: 0px 30px 50px rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(36px);
        -webkit-backdrop-filter: blur(36px);
        animation: fadeIn 1ms ease-out;
        overflow: hidden;
      }
      
      @keyframes fadeIn {
        from { opacity: 0; transform: scale(0.96); }
        to   { opacity: 1; transform: scale(1); }
      }
      
      #outer-box {
        margin: 0;
        padding: 0;
        border-radius: 22px;
        background-color: rgba(0, 0, 0, 0.314);
      }
      
      #inner-box {
        margin: 0;
        padding: 8px;
        border-radius: 22px;
        background-color: rgba(25, 22, 39, 0.45);
      }
      
      #input {
        margin: 12px;
        padding: 12px 20px;
        border-radius: 20px;
        background-color: rgba(75, 65, 120, 0.28);
        color: #e0def4;
        font-weight: 600;
        letter-spacing: 0.05em;
        border: 1px solid rgba(180, 160, 255, 0.12);
      }
      
      #input:focus {
        background-color: rgba(90, 70, 160, 0.34);
        border: 1px solid rgba(220, 200, 255, 0.2);
      }
      
      #scroll {
        margin: 0;
        padding: 0 8px 8px;
        border-radius: 20px;
        background: transparent;
      }
      
      #entry {
        padding: 12px 20px;
        margin: 6px 0;
        border-radius: 18px;
        color: #d9e0ee;
        font-weight: 500;
        background-color: rgba(255, 255, 255, 0.012);
      }
      
      #entry:selected {
        background-color: rgba(155, 132, 255, 0.22);
        color: #f5e0dc;
        font-weight: 600;
        border: 1px solid rgba(200, 180, 255, 0.15);
        box-shadow: inset 0 0 0 1px rgba(200, 180, 255, 0.1);
        border-radius: 18px;
      }
    '';
  };
}