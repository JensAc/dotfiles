{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.services.vdirsyncer;
in
{
  options.services.vdirsyncer = {
    enable = mkEnableOption "Enable synchronization of calendars";
    settings = mkOption {
      type = types.attrs;
    };
    onBootSec = mkOption {
      type = types.str;
      default = "15min";
    };
    onUnitActiveSec = mkOption {
      type = types.str;
      default = "30min";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.timers.vdirsyncer = {
      Unit = {
        Description = "Timer to synchronize calendars";
      };

      Timer = {
        OnBootSec = cfg.onBootSec;
        OnUnitActiveSec = cfg.onUnitActiveSec;
      };

      Install.WantedBy = [ "timers.target" ];
    };

    systemd.user.services.vdirsyncer = {
      Unit = {
        Description = "Synchronize your calendars";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Install.WantedBy = [ "default.target" ];

      Service = {
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
        Environment = ["PATH=${pkgs.coreutils}/bin/:${pkgs.bash}/bin:${pkgs.pass}/bin/"];
        Restart = "on-failure";
        Type = "oneshot";
        RestartSec = 30;
      };
    };
  };
}
