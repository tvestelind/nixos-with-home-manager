# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ 
  config, 
  lib, 
  pkgs, 
  inputs,  
  outputs,
  ... 
}: {
  imports = [ 
    ./hardware-configuration.nix 
    inputs.home-manager.nixosModules.home-manager
  ];

  # Use Grub2 as bootloader
  boot = {
    loader = {
      grub = {
	enable = true;
	device = "nodev";
	efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
    initrd.luks.devices.root = {
      # Get UUID from blkid /dev/sda2
      device = "/dev/disk/by-uuid/0ad54bfe-6316-4406-bf45-229c046d3c87";
      preLVM = true;
      allowDiscards = true;
    };
  };
 
  networking = {
    hostName = "tp-x280";
    networkmanager = { 
      enable = true;
      wifi.powersave = true;
    };
  };
    
  powerManagement.enable = true;
  time.timeZone = "Europe/Stockholm";
  console.useXkbConfig = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services = {
    thermald.enable = true;
    printing.enable = true;
    blueman.enable = true;
    autorandr.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "sddm-astronaut-theme";
	package = pkgs.kdePackages.sddm;
	# Workaround to get theme to work
	extraPackages = with pkgs; [
            kdePackages.qtmultimedia
            kdePackages.qtsvg
            kdePackages.qtvirtualkeyboard
        ];
      };
      defaultSession = "none+i3";
    };
    xserver = {
      enable = true;
      xkb = {
        variant = "dvorak_a5";
        options = "ctrl:nocaps,compose:lwin";
	layout = "se";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
  
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
       tvestelind = import ../home-manager/home.nix;
    };
  };

  # Zsh must be enabled here as well as for Home Manager
  programs = {
    zsh.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "tvestelind" ];
    };
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          turbo = "auto";
        };
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tvestelind = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    pathsToLink = [ "/libexec" ]; # Used to make i3blocks work
    systemPackages = with pkgs; [
      autorandr
      pavucontrol
      sddm-astronaut
    ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
