{pkgs, ...}: {
  languages.nix = {
    enable = true;
  };

  packages = [
    pkgs.alejandra
    pkgs.statix
    pkgs.nixd
  ];
}
