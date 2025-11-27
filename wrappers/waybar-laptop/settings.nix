{
  layer = "top";
  position = "top";
  height = 20;
  spacing = 0;

  modules-left = [ "sway/workspaces" ];
  modules-right = [
    "network"
    "custom/tailscale"
    "bluetooth"
    "custom/cpu"
    "custom/gpu"
    "memory"
    "disk"
    "backlight"
    "pulseaudio"
    "custom/battery"
    "clock"
  ];

  "sway/workspaces" = {
    disable-scroll = false;
    all-outputs = true;
    format = "{index}";
    persistent-workspaces = {
      "1" = [ ];
      "2" = [ ];
      "3" = [ ];
      "4" = [ ];
      "5" = [ ];
      "6" = [ ];
      "7" = [ ];
      "8" = [ ];
      "9" = [ ];
      "10" = [ ];
    };
  };

  network = {
    format-wifi = "NET {ipaddr:>15} ↓{bandwidthDownBits:>8} ↑{bandwidthUpBits:>8}";
    format-ethernet = "NET {ipaddr:>15} ↓{bandwidthDownBits:>8} ↑{bandwidthUpBits:>8}";
    format-disconnected = "NET Disconnected";
    tooltip = true;
    tooltip-format-wifi = "{essid} ({signalStrength}%)";
    tooltip-format-ethernet = "{ifname}";
    on-click = "nmgui";
    interval = 1;
  };

  "custom/tailscale" = {
    exec = "tailscale status --json 2>/dev/null | jq -r 'if .BackendState == \"Running\" then \"VPN \" + (.Self.TailscaleIPs[0] // \"N/A\") else \"VPN Off\" end'";
    interval = 5;
    format = "{}";
    tooltip = false;
    return-type = "";
  };

  "custom/cpu" = {
    exec = ''
      usage=$(awk '/^cpu / {printf "%3d", ($2+$4)*100/($2+$4+$5)}' /proc/stat)
      temp=$(awk '{printf "%3d", $1/1000}' /sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input 2>/dev/null | head -1)
      if [ "$temp" -ge 80 ]; then
        printf "CPU %s%% <span color='#F7768E'>%s°C</span>" "$usage" "$temp"
      else
        printf "CPU %s%% %s°C" "$usage" "$temp"
      fi
    '';
    format = "{}";
    tooltip = false;
    interval = 1;
  };

  "custom/gpu" = {
    exec = ''
      usage=$(cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1 || echo "0")
      temp=$(awk '{printf "%3d", $1/1000}' /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1)
      if [ "$temp" -ge 80 ]; then
        printf "GPU %3d%% <span color='#F7768E'>%s°C</span>" "$usage" "$temp"
      else
        printf "GPU %3d%% %s°C" "$usage" "$temp"
      fi
    '';
    format = "{}";
    tooltip = false;
    interval = 1;
  };

  memory = {
    format = "MEM {used:>4.1f}G/{total:>4.1f}G";
    tooltip = false;
    interval = 1;
  };

  disk = {
    format = "DSK {used}/{total}";
    path = "/";
    tooltip = false;
    interval = 30;
  };

  pulseaudio = {
    format = "VOL {volume:>3}%";
    format-muted = "VOL  MTD";
    tooltip = false;
    format-icons.default = [
      ""
      ""
      ""
    ];
    on-click = "pavucontrol";
  };

  clock = {
    interval = 1;
    format = "{:%I:%M:%S %p}";
    format-alt = "{:%H:%M:%S}";
    tooltip-format = "<tt><big>{:%B %Y}</big>\n{calendar}</tt>";
    calendar = {
      mode = "year";
      mode-mon-col = 3;
      weeks-pos = "";
      on-scroll = 0;
      format = {
        months = "<span color='#ffffff'><b>{}</b></span>";
        days = "<span color='#888888'>{}</span>";
        weeks = "<span color='#666666'><b>W{}</b></span>";
        weekdays = "<span color='#aaaaaa'><b>{}</b></span>";
        today = "<span color='#000000' background='#ffffff'><b>{}</b></span>";
      };
    };
    actions.on-click-right = "mode";
  };

  "custom/battery" = {
    exec = ''
      cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
      mah=$(awk '{printf "%5d", $1/1000}' /sys/class/power_supply/BAT*/charge_now 2>/dev/null | head -1)
      status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
      if [ "$status" = "Charging" ]; then
        printf "<span color='#41A6B5'>BAT</span> %3d%% %smAh" "$cap" "$mah"
      elif [ "$cap" -le 10 ]; then
        printf "<span color='#F7768E'>BAT</span> %3d%% %smAh" "$cap" "$mah"
      elif [ "$cap" -le 20 ]; then
        printf "<span color='#E0AF68'>BAT</span> %3d%% %smAh" "$cap" "$mah"
      else
        printf "BAT %3d%% %smAh" "$cap" "$mah"
      fi
    '';
    format = "{}";
    tooltip = false;
    interval = 1;
  };

  backlight = {
    format = "BRT {percent:>3}%";
    tooltip = false;
  };

  bluetooth = {
    format = "BLU {status}";
    format-on = "BLU ON";
    format-off = "BLU OFF";
    format-connected = "BLU ON";
    format-disabled = "BLU OFF";
    tooltip = false;
    on-click = "blueman-manager";
  };
}
