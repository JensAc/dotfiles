{ config, pkgs, ... }:

let
  mach-nix-upstream = import (fetchTarball "https://github.com/DavHau/mach-nix/tarball/3.5.0") {};
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
  '';
  };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "hic";
    home.homeDirectory = "/home/hic";

    xdg.userDirs.enable = true;
    xdg.userDirs.createDirectories = true;

    home.sessionVariables  = {
      EDITOR = "emacsclient";
    };

    imports = [ modules/vdirsyncer.nix ];

    # configure my favorite themes
    gtk = {
      enable = true;
      theme.name = "Adwaita-dark";
      iconTheme = {
        name = "Luna-Dark";
        package = pkgs.luna-icons;
      };
      gtk3.extraConfig = { gtk-cursor-theme-name="Bibata-Modern-Classic";};
    };
    xsession = {
      enable = true;
    };

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      gtk.enable = true;
      x11.enable = true;
      name = "Bibata-Modern-Classic";
    };

    # email account setup
    accounts.email.maildirBasePath = "email";
    accounts.email = {
      accounts.posteo = {
        primary = true;
        mu.enable = true;
        address = "jens.schneider.ac@posteo.de";
      };
      accounts."23Tec" = {
        mu.enable = true;
        address = "schneider@23technologies.cloud";
      };
      accounts.ient = {
        mu.enable = true;
        address = "schneider@ient.rwth-aachen.de";
      };
      accounts.rwth= {
        mu.enable = true;
        address = "jens.schneider1@rwth-aachen.de";
      };
    };

    programs.mu.enable = true;

    # zsh setup
    programs.zsh = {
      enable = true;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "pass" "systemd" "kubectl" ];
        theme = "robbyrussell";
      };
      initExtra = "export PATH=$HOME/bin:$HOME/.krew/bin:$PATH";
    };

    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [{
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }];
    };

    # allow font configuration
    fonts.fontconfig.enable = true;

    nixpkgs.overlays = [
      (import (builtins.fetchGit {
        url = https://github.com/nix-community/emacs-overlay.git;
      }))
    ];
    # get some packages
    home.packages = with pkgs; [
      appimage-run
      gnupg
      pass
      iosevka
      iosevka-bin
      (iosevka-bin.override { variant = "aile"; })
      noto-fonts-emoji
			emacsUnstable
      rofi
      i3lock
      arandr
      khal
      vdirsyncer
      evince
      texlive.combined.scheme-full
      libreoffice
      isync
      mu
      lua53Packages.digestif
      xarchiver
      htop
      xfce.thunar
      xfce.thunar-volman
      grsync
      gnome.gnome-disk-utility
      lxappearance
      libnotify
      rnix-lsp
      xorg.xev
      xorg.xmodmap
      xdotool
      xclip
      nix-index
      slack
      feh
      xournalpp
      teams
      ripgrep
      kubectl
      krew
      gcc
      gdb
      k9s
      fluxcd
      nodejs
      nodePackages.prettier
      nodePackages.npm
      nodePackages.gulp
      signal-desktop
      lxqt.screengrab
      dig
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      minio-client
      bc
      openssl
      kubeval
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
      kubernetes-helm
      libsForQt5.qtkeychain
      libsecret
      gimp
      cmake
      gnumake
      libtool
      libvterm
      google-chrome
      zoom-us
      python310
      meld
      mach-nix-upstream.mach-nix
      jq
      nix-prefetch
      nmap
      go_1_17
      gopls
      ginkgo
      gore
      delve
      inetutils
      openvpn
      ncdu
      file
      vscode
      inkscape
      userhosts
      powertop
      kustomize
      reuse
      tree
      wireshark
      unzip
      dotnetCorePackages.aspnetcore_3_1
      obs-studio
      kind
      v4l-utils
      sops
      xsane
      rt-tests
      patchelf
      font-manager
      kicad
      zip
      govc
      clusterctl
      gh
    ];


    # i3 related dotfiles
    home.file.".config/i3/config".source =~/dotfiles/.config/i3/config;
    home.file.".config/i3/i3status_script.sh".source =~/dotfiles/.config/i3/i3status_script.sh;
    home.file.".config/i3status/config".source =~/dotfiles/.config/i3status/config;

    # rofi config
    home.file.".config/rofi/config.rasi".source =~/dotfiles/.config/rofi/config.rasi;

    # alacritty configuration
    home.file.".config/alacritty/alacritty.yml".source =~/dotfiles/.config/alacritty/alacritty.yml;

    # git config
    home.file.".gitconfig".source =~/dotfiles/.gitconfig;

    # pass plugin for firefox (passff)
    home.file.".mozilla/native-messaging-hosts/passff.json".source = "${pkgs.passff-host}/share/passff-host/passff.json";

    # mbsync
    home.file.".mbsyncrc".source =~/dotfiles/.mbsyncrc;

    # vdirsyncer
    home.file.".config/vdirsyncer/config".source =~/dotfiles/.config/vdirsyncer/config;
    home.file.".config/vdirsyncer/getpwnc.sh".source =~/dotfiles/.config/vdirsyncer/getpwnc.sh;
    home.file.".config/vdirsyncer/getpwnc_tvv.sh".source =~/dotfiles/.config/vdirsyncer/getpwnc_tvv.sh;
    home.file.".config/vdirsyncer/getpwnc_23.sh".source =~/dotfiles/.config/vdirsyncer/getpwnc_23.sh;
    services.vdirsyncer.enable = true;

    # khal
    home.file.".config/khal/config".source =~/dotfiles/.config/khal/config;

    # services.fusuma.enable = true;
    # home.file.".config/fusuma/config.yaml".source =~/dotfiles/.config/fusuma/config.yml;

    home.file.".Xmodmap".source =~/dotfiles/.Xmodmap;

    home.file.".config/dlv/config.yml".source =~/dotfiles/.config/dlv/config.yml;

    services.nextcloud-client.enable = true;
    services.syncthing.enable = true;
    services.network-manager-applet.enable = true;
    services.pasystray.enable = true;
    services.dunst.enable = true;

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 25000;
      maxCacheTtl = 25000;
    };

    services.redshift = {
      enable = true;
      tray = true;
      latitude = 50.7753455;
      longitude = 6.0838868;
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
