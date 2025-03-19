{ config, lib, pkgs, ... }:

let

in {

  system.defaults = {

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      dashboard-in-overlay = true;
      enable-spring-load-actions-on-all-items = true;
      expose-animation-duration = 0.25;
      expose-group-apps = false;
      launchanim = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = true;
      mru-spaces = false;
      orientation = "left";
      show-process-indicators = true;
      showhidden = true;
      show-recents = false;
      static-only = false;
      tilesize = 36;
      wvous-bl-corner = 2;

      apps = {
        enable = true;
        entries = [
          { path = "/Applications/iTerm.app/"; }
          { path = "/Applications/TIDAL.app/"; }
          {
            path = "${config.home.homeDirectory}/Downloads";
            section = "others";
            options = "--sort dateadded --view grid --display stack";
          }
        ];
      };
    };

    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
      NewWindowTarget = "Documents";
      ShowStatusBar = true;

      _FXShowPosixPathInTitle = false;
      _FXSortFoldersFirst = true;
    };

    loginwindow = {
      ShutDownDisabledWhileLoggedIn = true;
      PowerOffDisabledWhileLoggedIn = true;
      RestartDisabledWhileLoggedIn = true;
    };

    NSGlobalDomain = {
      AppleFontSmoothing = 0;
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      NSTextShowsControlCharacters = true;
      NSUseAnimatedFocusRing = false;
      NSScrollAnimationEnabled = true;
      NSWindowResizeTime = 0.001;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      "com.apple.mouse.tapBehavior" = null;
      "com.apple.trackpad.enableSecondaryClick" = false;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.0;
      "com.apple.swipescrolldirection" = true;
    };

    trackpad = {
      Clicking = false;
      Dragging = false;
      TrackpadRightClick = false;
      TrackpadThreeFingerDrag = false;
    };

  };

}
