# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."enc-root" = {
    device = "/dev/disk/by-uuid/20205a25-8131-4c26-aff0-deae68562045";
    allowDiscards = true;
    preLVM = true;
  }; 

  # Sysctl params
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000; # Increase the maximum buffer size for UDP https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size
  };

  networking.hostName = "nunc"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts = "127.0.0.1 api.local.local.internal.local.gardener.cloud
127.0.0.1 api.local.local.external.local.gardener.cloud
172.18.6.1 dashboard.local.gardener.cloud
172.18.6.1 api.local.gardener.cloud
172.18.6.1 identity.local.gardener.cloud
";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = true;
  # networking.interfaces.wlp0s20f3.useDHCP = true;
  # networking.interfaces.enp0s13f0u1u2u1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.wacom.enable = true;

  services.xserver.displayManager.job.preStart = "sleep 0.25";
  services.xserver.resolutions = [
    {
      x = 2560;
      y = 1600;
    }
    {
      x = 3840;
      y = 2160;
    }
  ];
  services.xserver.dpi = 165;

  # Configure keymap in X11
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.printing.startWhenNeeded = true;
  services.printing.drivers = with pkgs; [
    (pkgsi686Linux.callPackage ./dcpj315w {}).driver
    (callPackage ./dcpj315w {}).cupswrapper
  ];
  services.colord.enable = true;

  services.tailscale.enable = true;
  services.tlp.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.accelSpeed = "2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.realtime.gid = 135;
  users.users.hic = {
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "1234";
    extraGroups = [ "wheel" "input" "docker" "realtime" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;  [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    git
    alacritty
  ];
  
  environment.sessionVariables = {
    TERMINAL = "alacritty";
  };

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.noisetorch.enable = true; 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.gvfs = {
    enable = true;
  };
 
  services.gnome.gnome-keyring.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.package = unstable.docker;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "hic" ];

  security.pam.loginLimits = [
  {
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "97816";
  }
  {
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "97816";
  }
];
  
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "50-uhk60.rules";
      text = ''
   SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
   SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
   KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
  '';
      destination = "/etc/udev/rules.d/50-uhk60.rules";
    })
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # 
  # see https://kubernetes.io/docs/reference/ports-and-protocols/
  #
  networking.firewall.trustedInterfaces = [ "docker0" "br-+" "veth+" "tailscale0" ];
  # networking.firewall.allowedTCPPorts = [ 2379 2380 6443 10250 10259 10257 ];
  # networking.firewall.allowedTCPPortRanges = [
  #  { from = 30000; to = 32767; }
  # ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

