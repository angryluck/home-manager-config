{ ... }:
{
  #FIX: Reparer polybar, og skift xmobar ud med det.
  #Enten konfigurer i xmonad.hs, ellers få nedenstående til at virke...
  services.polybar = {
    enable = true;
    script = "polybar -c ~/.config/home-manager/polybar/reedrw base&";
    config = ./config.ini;
    # config = {
    #   "bar/top" = {
    #     monitor = "\${env:MONITOR:eDP1}";
    #     width = "100%";
    #     height = "3%";
    #     radius = 0;
    #     modules-center = "date";
    #   };
    #
    #   "module/date" = {
    #     type = "internal/date";
    #     internal = 5;
    #     date = "%d.%m.%y";
    #     time = "%H:%M";
    #     label = "%time%  %date%";
    #   };
    # };
  };
}
