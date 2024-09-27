{
  # config,
  pkgs,
  # inputs,
  # stablePkgs,
  ...
}:

{
  imports = [
    ./nvim
    ./zsh # Note, zsh has to be installed in configuration.nix (for now)
    ./wezterm
    ./polybar
  ];

  # Let home-manager manage itself, required
  programs.home-manager.enable = true;

  home.username = "angryluck";
  home.homeDirectory = "/home/angryluck";

  # DON'T CHANGE, UNLESS YOU HAVE READ Home Manager RELEASE NOTES!
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Allows you to install fonts in home.packages
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "0xProto" ];
      sansSerif = [ "Lato" ];
      serif = [ "Noto Serif" ];
    };
  };

  # All user-packages, systemwide packages should go in configuration.nix
  home.packages = with pkgs; [

    ### FONTS
    _0xproto
    font-awesome
    inconsolata
    hack-font
    noto-fonts-color-emoji
    # noto-fonts-extra
    # otf-fira-mono
    terminus_font
    # ttf-aptos 1.0-1
    caladea
    noto-fonts
    lato

    (nerdfonts.override {
      fonts = [
        "0xProto"
        "Inconsolata"
        "Hack"
      ];
    })

    ### Browser
    firefox

    ### CLI-tools
    hello
    trash-cli
    fzf
    bc
    htop
    # powertop
    # fd
    cowsay
    # plocate
    # ripgrep
    zip
    unzip
    # wget
    xcolor
    xorg.xev
    xorg.xkill
    xorg.xprop
    file
    # Set in configuration.nix insted
    # brillo

    ### Applications
    zathura
    nautilus
    # dolphin

    # Trying stable version
    # Didn't work...
    # stablePkgs.logseq
    logseq
    # Needed for logseq for some reason
    # glibc
    isabelle
    feh
    # virtualbox

    ### Utilities
    redshift
    # syncthing
    flameshot
    # wineWowPackages.stable
    rofi-power-menu

    # Terminal
    # wezterm

    ### Programming languages
    gcc14
    gnumake
    valgrind
    gdb
    rars
    fsharp
    dotnet-sdk
    # ghc
    python3
    # rust
    # go
    # kotlin

    # DIVERSE
    # mpc-cli
    #FIX: Configure this with 'programs.texlive.enable' instead
    texlive.combined.scheme-full

    # Fonts:
    # noto-fonts-emoji
    # noto-fonts-extra
    # otf-fira-mono
    # terminus_font
    # ttf-0xproto 1.602-1
    # ttf-0xproto-nerd 3.2.1-2
    # ttf-aptos 1.0-1
    # ttf-caladea 20200113-4
    # ttf-fira-code 6.2-2
    # ttf-fira-mono 2:3.206-4
    # ttf-font-awesome 6.6.0-1
    # ttf-hack 3.003-7
    # ttf-hack-nerd 3.2.1-2
    # ttf-inconsolata 1:3.000-4
    # ttf-inconsolata-nerd 3.2.1-2
    # ttf-nerd-fonts-symbols 3.2.1-1

    # Potential programs, but don't use them right now
    # Emacs (/doom)
    # gtk?
    # i3
    # kitty
    # kupfer
    # qalculate
    # Thunar
    # tmux
    # Virtualbox
    # vlc
    # zoom-us
    # bitwarden
    # pavucontrol
    # brillo
    # chromium
    # dmenu
    # flatpak
    # fswatch
    # gimp
    # iwd (shouldn't be needed)
    # jupyterlab
    # libreoffice-fresh
    # ly?
    # networkmanager (in configuration.nix)
    # nextcloud? (need own server first)
    # obsidian
    # p7zip
    # pamixer
    # pandoc
    # pdftk
    # ranger
    # rofimoji
    # sbctl (secureboot key manager)
    # slock
    # tlp (in configuration.nix)
    # ueberzugpp
    # wirelesstools
    # xdotool
  ];

  # FIX: Slå korrekt notation op! (se VimJoyers video)
  # xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";

  programs.git = {
    enable = true;
    userName = "angryluck";
    # Github email, maybe better to write own email, idk
    userEmail = "54353246+angryluck@users.noreply.github.com";
    extraConfig = {
      # Set push.autoSetupRemote to true
      push.autoSetupRemote = "true";
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
    };
  };

  # File browser
  programs.yazi.enable = true;

  programs.rofi = {
    # Can't set file-browser-extended options here, have to modify the command
    # in xmonad!
    enable = true;
    terminal = "${pkgs.wezterm}/bin/wezterm";
    font = "Lato 20";
    # theme = "gruvbox-dark-soft";
    theme = "Arc-Dark";
    # package = pkgs.rofi;
    plugins = with pkgs; [
      rofi-calc
      rofi-file-browser
      # rofimoji
      rofi-emoji
    ];
    extraConfig = {
      display-drun = "Applications";
      modi = [
        "drun"
        "file-browser-extended"
        "calc"
        "emoji"
      ];
      # file-browser-matching = "fuzzy";
      # file-browser-directory = "~/documents";
      # file-browser-depth = 0;
      show-icons = true;
    };
  };

  # Doesn't work in tandem with the above
  # xdg.configFile.rofi = {
  #   # enable = true;
  #   source = ./rofi;
  # };

  services.syncthing.enable = true;

  # THIS MIGHT NOT WORK!
  # See https://nixos.wiki/wiki/TexLive
  # programs.texlive = {
  #   enable = true;
  #   # packageSet = pkgs.texlive.combined.scheme-medium;
  #   packageSet = pkgs.texlive.combined {
  #     inherit (pkgs.texlive) scheme-medium; # Choose LaTeX scheme
  #   };
  # };
  # programs.texlive = {
  #   enable = true;
  #   packageSet = pkgs.texlive.combined.scheme-tetex;
  # };
}
