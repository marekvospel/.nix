{
  lib,
  gtkTheme ? "Breeze-Dark",
  preferDark ? true,
  ...
}:

{
  # GTK 2 / 3
  gtk = {
    enable = true;
    theme.name = gtkTheme;
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = preferDark;
    };
  };
  # GTK 4
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = lib.mkForce gtkTheme;
    color-scheme = if preferDark then "prefer-dark" else "prefer-light";
  };
}
