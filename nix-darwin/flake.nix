{
  description = "MacOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            bat
            dust
            eza
            fd
            neovim
            ripgrep
            sd
            tealdeer
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          environment.shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            "~" = "cd ~";
            "-- -" = "cd -";

            "l" = "eza -alh --icons --group-directories-first";
            "ll" = "eza -lh --icons --group-directories-first";
            "v" = "nvim";
          };
          environment.shells = with pkgs; [
            bashInteractive
            zsh
          ];
          environment.variables = {
            LESSHISTFILE = "-";
            VISUAL = "nvim";
            EDITOR = "nvim";
            MANPAGER = "nvim +Man!";
          };
          homebrew.enable = true;
          homebrew.casks = [
            "betterzip"
            "boop"
            "font-jetbrains-mono-nerd-font"
            "iina"
            "keepassxc"
            "kitty"
            "motrix"
            "parallels"
            "surge"
            "utm"
          ];
          homebrew.global.autoUpdate = false;
          homebrew.onActivation.cleanup = "zap";
          networking.computerName = "Mac";
          networking.localHostName = "Mac";
          networking.wakeOnLan.enable = true;
          nix.settings.sandbox = true;
          power.restartAfterFreeze = false;
          power.restartAfterPowerFailure = false;
          power.sleep.allowSleepByPowerButton = true;
          power.sleep.computer = 10;
          power.sleep.display = 10;
          power.sleep.harddisk = 60;
          programs.bash.completion.enable = true;
          programs.direnv.enable = true;
          programs.zsh.enableCompletion = false;
          programs.zsh.promptInit = "";
          security.pam.enableSudoTouchIdAuth = true;
          system.defaults.ActivityMonitor.IconType = 0;
          system.defaults.ActivityMonitor.OpenMainWindow = true;
          system.defaults.ActivityMonitor.ShowCategory = 101;
          system.defaults.ActivityMonitor.SortColumn = "CPUUsage";
          system.defaults.ActivityMonitor.SortDirection = 0;
          system.defaults.LaunchServices.LSQuarantine = true;
          system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = false;
          system.defaults.NSGlobalDomain."com.apple.sound.beep.feedback" = 1;
          system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 1.0;
          system.defaults.NSGlobalDomain."com.apple.springing.delay" = 1.0;
          system.defaults.NSGlobalDomain."com.apple.springing.enabled" = true;
          system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = true;
          system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
          system.defaults.NSGlobalDomain."com.apple.trackpad.forceClick" = true;
          system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
          system.defaults.NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
          system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
          system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;
          system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
          system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
          system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = true;
          system.defaults.NSGlobalDomain.AppleScrollerPagingBehavior = true;
          system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
          system.defaults.NSGlobalDomain.AppleShowAllFiles = false;
          system.defaults.NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
          system.defaults.NSGlobalDomain.AppleSpacesSwitchOnActivate = true;
          system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
          system.defaults.NSGlobalDomain.KeyRepeat = 6;
          system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = true;
          system.defaults.NSGlobalDomain.NSDisableAutomaticTermination = true;
          system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
          system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
          system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
          system.defaults.NSGlobalDomain.NSScrollAnimationEnabled = true;
          system.defaults.NSGlobalDomain.NSTableViewDefaultSizeMode = 3;
          system.defaults.NSGlobalDomain.NSTextShowsControlCharacters = false;
          system.defaults.NSGlobalDomain.NSUseAnimatedFocusRing = true;
          system.defaults.NSGlobalDomain.NSWindowResizeTime = 0.2;
          system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;
          system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = false;
          system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = false;
          system.defaults.NSGlobalDomain._HIHideMenuBar = false;
          system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
          system.defaults.WindowManager.AppWindowGroupingBehavior = false;
          system.defaults.WindowManager.AutoHide = false;
          system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
          system.defaults.WindowManager.EnableTiledWindowMargins = true;
          system.defaults.WindowManager.GloballyEnabled = true;
          system.defaults.WindowManager.HideDesktop = false;
          system.defaults.WindowManager.StageManagerHideWidgets = false;
          system.defaults.WindowManager.StandardHideDesktopIcons = false;
          system.defaults.WindowManager.StandardHideWidgets = false;
          system.defaults.alf.allowdownloadsignedenabled = 0;
          system.defaults.alf.allowsignedenabled = 0;
          system.defaults.alf.globalstate = 1;
          system.defaults.alf.loggingenabled = 0;
          system.defaults.alf.stealthenabled = 1;
          system.defaults.controlcenter.AirDrop = false;
          system.defaults.controlcenter.BatteryShowPercentage = false;
          system.defaults.controlcenter.Bluetooth = false;
          system.defaults.controlcenter.Display = false;
          system.defaults.controlcenter.FocusModes = false;
          system.defaults.controlcenter.NowPlaying = true;
          system.defaults.controlcenter.Sound = true;
          system.defaults.dock.appswitcher-all-displays = false;
          system.defaults.dock.autohide = true;
          system.defaults.dock.autohide-delay = 0.24;
          system.defaults.dock.autohide-time-modifier = 1.0;
          system.defaults.dock.dashboard-in-overlay = false;
          system.defaults.dock.enable-spring-load-actions-on-all-items = true;
          system.defaults.dock.expose-animation-duration = 1.0;
          system.defaults.dock.expose-group-apps = true;
          system.defaults.dock.largesize = 52;
          system.defaults.dock.launchanim = true;
          system.defaults.dock.magnification = false;
          system.defaults.dock.mineffect = "genie";
          system.defaults.dock.minimize-to-application = true;
          system.defaults.dock.mouse-over-hilite-stack = true;
          system.defaults.dock.mru-spaces = false;
          system.defaults.dock.orientation = "bottom";
          system.defaults.dock.persistent-apps = [
            "/System/Applications/App Store.app"
            "/System/Applications/Launchpad.app"
            "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
            "/Applications/kitty.app"
            "/Applications/Parallels Desktop.app"
            "/System/Applications/System Settings.app"
          ];
          system.defaults.dock.persistent-others = [
            "/Users/b1n/Downloads"
          ];
          system.defaults.dock.scroll-to-open = false;
          system.defaults.dock.show-process-indicators = true;
          system.defaults.dock.show-recents = false;
          system.defaults.dock.showhidden = true;
          system.defaults.dock.slow-motion-allowed = false;
          system.defaults.dock.static-only = false;
          system.defaults.dock.tilesize = 64;
          system.defaults.dock.wvous-bl-corner = 1;
          system.defaults.dock.wvous-br-corner = 1;
          system.defaults.dock.wvous-tl-corner = 1;
          system.defaults.dock.wvous-tr-corner = 1;
          system.defaults.finder.AppleShowAllExtensions = true;
          system.defaults.finder.AppleShowAllFiles = false;
          system.defaults.finder.CreateDesktop = true;
          system.defaults.finder.FXEnableExtensionChangeWarning = false;
          system.defaults.finder.FXPreferredViewStyle = "clmv";
          system.defaults.finder.FXRemoveOldTrashItems = true;
          system.defaults.finder.NewWindowTarget = "Home";
          system.defaults.finder.QuitMenuItem = false;
          system.defaults.finder.ShowExternalHardDrivesOnDesktop = true;
          system.defaults.finder.ShowHardDrivesOnDesktop = false;
          system.defaults.finder.ShowMountedServersOnDesktop = true;
          system.defaults.finder.ShowPathbar = true;
          system.defaults.finder.ShowRemovableMediaOnDesktop = true;
          system.defaults.finder.ShowStatusBar = true;
          system.defaults.finder._FXShowPosixPathInTitle = true;
          system.defaults.finder._FXSortFoldersFirst = true;
          system.defaults.finder._FXSortFoldersFirstOnDesktop = false;
          system.defaults.hitoolbox.AppleFnUsageType = "Change Input Source";
          system.defaults.loginwindow.DisableConsoleAccess = true;
          system.defaults.loginwindow.GuestEnabled = false;
          system.defaults.loginwindow.LoginwindowText = "Authorized use only. All activities are monitored.";
          system.defaults.loginwindow.PowerOffDisabledWhileLoggedIn = false;
          system.defaults.loginwindow.RestartDisabled = false;
          system.defaults.loginwindow.RestartDisabledWhileLoggedIn = false;
          system.defaults.loginwindow.SHOWFULLNAME = true;
          system.defaults.loginwindow.ShutDownDisabled = false;
          system.defaults.loginwindow.ShutDownDisabledWhileLoggedIn = false;
          system.defaults.loginwindow.SleepDisabled = false;
          system.defaults.magicmouse.MouseButtonMode = "OneButton";
          system.defaults.menuExtraClock.FlashDateSeparators = false;
          system.defaults.menuExtraClock.IsAnalog = false;
          system.defaults.menuExtraClock.Show24Hour = true;
          system.defaults.menuExtraClock.ShowAMPM = false;
          system.defaults.menuExtraClock.ShowDate = 2;
          system.defaults.menuExtraClock.ShowDayOfMonth = false;
          system.defaults.menuExtraClock.ShowDayOfWeek = false;
          system.defaults.menuExtraClock.ShowSeconds = false;
          system.defaults.screencapture.disable-shadow = true;
          system.defaults.screencapture.include-date = true;
          system.defaults.screencapture.show-thumbnail = true;
          system.defaults.screensaver.askForPassword = true;
          system.defaults.screensaver.askForPasswordDelay = 0;
          system.defaults.spaces.spans-displays = false;
          system.defaults.trackpad.ActuationStrength = 1;
          system.defaults.trackpad.Clicking = false;
          system.defaults.trackpad.Dragging = true;
          system.defaults.trackpad.FirstClickThreshold = 0;
          system.defaults.trackpad.SecondClickThreshold = 1;
          system.defaults.trackpad.TrackpadRightClick = true;
          system.defaults.trackpad.TrackpadThreeFingerDrag = true;
          system.defaults.trackpad.TrackpadThreeFingerTapGesture = 0;
          system.defaults.universalaccess.closeViewScrollWheelToggle = false;
          system.defaults.universalaccess.closeViewZoomFollowsFocus = false;
          system.defaults.universalaccess.mouseDriverCursorSize = 1.0;
          system.defaults.universalaccess.reduceMotion = false;
          system.defaults.universalaccess.reduceTransparency = false;
          system.keyboard.enableKeyMapping = true;
          system.keyboard.nonUS.remapTilde = false;
          system.keyboard.remapCapsLockToControl = false;
          system.keyboard.remapCapsLockToEscape = true;
          system.keyboard.swapLeftCommandAndLeftAlt = false;
          system.keyboard.swapLeftCtrlAndFn = false;
          system.startup.chime = false;
          time.timeZone = "Asia/Shanghai";
          users.users.b1n.packages = with pkgs; [
            cargo-nextest
            cscope
            delta
            entr
            fastfetch
            gnumake
            gnupg
            hexyl
            neomutt
            nixd
            nixfmt-rfc-style
            onefetch
            rustup
            starship
            tokei
            universal-ctags
            xh
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Mac
      darwinConfigurations."Mac" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
