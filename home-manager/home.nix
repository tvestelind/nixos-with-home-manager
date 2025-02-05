{ config, pkgs, ... }:

{
  home = {
    username = "tvestelind";
    homeDirectory = "/home/tvestelind";
  };

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
        "colorize"
      ];
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
