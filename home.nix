{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "angryluck";
  home.homeDirectory = "/home/angryluck";

  # DON'T CHANGE, UNLESS YOU HAVE READ Home Manager RELEASE NOTES!
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [

    # Browser
    firefox

    # cli-tools
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

    # Applications
    zathura
    nautilus
    # dolphin
    # logseq
    # isabelle
    feh
    # virtualbox

    # Utilities
    redshift
    syncthing
    flameshot
    # wineWowPackages.stable

    # Terminal
    wezterm

    # Programming languages
    gcc14
    gdb
    # fsharp
    # ghc
    # python
    # rust
    # go
    # kotlin

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
    # polybar (enable below)
    # ranger
    # rofimoji
    # sbctl (secureboot key manager)
    # slock
    # tlp (in configuration.nix)
    # ueberzugpp
    # wirelesstools
    # xdotool

  ];

  programs.home-manager.enable = true; # NEEDED

  xdg.configFile.nvim = {
    # enable = true;
    source = ./nvim;
    recursive = true;
  };
  # Doesn't work :/
  # xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";

  # NOTE: If you make an init.lua in ./nvim, then below code doesn't run.
  # But the above lets us have an after/ftplugin/ folder!!!
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/commands.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
    '';

    extraPackages = with pkgs; [
      # LSPs
      lua-language-server
      nil
      nixfmt-rfc-style
      fsautocomplete # TODO: Fix!
      haskell-language-server
      ### To fix haskell-lsp for xmonad
      # If you want you can use `with hpkgs; [` to avoid explicitly
      # selecting into the hpkgs set on every line
      (haskellPackages.ghcWithPackages (
        hpkgs: with hpkgs; [
          xmobar
          xmonad
          xmonad-contrib
        ]
      ))

      tree-sitter
    ];
    # Use 'map' to set default 'type' for plugins
    plugins =
      with pkgs.vimPlugins;
      map (plugin: plugin // { type = plugin.type or "lua"; }) [
        # NOTE: 'opts' options in lazy.nvim config corresponds to passing
        # the options to '<Plugin>.config()' function.
        {
          plugin = nvim-surround;
          config = # lua
            ''
              require('nvim-surround').setup({
                keymaps = { visual = false, },
              })
            '';
        }
        {
          plugin = catppuccin-nvim;
          config = "vim.cmd.colorscheme 'catppuccin'";
        }

        vim-nix

        {
          plugin = nvim-autopairs;
          config = "require('nvim-autopairs').setup()";
        }

        neodev-nvim # Archived, consider 'lazydev.nvim' instead
        {
          plugin = nvim-cmp;
        }
        cmp-nvim-lsp
        {
          plugin = nvim-lspconfig;
          config = "${builtins.readFile ./nvim/plugins/lsp.lua}";

        }

        # Virker ikke med nvim-hmts :/
        nvim-treesitter-textobjects
        # nvim-treesitter-context # This one sucks :/
        nvim-treesitter-refactor
        {
          # plugin = nvim-treesitter.withAllGrammars;
          plugin = (
            nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-vim
              p.tree-sitter-lua
              p.tree-sitter-bash
              p.tree-sitter-c
              p.tree-sitter-rasi # rofi syntax, maybe not needed
            ])
          );
          config = "${builtins.readFile ./nvim/plugins/treesitter.lua}";
        }
        # {
        #   plugin = (
        #     nvim-treesitter.withPlugins (p: [
        #       p.tree-sitter-nix
        #       p.tree-sitter-vim
        #       p.tree-sitter-lua
        #       p.tree-sitter-bash
        #       p.tree-sitter-c
        #       p.tree-sitter-rasi # rofi syntax, maybe not needed
        #     ])
        #   );
        # }

        vim-repeat

        {
          plugin = leap-nvim;
          config = # lua
            ''
              require('leap').create_default_mappings()
              require('leap.user').set_repeat_keys('<enter>', '<backspace>')
              vim.keymap.set('n',        's', '<Plug>(leap)')
              vim.keymap.set('n',        'S', '<Plug>(leap-from-window)')
              vim.keymap.set({'x', 'o'}, 's', '<Plug>(leap-forward)')
              vim.keymap.set({'x', 'o'}, 'S', '<Plug>(leap-backward)')
            '';
        }

        # {
        #   plugin = flash-nvim;
        #   config = "${builtins.readFile ./nvim/plugins/flash.lua}";
        # }

        {
          plugin = oil-nvim;
          config = "require('oil').setup()";
        }

        todo-comments-nvim

        {
          plugin = vimtex;
          config = "vim.g.vimtex_view_method = 'zathura'";
        }

        hmts-nvim

        # Måske senere, når behovet rammer:
        # telekasten-nvim
        # markdown-preview-nvim
        # harpoon
        # neorg
        # sideways (lav med treesitter i stedet)
        # vim-orgmode (logseq i stedet)

        # Behøves ikk:
        # conform
        # colorscheme

        # Mangler (ik på nixpkgs)
        # scrollEOF

        ### Resterende, fra nvim/lua/angryluck/plugins:
        #
        ### completion.lua
        # nvim-cmp
        # luasnip
        #
        ### git.lua
        # vim-fugitive
        # vim-rhubarb
        # gitsigns-nvim
        #
        haskell-tools-nvim
        #
        # isabelle-lsp.lua (skal stadig have det til at virke)
        #
        ### telescope-nvim
        ## herunder:
        # plenary-nvim
        # telescope-fzf-native-nvim
        # telescope-ui-select-nvim
        # nvim-web-devicons
        # telescope-emoji-nvim (mangler fra nixpkgs)
        #
        # vim-template
        # 
        # which-key-nvim (mangler fra nixpkgs)

      ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "ls --color --group-directories-first -F";
      cp = "cp -i"; # Interactive
      df = "df -h";
      free = "free -m";
      bc = "bc -l";
    };
    # autocd = true;
    dotDir = ".config/zsh";
    initExtra = "${builtins.readFile ./zsh/.zshrc}";
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd j" ];
  };

  programs.git = {
    enable = true;
    userName = "angryluck";
    userEmail = "thomas@surlykke.dk";
  };

  programs.yazi.enable = true;

  programs.wezterm = {
    enable = true;
    extraConfig = "${builtins.readFile ./wezterm/wezterm.lua}";
  };

  # THIS MIGHT NOT WORK!
  # See https://nixos.wiki/wiki/TexLive
  # programs.texlive = {
  #   enable = true;
  #   packageSet = pkgs.texlive.combined.scheme-tetex;
  # };

  #TODO: Fix rofi, gennemcheck intet mangler (og backup på netter), installer!
}
