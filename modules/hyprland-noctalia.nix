{ ... }:
{
  programs.noctalia = {
    enable = true;
    settings = {
      dock.enabled = false;
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];

        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600;
          };

          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 900;
          };

          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 660;
          };
        };

      };

      location.address = "Las Vegas, United States";
      bar = {

        order = "main";

        widgets = {
          margin_ends = 2;
          widget_spacinbg = 1;
        };

        widgets = {
          left = [
            {
              id = "Launcher";
              useDistroLogo = true;
            }
            {
              id = "Clock";
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
              alwaysShowPercentage = true;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "plugin:network-manager-vpn";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
      wallpaper = {
        directory = "~/Pictures/wallpaper-collection/wallpapers/";
        enableMultiMonitorDirectories = true;
        automationEnabled = true;
      };
      sessionMenu.enableCountdown = false;
      nightlight.enabled = true;
      colorSchemes.predefinedScheme = "Noctalia (default)";
      templates = {
        activeTemplates = [
          {
            enabled = true;
            id = "ghostty";
          }
          {
            enabled = true;
            id = "starship";
          }
          {
            enabled = true;
            id = "kitty";
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # package and portal package set to null to use the packages
    # declared in the NixOS module
    package = null;
    portalPackage = null;

    configType = "hyprlang";

    settings = {
      exec-once = [ "noctalia" ];

      general = {
        gaps_in = 2;
        gaps_out = 5;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";

        };

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      layerrule = {
        name = "noctalia";
        "match:namespace" = "noctalia-background-.*$";
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;

      };

      monitor = [
        "desc:Acer Technologies EB321HQU 240300AD63E00, 2560x1440@59, 0x0, 1"
        "eDP-1, 1920x1080@60, auto-right, 1"
        "DP-1, preferred, auto, 1"
        ", preferred, auto, 1"
      ];

      workspace = [
        "1, monitor:desc:Acer Technologies EB321HQU 240300AD63E00, default:true"
      ];

      cursor = {
        default_monitor = "HDMI-A-1";
      };

      input = {
        follow_mouse = 2;
      };

      #Global variables for bindings
      "$mod" = "SUPER";

      "$terminal" = "ghostty";
      "$browser" = "brave";
      "$explorer" = "ghostty -e zsh -ic 'y'";

      "$ipc" = "noctalia msg";
      #------END Global variables for bindings

      "bindr" = [
        "SUPER, SUPER_L, exec, $ipc panel-toggle launcher"
      ];

      "bindel" = [
        # Media keys
        ", XF86AudioRaiseVolume, exec, $ipc volume-up"
        ", XF86AudioLowerVolume, exec, $ipc volume-down"
        ", XF86MonBrightnessUp, exec, $ipc brightness-up"
        ", XF86MonBrightnessDown, exec, $ipc brightness-down"
      ];

      "bind" = [

        # ── Applications ────────────────────────────────────────────────────
        "$mod,       Return,    exec, $terminal"
        "$mod,       B,         exec, $browser"
        "$mod,       E,         exec, $explorer"
        "$mod,       S,         exec, $ipc settings-toggle"

        # ── Window actions ──────────────────────────────────────────────────
        "$mod,       Q,         killactive"
        "$mod,       F,         fullscreen"
        "$mod,       T,         togglefloating"
        # "$mod,       F,         pseudo"

        # ── Focus — right hand never leaves hjkl ────────────────────────────
        "$mod,       H,         movefocus, l"
        "$mod,       J,         movefocus, d"
        "$mod,       K,         movefocus, u"
        "$mod,       L,         movefocus, r"

        # ── Move windows — $mod + SHIFT + hjkl ─────────────────────────────
        "$mod SHIFT, H,         movewindow, l"
        "$mod SHIFT, J,         movewindow, d"
        "$mod SHIFT, K,         movewindow, u"
        "$mod SHIFT, L,         movewindow, r"

        # ── Workspaces — number row, zero hand movement ──────────────────────
        "$mod,       1,         workspace, 1"
        "$mod,       2,         workspace, 2"
        "$mod,       3,         workspace, 3"
        "$mod,       4,         workspace, 4"
        "$mod,       5,         workspace, 5"
        "$mod,       6,         workspace, 6"
        "$mod,       7,         workspace, 7"
        "$mod,       8,         workspace, 8"
        "$mod,       9,         workspace, 9"

        # Move active window to workspace
        "$mod SHIFT, 1,         movetoworkspace, 1"
        "$mod SHIFT, 2,         movetoworkspace, 2"
        "$mod SHIFT, 3,         movetoworkspace, 3"
        "$mod SHIFT, 4,         movetoworkspace, 4"
        "$mod SHIFT, 5,         movetoworkspace, 5"
        "$mod SHIFT, 6,         movetoworkspace, 6"
        "$mod SHIFT, 7,         movetoworkspace, 7"
        "$mod SHIFT, 8,         movetoworkspace, 8"
        "$mod SHIFT, 9,         movetoworkspace, 9"

        # Cycle workspaces — O/P sit naturally beside hjkl navigation
        "$mod,       O,         workspace, e-1"
        "$mod,       P,         workspace, e+1"
        # Move window to adjacent workspace with , and .
        "$mod SHIFT, COMMA,     movetoworkspace, e-1"
        "$mod SHIFT, PERIOD,    movetoworkspace, e+1"

        # ── Scratchpad ───────────────────────────────────────────────────────
        # Z = bottom-left, easy to remember as "stash away"
        # "$mod,       Z,         togglespecialworkspace, magic"
        # "$mod SHIFT, Z,         movetoworkspace, special:magic"

        # ── Misc ─────────────────────────────────────────────────────────────
        "$mod,       M,         exit," # exit Hyprland

      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ",  XF86AudioMute,      exec, $ipc volume-mute"
        ",  XF86AudioPlay,      exec, $ipc media toggle"
        ",  XF86AudioNext,      exec, $ipc media next"
        ",  XF86AudioPrev,      exec, $ipc media previous"
      ];

      binde = [
        "$mod CTRL, H,          resizeactive, -40 0"
        "$mod CTRL, J,          resizeactive,   0 40"
        "$mod CTRL, K,          resizeactive,   0 -40"
        "$mod CTRL, L,          resizeactive,  40 0"
      ];

      windowrule = [
        # Float small utility windows
        "float on, match:class ^(pavucontrol)$"
        "float on, match:class ^(nm-connection-editor)$"
        "float on, match:class ^(blueman-manager)$"
        "float on, match:title ^(Picture-in-Picture)$"
        # Keep PiP on all workspaces
        "pin on,   match:title ^(Picture-in-Picture)$"
        # Suppress idle inhibit for fullscreen video
        "idle_inhibit fullscreen, match:class ^(brave)$"
        # Force file dialogs to float
        "float on, match:title ^(Open File)$"
        "float on, match:title ^(Save File)$"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };
  };

}
