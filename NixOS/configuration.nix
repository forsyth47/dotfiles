# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).


{ config, lib, pkgs, inputs, ... }:
#{ config, lib, pkgs, ... }:
{
  #android_sdk.accept_license = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "Oblivion"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {enable = true; wayland = true;};
  # services.xserver.windowManager.hyprland.enable = true;
  programs.hyprland = {
    enable = true; 
    xwayland.enable = true;
    #extraconfig = ''
    #  exec-once=/usr/lib/polkit-kde-authentication-agent-1
    #  exec-once=/usr/bin/dunst
    #''
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  #wayland.windowManager.hyprland.enable = true;
  #services.xserver.windowManager.hyprland.extraconfig = "exec-once=/usr/lib/polkit-kde-authentication-agent-1";
  #services.xserver.windowManager.hyprland.extraConfig = "exec-once=/usr/bin/dunst";


  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      zero = {
       #initialPassword = "frog";
       shell = pkgs.zsh;
       isNormalUser = true;
       extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
       packages = with pkgs; [
         firefox
         tree
     ];};
   };
 };
  programs = {
      zsh = {
        enable = true;
	autosuggestions.enable = true;
	zsh-autoenv.enable = true;
	syntaxHighlighting.enable = true;
        ohMyZsh = {
          enable = true;
          theme = "alanpeabody";
	 plugins = [
           "git"
           "npm"
           "history"
           "node"
           "rust"
           "deno"
         ];
        };
      };
    };

  users.defaultUserShell=pkgs.zsh; 
  #services.xclip.enable = true;
  #services.dunst.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    imagemagick
    xclip
    libnotify
    wget
    vscode
    htop
    git
    neofetch
    wireplumber
    kitty
    mpv
    brave
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    waybar
    dunst
    wofi
    tofi
    xfce.thunar
    coreutils
    dosfstools
    exfatprogs
    ntfs3g
    sxiv
    python3
    brightnessctl
    #androidsdk
    openjdk
    busybox
    ffmpeg
#    ly
#    hyprland
  ];
  #nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct"; 
      style = {
        package = pkgs.utterly-nord-plasma;
        name = "Utterly Nord Plasma";
      };
  };
  environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
  #nixpkgs.overlays = [
  #  (import (builtins.fetchGit{
  #      url = "https://github.com/nix-community/nerdfonts-overlay";
  #      ref = "main";
  #      }
  #    )
  #  )
  #];
  #fonts.packages = with pkgs; [
  #  nerdfonts-cascadia-code
  #  nerdfonts-jetbrain-mono
  #  nerdfonts-fire-code
  #  nerdfonts-iosevka
  #  nerdfonts-noto
  #];
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "zero" = import ./home.nix;
    };
  };
  fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
      (nerdfonts.override { fonts = ["CascadiaCode" "JetBrainsMono" "FiraCode" "Iosevka" "Noto"];})
      font-awesome
      noto-fonts-emoji
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
