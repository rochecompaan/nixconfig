{ config, pkgs, lib, inputs, ... }:

{
  home.username = "roche";
  home.homeDirectory = "/home/roche";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/share/go/bin"
    "$HOME/.dotnet"
    "$HOME/.dotnet/tools"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/emulator"
    "$HOME/tools/eza/completions/zsh"
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    inputs.nixvim.packages.${pkgs.system}.default

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    dmidecode

    # cloud
    awscli2
    opentofu

    brave
    bat
    clipman
    cliphist
    dig
    discord
    docker
    docker-compose
    dunst
    firefox
    grimblast
    hyprpaper
    hyprcursor
    k9s
    killall
    kitty
    kubectl
    lazygit
    libreoffice-fresh
    openvpn3
    slack
    slurp
    pass
    pavucontrol
    waybar
    wl-clipboard
    wl-clip-persist
    wget
    wofi
    yazi
    zellij
    zoom-us
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Roché Compaan";
    userEmail = "roche@upfrontsoftware.co.za";
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      kubernetes.disabled = false;
      # format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$\{custom.aws\}$kubernetes$python$character";
      directory = {
        read_only = " ";
        style = "bold yellow";
        format = "[ $path ]($style)";
        truncation_length = 0;
        truncation_symbol = "…/";
        fish_style_pwd_dir_length = 10;
      };
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bold purple";
      };
      git_commit = {
        only_detached = true;
        format = "[ﰖ$hash]($style) ";
        style = "bright-yellow bold";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      nix_shell = {
        disabled = false;
        impure_msg = "i";
        format = "via [$symbol$state](bold blue) ";
      };
      python = {
        style = "bright-green";
      };
      aws = {
        format = "on [$symbol($profile )]($style)";
        style = "bold blue";
        symbol = " ";
      };
      custom.aws = {
        command = "echo $AWS_PROFILE";
        detect_files = [ ];
        when = " test \"$AWS_PROFILE\" != \"\" ";
        style = "bold blue";
        format = "on [$symbol($output )]($style)";
        # symbol = "🅰 ";
        symbol = " ";
      };
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history.size = 1000000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    syntaxHighlighting = {
      enable = true;
    };
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "alacritty";
      BROWSER = "brave";
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
      GOPATH = "$HOME/.local/share/go";
      # FPATH = "$HOME/tools/eza/completions/zsh";
    };

    shellAliases = {
      g = "lazygit";
      k = "kubectl";
      ksy = "kubectl -n kube-system";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";

      # Colorize grep output (good for log files)
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";

      # confirm before overwriting something
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";

      # easier to read disk
      df = "df -h"; # human-readable sizes
      free = "free -m"; # show sizes in MB

      # get top process eating memory
      psmem = "ps auxf | sort -nr -k 4 | head -5";

      # get top process eating cpu ##
      pscpu = "ps auxf | sort -nr -k 3 | head -5";

      # gpg encryption
      # verify signature for isos
      gpg-check = "gpg2 --keyserver-options auto-key-retrieve --verify";
      # receive the key of a developer
      gpg-retrieve = "gpg2 --keyserver-options auto-key-retrieve --receive-keys";

      cat = "bat -pp --theme \"Visual Studio Dark+\"";
      catt = "bat --theme \"Visual Studio Dark+\"";
      ls = "exa";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      dotup = "pushd ~/projects/dotfiles/ && git pull && stow -t $HOME --ignore=.xinitrc */ && popd";
      tt = "docker run --rm -v $HOME/projects/timetransfer:/src -it time-transfer today";
      tty = "docker run --rm -v $HOME/projects/timetransfer:/src -it time-transfer yesterday";
      tton = "docker run --rm -v $HOME/projects/timetransfer:/src -it time-transfer on";
      terraform = "tofu";
      tfplan = "tofu plan -out=\"tfplan.out\" && tofu show -no-color tfplan.out >> .terraform/tfplan-$(date +%Y%m%d-%H%M%S).log";
      tfapply = "tofu apply \"tfplan.out\"";
      iplocal = "ip -json route get 8.8.8.8 | jq -r '.[].prefsrc'";

      ssh = "TERM=xterm-256color ssh";

      # show history from first entry
      history = "history 1";

      vpnon = "openvpn3 session-start --config ~/.config/openvpn/sfu.ovpn";
      vpnoff = "openvpn3 session-manage --disconnect --config ~/.config/openvpn/sfu.ovpn";
      vpnstats = "openvpn3 sessions-list";

      myip = "curl -s checkip.amazonaws.com";

      nb = "sudo nixos-rebuild switch --flake .#djangf8sum";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "hlissner/zsh-autopair"; }
        { name = "zap-zsh/vim"; }
        { name = "zap-zsh/zap-prompt"; }
        { name = "zap-zsh/fzf"; }
        { name = "zap-zsh/exa"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
      ];
    };


    initExtra = ''
      PROMPT_EOL_MARK=\'\'
      source <(kubectl completion zsh)
    '';

    # initExtra = ''
    #   setopt completeinword NO_flowcontrol NO_listbeep NO_singlelinezle
    #   autoload -Uz compinit
    #   compinit

    #   # keybinds
    #   bindkey '^ ' autosuggest-accept
    #   bindkey -v
    #   bindkey '^R' history-incremental-search-backward

    #   #compdef toggl
    #   _toggl() {
    #     eval $(env COMMANDLINE="${words[1,$CURRENT]}" _TOGGL_COMPLETE=complete-zsh  toggl)
    #   }
    #   if [[ "$(basename -- ${(%):-%x})" != "_toggl" ]]; then
    #     compdef _toggl toggl
    #   fi
    # ''

  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    # enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.easyeffects.enable = true;
}
