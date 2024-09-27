{
  ...
}:

{
  programs = {
    # Jump directly to directory, without writing entire path
    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };

    zsh = {
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
        hms = "home-manager switch";
        nrs = "nixos-rebuild switch";
      };
      # autocd = true;
      dotDir = ".config/zsh";
      initExtra = "${builtins.readFile ./zshrc}";
    };
  };
}
