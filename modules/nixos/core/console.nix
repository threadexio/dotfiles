{ pkgs
, ...
}:

{
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-122b.psf.gz";

  environment.systemPackages = with pkgs; [
    terminus_font
  ];
}
