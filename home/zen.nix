# Zen Browser. Not in nixpkgs; comes from the community flake
# (github:0xc000022070/zen-browser-flake), wired in as the `zen-browser` input.
{ inputs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
