# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_testing;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # configuration.nix

  hardware.nvidia.powerManagement.enable = true;
  # # Making sure to use the proprietary drivers until the issue above is fixed upstream
  hardware.nvidia.open = false;

  networking.hostName = "djangf8sum"; # Define your hostname.
  networking.hosts = {
    "192.168.1.4" = ["sidecar" "sidecar.local" "f8djangsum"];
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "ter-v32n";
    keyMap = lib.mkForce "us-acentos";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.blueman.enable = true;

  # NVIDIA requires nonfree
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.onedrive.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.roche = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" ]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    #   firefox
    #   tree
    # ];
  };
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    bat
    btop
    dig
    eza
    git
    k9s
    killall
    kubectl
    lazygit
    openvpn3
    slurp
    starship
    pass
    pavucontrol
    pciutils
    usbutils
    wget
    zellij
    zoxide
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { 
      fonts = [ "FiraCode" "DroidSansMono" ]; 
    })
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    settings = {
      default-cache-ttl = 3600;
    };
  };
  programs.zsh.enable = true;
  programs.openvpn3.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "roche" ];
  };
  programs.dconf.enable = true;
  programs.seahorse.enable = true; # keyring graphical frontend

  # List services that you want to enable:
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  virtualisation.docker.enable = true;

  services.asusd.animeConfig = ''
    (
        model_override: None,
        system: [],
        boot: [
            ImageAnimation(
                file: "/home/roche/blank.gif",
                scale: 0.9,
                angle: 0.65,
                translation: (0.0, 0.0),
                time: Fade((
                    fade_in: (secs: 2, nanos: 0),
                    show_for: Some((secs: 2, nanos: 0)),
                    fade_out: (secs: 2, nanos: 0),
                )),
                brightness: 1.0,
            ),
        ],
        wake: [
            ImageAnimation(
                # file: "${pkgs.asusctl}/share/asusd/anime/asus/festive/Halloween.gif",
                file: "/home/roche/blank.gif",
                scale: 0.9,
                angle: 0.65,
                translation: (0.0, 0.0),
                time: Fade((
                    fade_in: (secs: 2, nanos: 0),
                    show_for: Some((secs: 2, nanos: 0)),
                    fade_out: (secs: 2, nanos: 0),
                )),
                brightness: 1.0,
            ),
        ],
        sleep: [
            ImageAnimation(
                file: "/home/roche/blank.gif",
                scale: 0.9,
                angle: 0.0,
                translation: (3.0, 2.0),
                time: Infinite,
                brightness: 1.0,
            ),
        ],
        shutdown: [
            ImageAnimation(
                file: "/home/roche/blank.gif",
                scale: 0.9,
                angle: 0.0,
                translation: (3.0, 2.0),
                time: Infinite,
                brightness: 1.0,
            ),
        ],
        display_enabled: false,
        display_brightness: Med,
        builtin_anims_enabled: false,
        off_when_unplugged: true,
        off_when_suspended: true,
        off_when_lid_closed: true,
        brightness_on_battery: Low,
        builtin_anims: (
            boot: GlitchConstruction,
            awake: BinaryBannerScroll,
            sleep: BannerSwipe,
            shutdown: GlitchOut,
        ),
    )
  '';

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

