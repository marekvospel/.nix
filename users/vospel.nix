{
  config,
  pkgs,
  lib,
  ...
}@inputs:

{
  home.username = "vospel";
  home.homeDirectory = "/home/vospel";

  home.stateVersion = "24.05";

  imports = [
    (import ../modules/gtk.nix (
      inputs
      // {
        theme = "Breeze-Dark";
        preferDark = true;
      }
    ))
  ];

  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    waybar
    tree-sitter
    kdePackages.breeze
    kdePackages.breeze-gtk
    qt6ct
    papirus-icon-theme
    grim
    dunst
    slurp
    wl-clipboard
    bibata-cursors
    spaceship-prompt
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.emoji = [ "Twitter Color emoji" ];
    defaultFonts.monospace = [ "MapleMono NF" ];
    defaultFonts.sansSerif = [ "DejaVu Sans" ];
    defaultFonts.serif = [ "DejaVu Sans" ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    initExtra = ''
      source ${pkgs.spaceship-prompt}/share/zsh/themes/spaceship.zsh-theme;
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "MapleMono NF 12";
    theme = "${pkgs.rofi-wayland}/share/rofi/themes/lb.rasi";
    extraConfig = {
      modi = "combi";
      show-icons = true;
    };
    plugins = [
      pkgs.rofi-calc
      # pkgs.rofi-emoji
    ];
  };

  programs.mise = {
    enable = true;
    settings = { };
  };

  programs.home-manager.enable = true;
}
