{ pkgs
, ...
}:

{
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      obs-gstreamer
      obs-media-controls
      obs-pipewire-audio-capture
      obs-source-clone
      obs-source-record
      obs-vaapi
      obs-vkcapture
      wlrobs
    ];
  };
}
