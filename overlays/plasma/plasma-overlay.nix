self: super: {
  ksmoothdock = super.libsForQt5.callPackage ./ksmoothdock.nix { };
  latte-dock-git = self.latte-dock.overrideAttrs (oldAttrs: rec {
    name = "latte-dock-git";
    src = builtins.fetchGit https://github.com/psifidotos/Latte-Dock;

    buildInputs = oldAttrs.buildInputs ++ [ self.kdeFrameworks.knewstuff ] ;

    postPatch = ''
      substituteInPlace app/universalsettings.cpp --subst-var out
    '';

    # postInstall = ''
    #   # substituteInPlace \
    #   #   $out/share/plasma/shells/org.kde.latte.shell/contents/layouts/Plasma.latterc \
    #   #     --subst-var out

    #   for layout in $out/share/plasma/shells/org.kde.latte.shell/contents/layouts/*.latterc; do
    #     substituteAllInPlace "$layout"
    #   done
    # '';
  });
}
