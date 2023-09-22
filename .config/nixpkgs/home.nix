{ config, pkgs, ... }:

let
  mach-nix-upstream = import (fetchTarball "https://github.com/DavHau/mach-nix/tarball/3.5.0") {};
  pkgsUnstable = import <nixos-unstable> {};
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
  '';
  };

    nixpkgs.overlays = [
      (import (builtins.fetchGit {
        url = https://github.com/nix-community/emacs-overlay.git;
      }))
      (final: previous: {
        mu = pkgsUnstable.mu;
      })
      (final: previous: {
        fluxcd = pkgsUnstable.fluxcd;
      })
    ];

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
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "pass" "systemd" "kubectl" ];
        theme = "robbyrussell";
      };
      initExtra = "export PATH=$HOME/bin:$HOME/.krew/bin:$HOME/.npm-global/bin:$PATH";
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

    # get some packages
    home.packages = with pkgs; [
      azure-cli
      AusweisApp2
			emacs-unstable
      (iosevka-bin.override { variant = "aile"; })
      appimage-run
      arandr
      bc
      bitwarden
      cfssl
      clusterctl
      cmake
      delve
      dig
      direnv
      element-desktop
      evince
      feh
      file
      fluxcd
      font-manager
      fzf
      gcc
      gdb
      gh
      gimp
      ginkgo
      gnome.gnome-disk-utility
      gnumake
      gnupg
      go
      google-chrome
      google-cloud-sdk
      gopls
      gore
      govc
      gradle
      grsync
      htop
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
      i3lock
      inetutils
      inkscape
      iosevka
      iosevka-bin
      isync
      jdk
      jetbrains.idea-community
      jetbrains.goland
      jq
      jwt-cli
      pkgsUnstable.k9s
      khal
      kicad
      kind
      ko
      kotlin
      krew
      kubectl
      kubernetes-code-generator
      kubernetes-helm
      kubeval
      kustomize
      libnotify
      libreoffice
      libsForQt5.qtkeychain
      libsecret
      libtool
      libvterm
      lua53Packages.digestif
      lxappearance
      lxqt.screengrab
      mach-nix-upstream.mach-nix
      meld
      minikube
      minio-client
      mu
      ncdu
      nix-index
      nix-prefetch
      nmap
      nodePackages.bash-language-server
      nodePackages.gulp
      nodePackages.npm
      nodePackages.prettier
      nodePackages.yaml-language-server
      nodejs
      noto-fonts-emoji
      obs-studio
      openssl
      openstackclient
      openvpn
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      patchelf
      pdftk
      powertop
      protobuf
      protoc-gen-go
      python310
      rclone
      reuse
      ripgrep
      rnix-lsp
      rofi
      rt-tests
      signal-desktop
      skaffold
      slack
      sops
      teams
      terraform 
      texlive.combined.scheme-full
      tree
      unzip
      userhosts
      v4l-utils
      vdirsyncer
      vscode
      wireshark
      xarchiver
      xclip
      xdotool
      xfce.thunar
      xfce.thunar-volman
      xorg.xev
      xorg.xmodmap
      xournalpp
      xsane
      yarn
      zellij
      zip
      zoom-us
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
    
    home.file.".config/.npmrc".source =~/dotfiles/.npmrc;

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

    services.clipmenu = {
      enable = true;
      launcher = "rofi";
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
