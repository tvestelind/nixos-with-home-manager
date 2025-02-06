{ config, pkgs, lib, ... }:

{
  home = {
    username = "tvestelind";
    homeDirectory = "/home/tvestelind";
    packages = with pkgs; [
      liberation_ttf
    ];
    file.".ssh/allowed_signers".text = ''
      tomas.vestelind@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPzf+MfJn9DZXisWYkjayHecitjigUitNQDxzjvKTV7
    '';
  };

  programs = {
    home-manager.enable = true;
    zsh = {
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
    urxvt = {
      enable = true;
      fonts = [ "xft:Liberation Mono:pixelsize=14:antialias=true" ];
      scroll.bar.enable = false;
      extraConfig = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        cursorColor = "#F5E0DC";
        
        color0 = "#45475A";
        color1 = "#F38BA8";
        color10 = "#A6E3A1";
        color11 = "#F9E2AF";
        color12 = "#89B4FA";
        color13 = "#F5C2E7";
        color14 = "#94E2D5";
        color15 = "#A6ADC8";
        color2 = "#A6E3A1";
        color3 = "#F9E2AF";
        color4 = "#89B4FA";
        color5 = "#F5C2E7";
        color6 = "#94E2D5";
        color7 = "#BAC2DE";
        color8 = "#585B70";
        color9 = "#F38BA8";

        mouseWheelScrollPage = "true";
        selectToClipboard = "true";
        letterSpace = "0";
        lineSpace = "0";
        cursorUnderline = "false";
      };
    };
    ssh = {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent "~/.1password/agent.sock"
      '';
    };
    git = {
      enable = true;
      userName = "Tomas Vestelind";
      userEmail = "tomas.vestelind@gmail.com";
      extraConfig = {
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit.gpgsign = true;
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPzf+MfJn9DZXisWYkjayHecitjigUitNQDxzjvKTV7";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  services = {
    ssh-agent.enable = true;
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
