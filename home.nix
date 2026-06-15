{
  pkgs,
  inputs,
  ...
}:

let
  cursorTheme = builtins.fetchGit {
    url = "https://gitlab.com/Pummelfisch/future-cyan-hyprcursor.git";
    ref = "main";
    rev = "44282bb5fe218b14f44af42368ef3c9ad439d646";
  };
in
{
  home.username = "chucky";
  home.homeDirectory = "/home/chucky";

  imports = [
    inputs.noctalia.homeModules.default
    ./modules/hyprland-noctalia.nix
  ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    #Tools for system, Neovim Compiling, etc
    gcc
    clang-tools
    gnumake
    unzip
    # LSPs and Linters
    nil
    statix
    nixfmt
    # Other
    brave
    kitty
    nerd-fonts.jetbrains-mono
    git
    curl
    ripgrep
    fd
    tree-sitter
    wget
    vscodium
    jq
    hyperfine # For benchmarking shell
    neovim
    zsh-fzf-tab
    fastfetch
    firefox
    vesktop
    pavucontrol
    tmux

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   orj.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/chucky/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
    NIXOS_OZONE_WL = "1";
  };

  home.pointerCursor = {
    enable = true;
    name = "Future-Cyan-Hyprcursor_Theme";
    package = pkgs.runCommand "cursor" { } ''
      mkdir -p $out/share/icons
      cp -r ${cursorTheme}/Future-Cyan-Hyprcursor_Theme/ $out/share/icons/
    '';
    hyprcursor.enable = true;
    hyprcursor.size = 35;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.flameshot = {
    enable = true;
    settings = {
      general = {
        useGrimAdapter = true;
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    presets = [
      "pure-preset"
    ];

  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    settings = {
      theme = "noctalia";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };

    initContent = ''
      bindkey -v
      bindkey "^ " autosuggest-accept
      export KEYTIMEOUT=1

      setopt glob_dots
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };
}
