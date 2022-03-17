{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.fusuma;
in
{
  options.services.fusuma = {
    enable = mkEnableOption "Enable fusuma service";

    package = mkOption {
      type = types.package;
      default = pkgs.fusuma;
      defaultText = literalExample "pkgs.fusuma";
      description = "The fusuma package to install.";
    };

  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.fusuma = {
      Unit = {
        Description = "Fusuma multitouch gesture recognizer";
      };

      Service = {
        ExecStart = "${cfg.package}/bin/fusuma";
        Environment = ["PATH=${pkgs.coreutils}/bin/:${pkgs.xdotool}/bin/" "DISPLAY=:0"];
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ];
}