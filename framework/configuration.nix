# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users/jp/home-manager.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jp"; # Define your hostname.
  networking.wireless.enable = false;  
  networking.networkmanager.enable = true; # does wireless too

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp170s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #jpeterson remove some default stuff that's replaced
  environment.gnome.excludePackages = [ 
    pkgs.gnome.cheese 
    pkgs.gnome-photos 
    pkgs.gnome.gnome-music 
    pkgs.gnome.gnome-terminal 
    pkgs.gnome.gedit 
  ];

  environment.variables = rec {
    EDITOR = "vim";
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jp = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #editors
    vim 
    alacritty
    vscode
   
    #utils 
    wget
    xclip
    htop
    tmux
    git
    
    #apps
    firefox
    spotify
    zoom-us
    gparted
    mupdf
    libreoffice

    #games 
    steam
    openrct2

    #display
    gnome.gnome-tweaks
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?


  # Begin jpeterson custom params 
  # (most suggested per http://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html)
  
  programs.steam.enable = true;

  # deep sleep
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # support unfree packages like steam
  nixpkgs.config.allowUnfree = true;

  services.thermald.enable = true;

  # battery preservation configs (https://github.com/linrunner/TLP)
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC="performance";
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      START_CHARGE_THRESH_BAT1=75;
      STOP_CHARGE_THRESH_BAT1=80;
    };
  };

  # and some from https://grahamc.com/blog/nixos-on-framework

  # latest kernel, mainly for wifi support
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  #eventual usage of the framework fingerprint scanner
  services.fprintd.enable = true;
}

