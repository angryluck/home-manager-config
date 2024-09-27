{
  pkgs,
  inputs,
  ...
}:
{
  xdg.configFile.nvim = {
    # enable = true;
    source = ./.;
    recursive = true;
  };

  # NOTE: If you make an init.lua in ./nvim, then below code doesn't run.
  # But the above lets us have an after/ftplugin/ folder!!!
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
      ${builtins.readFile ./commands.lua}
      ${builtins.readFile ./keymaps.lua}
    '';

    extraPackages = with pkgs; [
      # LSPs
      lua-language-server
      nil
      nixfmt-rfc-style
      fsautocomplete # FIX: Virker ikke :/
      haskell-language-server
      ### To fix haskell-lsp for xmonad
      # If you want you can use `with hpkgs; [` to avoid explicitly
      # selecting into the hpkgs set on every line
      (haskellPackages.ghcWithPackages (
        hpkgs: with hpkgs; [
          # xmobar
          xmonad
          xmonad-contrib
        ]
      ))
      ccls

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
          #FIX:  Fjern '' og `` (måske)
          plugin = nvim-autopairs;
          config = # lua
            "require('nvim-autopairs').setup({
            disable_filetype = {'tex'}
          })";
        }

        #FIX: neodev virker ikke i home-manger/nvim mappe.
        neodev-nvim # Archived, consider 'lazydev.nvim' instead

        {
          plugin = luasnip;
          config = "require('luasnip.loaders.from_lua').lazy_load()";
        }

        cmp_luasnip
        cmp-path
        {
          plugin = nvim-cmp;
          config = "${builtins.readFile ./lua/plugins/autocompletion.lua}";
        }

        cmp-nvim-lsp
        {
          plugin = nvim-lspconfig;
          config = "${builtins.readFile ./lua/plugins/lsp.lua}";

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
          config = "${builtins.readFile ./lua/plugins/treesitter.lua}";
        }

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
        #   config = "${builtins.readFile ./plugins/flash.lua}";
        # }

        {
          plugin = oil-nvim;
          config = "require('oil').setup()";
        }

        # plenary-nvim
        {
          #NOTE: Possible commands: NOTE, FIX, TOD, HACK, WARN, PERF & TEST.
          plugin = todo-comments-nvim;
          config = # lua
            ''
              require('todo-comments').setup()
              vim.keymap.set("n", "]t", function()
              require("todo-comments").jump_next({
                keywords = { "TODO", "HACK", "WARN", "FIX", "PERF" }
              })
              end, { desc = "Next error/warning todo comment" })
              vim.keymap.set("n", "[t", function()
              require("todo-comments").jump_prev({
                keywords = { "TODO", "HACK", "WARN", "FIX", "PERF"}
              })
              end, { desc = "Next error/warning todo comment" })
            '';
        }
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
        #
        ### git.lua
        # vim-fugitive
        # vim-rhubarb
        # gitsigns-nvim
        #
        haskell-tools-nvim
        Ionide-vim
        # zarchive-vim-fsharp
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

}
