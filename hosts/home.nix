{ config, lib, pkgs, ... }:
let
  generic = import ./generic.nix;
  signal-desktop-alt = generic {
    pname = "signal-desktop";
    dir = "Signal";
    version = "5.33.0";
    hash = "sha256-QobRd2KjbsaJOxX9fL97NjK8FpebwBtfr0Q2O/cK4O4=";
    inherit (pkgs) stdenv fetchurl;
    inherit (pkgs.buildPackages) autoPatchelfHook dpkg wrapGAppsHook makeWrapper;
    inherit (pkgs) nixosTests gtk3 atk at-spi2-atk cairo pango gdk-pixbuf glib freetype
      fontconfig dbus libX11 xorg libXi libXcursor libXdamage libXrandr
      libXcomposite libXext libXfixes libXrender libXtst libXScrnSaver nss
      nspr alsa-lib cups expat libuuid at-spi2-core libappindicator-gtk3 mesa
      systemd libnotify libdbusmenu libpulseaudio xdg-utils wayland;
  };
in
{
  imports = 
    (import ../modules/programs); # ++ (import ../modules/services);

  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    username = "ben";
    homeDirectory = "/home/ben";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.

    stateVersion = "22.11";
    packages = with pkgs; [
      htop
      alacritty
      signal-desktop-alt
    ];
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fix for https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false; 
  
  # Git Config
  programs.git = {
    enable = true;
    userName = "charles37";
    userEmail = "benprevor@gmail.com";
  };


  home.file = {
    ".config/alacritty/alacritty.yml".text = ''
# Configuration for Alacritty, the GPU enhanced terminal emulator.

# Any items in the `env` entry below will be added as
# environment variables. Some entries may override variables
# set by alacritty itself.
env:
  # TERM variable
  #
  # This value is used to set the `$TERM` environment variable for
  # each instance of Alacritty. If it is not present, alacritty will
  # check the local terminfo database and use `alacritty` if it is
  # available, otherwise `xterm-256color` is used.
  TERM: xterm-256color

window:
  # Window dimensions (changes require restart)
  #
  # Specified in number of columns/lines, not pixels.
  # If both are `0`, this setting is ignored.
  #dimensions:
  #  columns: 0
  #  lines: 0

  # Window position (changes require restart)
  #
  # Specified in number of pixels.
  # If the position is not set, the window manager will handle the placement.
  #position:
  #  x: 0
  #  y: 0

  # Window padding (changes require restart)
  #
  # Blank space added around the window in pixels. This padding is scaled
  # by DPI and the specified value is always added at both opposing sides.
  padding:
    x: 6
    y: 6

  # Spread additional padding evenly around the terminal content.
  dynamic_padding: false

  Background opacity: 0.95
  #
  # Window opacity as a floating point number from `0.0` to `1.0`.
  # The value `0.0` is completely transparent and `1.0` is opaque.
  opacity: 0.99
  # opacity: 0.80

  # Window decorations
  #
  # Values for `decorations`:
  #     - full: Borders and title bar
  #     - none: Neither borders nor title bar
  #
  # Values for `decorations` (macOS only):
  #     - transparent: Title bar, transparent background and title bar buttons
  #     - buttonless: Title bar, transparent background, but no title bar buttons
  #decorations: full

  # Startup Mode (changes require restart)
  #
  # Values for `startup_mode`:
  #   - Windowed
  #   - Maximized
  #   - Fullscreen
  #
  # Values for `startup_mode` (macOS only):
  #   - SimpleFullscreen
  #startup_mode: Windowed

  # Window title
  title: Alacritty

  # Window class (Linux/BSD only):
  class:
    # Application instance name
    instance: Alacritty
    # General application class
    general: Alacritty

  # GTK theme variant (Linux/BSD only)
  #
  # Override the variant of the GTK theme. Commonly supported values are `dark` and `light`.
  # Set this to `None` to use the default theme variant.
  #gtk_theme_variant: None

scrolling:
  # Maximum number of lines in the scrollback buffer.
  # Specifying '0' will disable scrolling.
  history: 5000

  # Number of lines the viewport will move for every line scrolled when
  # scrollback is enabled (history > 0).
  #multiplier: 3

  # Scroll to the bottom when new text is written to the terminal.
  #auto_scroll: false

# Spaces per Tab (changes require restart)
#
# This setting defines the width of a tab in cells.
#
# Some applications, like Emacs, rely on knowing about the width of a tab.
# To prevent unexpected behavior in these applications, it's also required to
# change the `it` value in terminfo when altering this setting.
#tabspaces: 8

# Font configuration
font:
  # Normal (roman) font face
  normal:
    # Font family
    #
    # Default:
    #   - (macOS) Menlo
    #   - (Linux/BSD) monospace
    #   - (Windows) Consolas
    # family: monospace
    # family: CodeNewRoman Nerd Font
    # family: RobotoMono Nerd Font
    # family: Hack
    # family: JetBrains Mono
    # family: UbuntuMono Nerd Font
    # family: Monofur Nerd Font
    # family: TerminessTTF Nerd Font
    # family: Mononoki Nerd Font

    # The `style` can be specified to pick a specific face.
    style: Regular

  # Bold font face
  bold:
    # Font family
    #
    # If the bold family is not specified, it will fall back to the
    # value specified for the normal font.
    # family: monospace
    # family: CodeNewRoman Nerd Font
    # family: RobotoMono Nerd Font
    # family: Hack
    # family: JetBrains Mono
    # family: UbuntuMono Nerd Font
    # family: Monofur Nerd Font
    # family: TerminessTTF Nerd Font
    # family: Mononoki Nerd Font

    # The `style` can be specified to pick a specific face.
    style: Bold

  # Italic font face
  italic:
    # Font family
    #
    # If the italic family is not specified, it will fall back to the
    # value specified for the normal font.
    # family: monospace
    # family: CodeNewRoman Nerd Font
    # family: RobotoMono Nerd Font
    # family: Hack
    # family: JetBrains Mono
    # family: UbuntuMono Nerd Font
    # family: Monofuritalic Nerd Font Mono
    # family: TerminessTTF Nerd Font
    family: Mononoki Nerd Font

    # The `style` can be specified to pick a specific face.
    style: Italic

  # Bold italic font face
  bold_italic:
    # Font family
    #
    # If the bold italic family is not specified, it will fall back to the
    # value specified for the normal font.
    family: monospace
    # family: CodeNewRoman Nerd Font
    # family: RobotoMono Nerd Font
    # family: Hack
    # family: JetBrains Mono
    # family: UbuntuMono Nerd Font
    # family: Monofuritalic Nerd Font Mono
    # family: TerminessTTF Nerd Font
    family: Mononoki Nerd Font

    # The `style` can be specified to pick a specific face.
    style: Bold Italic

  # Point size
  size: 8

  # Offset is the extra space around each character. `offset.y` can be thought of
  # as modifying the line spacing, and `offset.x` as modifying the letter spacing.
  offset:
    x: 1
    y: 1

  # Glyph offset determines the locations of the glyphs within their cells with
  # the default being at the bottom. Increasing `x` moves the glyph to the right,
  # increasing `y` moves the glyph upwards.
  #glyph_offset:
    x: 1
    y: 1 

  # Thin stroke font rendering (macOS only)
  #
  # Thin strokes are suitable for retina displays, but for non-retina screens
  # it is recommended to set `use_thin_strokes` to `false`
  #
  # macOS >= 10.14.x:
  #
  # If the font quality on non-retina display looks bad then set
  # `use_thin_strokes` to `true` and enable font smoothing by running the
  # following command:
  #   `defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO`
  #
  # This is a global setting and will require a log out or restart to take
  # effect.
  #use_thin_strokes: true

# If `true`, bold text is drawn using the bright color variants.
draw_bold_text_with_bright_colors: true

#######################################
##      START OF COLOR SCHEMES       ##
#######################################


colors:
  primary:
    background: '#282a36'
    foreground: '#f8f8f2'
    bright_foreground: '#ffffff'
  cursor:
    text: CellBackground
    cursor: CellForeground
  vi_mode_cursor:
    text: CellBackground
    cursor: CellForeground
  search:
    matches:
      foreground: '#44475a'
      background: '#50fa7b'
    focused_match:
      foreground: '#44475a'
      background: '#ffb86c'
  footer_bar:
    background: '#282a36'
    foreground: '#f8f8f2'
  hints:
    start:
      foreground: '#282a36'
      background: '#f1fa8c'
    end:
      foreground: '#f1fa8c'
      background: '#282a36'
  line_indicator:
    foreground: None
    background: None
  selection:
    text: CellForeground
    background: '#44475a'
  normal:
    black: '#21222c'
    red: '#ff5555'
    green: '#50fa7b'
    yellow: '#f1fa8c'
    blue: '#bd93f9'
    magenta: '#ff79c6'
    cyan: '#8be9fd'
    white: '#f8f8f2'
  bright:
    black: '#6272a4'
    red: '#ff6e6e'
    green: '#69ff94'
    yellow: '#ffffa5'
    blue: '#d6acff'
    magenta: '#ff92df'
    cyan: '#a4ffff'
    white: '#ffffff'


#######################################
##       END OF COLOR SCHEMES        ##
#######################################

# Visual Bell
#
# Any time the BEL code is received, Alacritty "rings" the visual bell. Once
# rung, the terminal background will be set to white and transition back to the
# default background color. You can control the rate of this transition by
# setting the `duration` property (represented in milliseconds). You can also
# configure the transition function by setting the `animation` property.
#
# Values for `animation`:
#   - Ease
#   - EaseOut
#   - EaseOutSine
#   - EaseOutQuad
#   - EaseOutCubic
#   - EaseOutQuart
#   - EaseOutQuint
#   - EaseOutExpo
#   - EaseOutCirc
#   - Linear
#
# Specifying a `duration` of `0` will disable the visual bell.
#visual_bell:
#  animation: EaseOutExpo
#  duration: 0
#  color: '#ffffff'

#selection:
  #semantic_escape_chars: ",│`|:\"' ()[]{}<>\t"

  # When set to `true`, selected text will be copied to the primary clipboard.
  #save_to_clipboard: false

# Allow terminal applications to change Alacritty's window title.
#dynamic_title: true

#cursor:
  # Cursor style
  #
  # Values for `style`:
  #   - ▇ Block
  #   - _ Underline
  #   - | Beam
  #style: Block

  # If this is `true`, the cursor will be rendered as a hollow box when the
  # window is not focused.
  #unfocused_hollow: true

# Live config reload (changes require restart)
#live_config_reload: true

# Shell
#
# You can set `shell.program` to the path of your favorite shell, e.g. `/bin/fish`.
# Entries in `shell.args` are passed unmodified as arguments to the shell.
#
# Default:
#   - (macOS) /bin/bash --login
#   - (Linux/BSD) user login shell
#   - (Windows) powershell
#shell:
#  program: /bin/bash
#  args:
#    - --login

# Startup directory
#
# Directory the shell is started in. If this is unset, or `None`, the working
# directory of the parent process will be used.
#working_directory: None

# WinPTY backend (Windows only)
#
# Alacritty defaults to using the newer ConPTY backend if it is available,
# since it resolves a lot of bugs and is quite a bit faster. If it is not
# available, the the WinPTY backend will be used instead.
#
# Setting this option to `true` makes Alacritty use the legacy WinPTY backend,
# even if the ConPTY backend is available.
#winpty_backend: false

# Send ESC (\x1b) before characters when alt is pressed.
#alt_send_esc: true

#debug:
  # Display the time it takes to redraw each frame.
  #render_timer: false

  # Keep the log file after quitting Alacritty.
  #persistent_logging: false

  # Log level
  #
  # Values for `log_level`:
  #   - None
  #   - Error
  #   - Warn
  #   - Info
  #   - Debug
  #   - Trace
  #log_level: Warn

  # Print all received window events.
  #print_events: false

  # Record all characters and escape sequences as test data.
  #ref_test: false

#mouse:
  # Click settings
  #
  # The `double_click` and `triple_click` settings control the time
  # alacritty should wait for accepting multiple clicks as one double
  # or triple click.
  #double_click: { threshold: 300 }
  #triple_click: { threshold: 300 }

  # If this is `true`, the cursor is temporarily hidden when typing.
  #hide_when_typing: false

  #url:
    # URL launcher
    #
    # This program is executed when clicking on a text which is recognized as a URL.
    # The URL is always added to the command as the last parameter.
    #
    # When set to `None`, URL launching will be disabled completely.
    #
    # Default:
    #   - (macOS) open
    #   - (Linux/BSD) xdg-open
    #   - (Windows) explorer
    #launcher:
    #  program: xdg-open
    #  args: []

    # URL modifiers
    #
    # These are the modifiers that need to be held down for opening URLs when clicking
    # on them. The available modifiers are documented in the key binding section.
    #modifiers: None

# Mouse bindings
#
# Mouse bindings are specified as a list of objects, much like the key
# bindings further below.
#
# Each mouse binding will specify a:
#
# - `mouse`:
#
#   - Middle
#   - Left
#   - Right
#   - Numeric identifier such as `5`
#
# - `action` (see key bindings)
#
# And optionally:
#
# - `mods` (see key bindings)
#mouse_bindings:
#  - { mouse: Middle, action: PasteSelection }

# Key bindings
#
# Key bindings are specified as a list of objects. For example, this is the
# default paste binding:
#
# `- { key: V, mods: Control|Shift, action: Paste }`
#
# Each key binding will specify a:
#
# - `key`: Identifier of the key pressed
#
#    - A-Z
#    - F1-F24
#    - Key0-Key9
#
#    A full list with available key codes can be found here:
#    https://docs.rs/glutin/*/glutin/event/enum.VirtualKeyCode.html#variants
#
#    Instead of using the name of the keys, the `key` field also supports using
#    the scancode of the desired key. Scancodes have to be specified as a
#    decimal number. This command will allow you to display the hex scancodes
#    for certain keys:
#
#       `showkey --scancodes`.
#
# Then exactly one of:
#
# - `chars`: Send a byte sequence to the running application
#
#    The `chars` field writes the specified string to the terminal. This makes
#    it possible to pass escape sequences. To find escape codes for bindings
#    like `PageUp` (`"\x1b[5~"`), you can run the command `showkey -a` outside
#    of tmux. Note that applications use terminfo to map escape sequences back
#    to keys. It is therefore required to update the terminfo when changing an
#    escape sequence.
#
# - `action`: Execute a predefined action
#
#   - Copy
#   - Paste
#   - PasteSelection
#   - IncreaseFontSize
#   - DecreaseFontSize
#   - ResetFontSize
#   - ScrollPageUp
#   - ScrollPageDown
#   - ScrollLineUp
#   - ScrollLineDown
#   - ScrollToTop
#   - ScrollToBottom
#   - ClearHistory
#   - Hide
#   - Minimize
#   - Quit
#   - ToggleFullscreen
#   - SpawnNewInstance
#   - ClearLogNotice
#   - ReceiveChar
#   - None
#
#   (macOS only):
#   - ToggleSimpleFullscreen: Enters fullscreen without occupying another space
#
# - `command`: Fork and execute a specified command plus arguments
#
#    The `command` field must be a map containing a `program` string and an
#    `args` array of command line parameter strings. For example:
#       `{ program: "alacritty", args: ["-e", "vttest"] }`
#
# And optionally:
#
# - `mods`: Key modifiers to filter binding actions
#
#    - Command
#    - Control
#    - Option
#    - Super
#    - Shift
#    - Alt
#
#    Multiple `mods` can be combined using `|` like this:
#       `mods: Control|Shift`.
#    Whitespace and capitalization are relevant and must match the example.
#
# - `mode`: Indicate a binding for only specific terminal reported modes
#
#    This is mainly used to send applications the correct escape sequences
#    when in different modes.
#
#    - AppCursor
#    - AppKeypad
#    - Alt
#
#    A `~` operator can be used before a mode to apply the binding whenever
#    the mode is *not* active, e.g. `~Alt`.
#
# Bindings are always filled by default, but will be replaced when a new
# binding with the same triggers is defined. To unset a default binding, it can
# be mapped to the `ReceiveChar` action. Alternatively, you can use `None` for
# a no-op if you do not wish to receive input characters for that binding.
key_bindings:
    # (Windows, Linux, and BSD only)
  - { key: V,         mods: Control|Shift, action: Paste                       }
  - { key: C,         mods: Control|Shift, action: Copy                        }
  - { key: Insert,    mods: Shift,         action: PasteSelection              }
  - { key: Key0,      mods: Control,       action: ResetFontSize               }
  - { key: Equals,    mods: Control,       action: IncreaseFontSize            }
  - { key: Plus,      mods: Control,       action: IncreaseFontSize            }
  - { key: Minus,     mods: Control,       action: DecreaseFontSize            }
  - { key: F11,       mods: None,          action: ToggleFullscreen            }
  - { key: Paste,     mods: None,          action: Paste                       }
  - { key: Copy,      mods: None,          action: Copy                        }
  - { key: L,         mods: Control,       action: ClearLogNotice              }
  - { key: L,         mods: Control,       chars: "\x0c"                       }
  - { key: PageUp,    mods: None,          action: ScrollPageUp,   mode: ~Alt  }
  - { key: PageDown,  mods: None,          action: ScrollPageDown, mode: ~Alt  }
  - { key: Home,      mods: Shift,         action: ScrollToTop,    mode: ~Alt  }
  - { key: End,       mods: Shift,         action: ScrollToBottom, mode: ~Alt  }


    '';
  };

}
