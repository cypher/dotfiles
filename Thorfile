require 'fileutils'

class Dotfiles < Thor
  include Thor::Actions
  Thor::Sandbox::Dotfiles.source_root(File.expand_path('..', __FILE__))

  IGNORED_ENTRIES = %w{install.sh Rakefile Thorfile README.md LICENSE bin etc example git-hooks postgresql LaunchBar LaunchAgents Brewfile Misc}

  desc "install_dotfiles", "Installs all dotfiles"
  method_options verbose: true
  def install_dotfiles
    Dir['*'].each do |file|
      if IGNORED_ENTRIES.include?(file)
        say("Ignoring `#{file}'", :red) if options[:verbose]
        next
      end

      link_target = File.join(Thor::Util.user_home, ".#{file}")
      link_source = File.join(basedir, file)

      link_file(link_source, link_target, verbose: options[:verbose])
    end
  end

  desc "install_bin", "Installs all bin scripts and commands"
  method_options verbose: true
  def install_bin
    bindir = File.join(Thor::Util.user_home, 'bin')
    bin_basedir = File.join(basedir, 'bin')

    FileUtils.mkdir(bindir, :verbose => true, :mode => 0700) unless File.exists?(bindir) and File.directory?(bindir)

    Dir[File.join(bin_basedir, '*')].each do |entry|
      basename = File.basename(entry)

      link_target = File.join(bindir, basename)
      link_source = File.join(bin_basedir, basename)

      link_file(link_source, link_target, verbose: options[:verbose])

      if basename == 'git-up'
        link_file(File.join(bindir, 'git-up'), File.join(bindir, 'git-reup'), verbose: options[:verbose])
      end
    end
  end

  desc "install", "Installs all dotfiles and bin scripts/commands"
  method_options verbose: true
  def install
    invoke "install_dotfiles", verbose: options[:verbose]
    invoke "install_bin", verbose: options[:verbose]
  end

  desc "update", "Update all submodules, e.g. for Vim bundles"
  method_options verbose: true
  def update
    run("git submodule foreach git checkout master", verbose: options[:verbose])
    run("git submodule foreach git up", verbose: options[:verbose])
  end

  default_task :update

  no_commands do
    def basedir
      File.expand_path('..', __FILE__)
    end
  end

  desc 'configure_macos', 'Configures macOS-specific settings'
  def configure_macos
    # Apple Mail
    run('defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes')

    # Always open everything in Finder's list view. This is important.
    run('defaults write com.apple.Finder FXPreferredViewStyle Nlsv')

    # Show the ~/Library folder.
    run('chflags nohidden ~/Library')

    # Set the Finder prefs for showing a few different volumes on the Desktop.
    run('defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true')
    run('defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true')

    # Destroy File Vault Key when going to standby mode
    run('sudo pmset -a destroyfvkeyonstandby 1')
    # Turn off powernap
    run('sudo pmset -a powernap 0')

    # Set up Safari for development.
    # run('defaults write com.apple.Safari IncludeInternalDebugMenu -bool true')
    # run('defaults write com.apple.Safari IncludeDevelopMenu -bool true')
    # run('defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true')
    # run('defaults write com.apple.Safari 'com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled' -bool true')
    # run('defaults write NSGlobalDomain WebKitDeveloperExtras -bool true')

    # Show the full path in the Finder's title
    # run('defaults write com.apple.finder _FXShowPosixPathInTitle -bool true')

    # All of the following were nabbed from github.com/mathiasbynens/dotfiles/

    # Set computer name (as done via System Preferences → Sharing)
    # run('sudo scutil --set ComputerName "0x6D746873"')
    # run('sudo scutil --set HostName "0x6D746873"')
    # run('sudo scutil --set LocalHostName "0x6D746873"')
    # run('sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"')

    # Set standby delay to 24 hours (default is 1 hour)
    # run('sudo pmset -a standbydelay 86400')

    # Disable the sound effects on boot
    # run('sudo nvram SystemAudioVolume=" "')

    # Disable transparency in the menu bar and elsewhere on Yosemite
    # run('defaults write com.apple.universalaccess reduceTransparency -bool true')

    # Set highlight color to green
    # run('defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"')

    # Set sidebar icon size to medium
    # run('defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2')

    # Always show scrollbars
    # run('defaults write NSGlobalDomain AppleShowScrollBars -string "Always"')
    # Possible values: `WhenScrolling`, `Automatic` and `Always`

    # Disable the over-the-top focus ring animation
    # run('defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false')

    # Increase window resize speed for Cocoa applications
    # run('defaults write NSGlobalDomain NSWindowResizeTime -float 0.001')

    # Expand save panel by default
    # run('defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true')
    # run('defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true')

    # Expand print panel by default
    # run('defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true')
    # run('defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true')

    # Save to disk (not to iCloud) by default
    # run('defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false')

    # Automatically quit printer app once the print jobs complete
    # run('defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true')

    # Disable the “Are you sure you want to open this application?” dialog
    # run('defaults write com.apple.LaunchServices LSQuarantine -bool false')

    # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
    # run('/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user')

    # Display ASCII control characters using caret notation in standard text views
    # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
    # run('defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true')

    # Disable Resume system-wide
    # run('defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false')

    # Disable automatic termination of inactive apps
    # run('defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true')

    # Disable the crash reporter
    # run('defaults write com.apple.CrashReporter DialogType -string "none"')

    # Set Help Viewer windows to non-floating mode
    # run('defaults write com.apple.helpviewer DevMode -bool true')

    # Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
    # Commented out, as this is known to cause problems in various Adobe apps :(
    # See https://github.com/mathiasbynens/dotfiles/issues/237
    # run('echo "0x08000100:0" > ~/.CFUserTextEncoding')

    # Reveal IP address, hostname, OS version, etc. when clicking the clock
    # in the login window
    # run('sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName')

    # Restart automatically if the computer freezes
    # run('sudo systemsetup -setrestartfreeze on')

    # Never go into computer sleep mode
    # run('sudo systemsetup -setcomputersleep Off > /dev/null')

    # Disable Notification Center and remove the menu bar icon
    # run('launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null')

    # Disable automatic capitalization as it’s annoying when typing code
    # run('defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false')

    # Disable smart dashes as they’re annoying when typing code
    # run('defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false')

    # Disable automatic period substitution as it’s annoying when typing code
    # run('defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false')

    # Disable smart quotes as they’re annoying when typing code
    # run('defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false')

    # Disable auto-correct
    # run('defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false')

    ###############################################################################
    # SSD-specific tweaks                                                         #
    ###############################################################################

    # Disable hibernation (speeds up entering sleep mode)
    # run('sudo pmset -a hibernatemode 0')

    # Remove the sleep image file to save disk space
    # run('sudo rm /private/var/vm/sleepimage')
    # Create a zero-byte file instead…
    # run('sudo touch /private/var/vm/sleepimage')
    # …and make sure it can’t be rewritten
    # run('sudo chflags uchg /private/var/vm/sleepimage')

    ###############################################################################
    # Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
    ###############################################################################

    # Trackpad: enable tap to click for this user and for the login screen
    # run('defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true')
    # run('defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1')
    # run('defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1')

    # Trackpad: map bottom right corner to right-click
    # run('defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2')
    # run('defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true')
    # run('defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1')
    # run('defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true')

    # Disable “natural” (Lion-style) scrolling
    # run('defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false')

    # Increase sound quality for Bluetooth headphones/headsets
    # run('defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40')

    # Enable full keyboard access for all controls
    # (e.g. enable Tab in modal dialogs)
    # run('defaults write NSGlobalDomain AppleKeyboardUIMode -int 3')

    # Use scroll gesture with the Ctrl (^) modifier key to zoom
    # run('defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true')
    # run('defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144')
    # Follow the keyboard focus while zoomed in
    # run('defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true')

    # Disable press-and-hold for keys in favor of key repeat
    # run('defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false')

    # Set a blazingly fast keyboard repeat rate
    # run('defaults write NSGlobalDomain KeyRepeat -int 1')
    # run('defaults write NSGlobalDomain InitialKeyRepeat -int 10')

    # run('defaults write NSGlobalDomain AppleLanguages -array "en" "de"')
    # run('defaults write NSGlobalDomain AppleLocale -string "de_AT@currency=EUR"')
    # run('defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"')
    # run('defaults write NSGlobalDomain AppleMetricUnits -bool true')

    # Show language menu in the top right corner of the boot screen
    # run('sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true')

    # Set the timezone; see `sudo systemsetup -listtimezones` for other values
    # run('sudo systemsetup -settimezone "Europe/Vienna" > /dev/null')

    # Stop iTunes from responding to the keyboard media keys
    # run('launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null')

    ###############################################################################
    # Screen                                                                      #
    ###############################################################################

    # Require password immediately after sleep or screen saver begins
    # run('defaults write com.apple.screensaver askForPassword -int 1')
    # run('defaults write com.apple.screensaver askForPasswordDelay -int 0')

    # Save screenshots to the desktop
    # run('defaults write com.apple.screencapture location -string "${HOME}/Desktop"')

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    # run('defaults write com.apple.screencapture type -string "png"')

    # Disable shadow in screenshots
    # run('defaults write com.apple.screencapture disable-shadow -bool true')

    # Enable subpixel font rendering on non-Apple LCDs
    # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
    # run('defaults write NSGlobalDomain AppleFontSmoothing -int 1')

    # Enable HiDPI display modes (requires restart)
    # run('sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true')

    ###############################################################################
    # Finder                                                                      #
    ###############################################################################

    # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
    # run('defaults write com.apple.finder QuitMenuItem -bool true')

    # Finder: disable window animations and Get Info animations
    # run('defaults write com.apple.finder DisableAllAnimations -bool true')

    # Set Desktop as the default location for new Finder windows
    # For other paths, use `PfLo` and `file:///full/path/here/`
    # run('defaults write com.apple.finder NewWindowTarget -string "PfDe"')
    # run('defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"')

    # Show icons for hard drives, servers, and removable media on the desktop
    # run('defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true')
    # run('defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true')
    # run('defaults write com.apple.finder ShowMountedServersOnDesktop -bool true')
    # run('defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true')

    # Finder: show hidden files by default
    # run('defaults write com.apple.finder AppleShowAllFiles -bool true')

    # Finder: show all filename extensions
    # run('defaults write NSGlobalDomain AppleShowAllExtensions -bool true')

    # Finder: show status bar
    # run('defaults write com.apple.finder ShowStatusBar -bool true')

    # Finder: show path bar
    # run('defaults write com.apple.finder ShowPathbar -bool true')

    # Display full POSIX path as Finder window title
    # run('defaults write com.apple.finder _FXShowPosixPathInTitle -bool true')

    # Keep folders on top when sorting by name
    # run('defaults write com.apple.finder _FXSortFoldersFirst -bool true')

    # When performing a search, search the current folder by default
    # run('defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"')

    # Disable the warning when changing a file extension
    # run('defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false')

    # Enable spring loading for directories
    # run('defaults write NSGlobalDomain com.apple.springing.enabled -bool true')

    # Remove the spring loading delay for directories
    # run('defaults write NSGlobalDomain com.apple.springing.delay -float 0')

    # Avoid creating .DS_Store files on network or USB volumes
    # run('defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true')
    # run('defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true')

    # Disable disk image verification
    # run('defaults write com.apple.frameworks.diskimages skip-verify -bool true')
    # run('defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true')
    # run('defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true')

    # Automatically open a new Finder window when a volume is mounted
    # run('defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true')
    # run('defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true')
    # run('defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true')

    # Show item info near icons on the desktop and in other icon views
    # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

    # Show item info to the right of the icons on the desktop
    # /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

    # Enable snap-to-grid for icons on the desktop and in other icon views
    # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

    # Increase grid spacing for icons on the desktop and in other icon views
    # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

    # Increase the size of icons on the desktop and in other icon views
    # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
    # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    # run('defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"')

    # Disable the warning before emptying the Trash
    # run('defaults write com.apple.finder WarnOnEmptyTrash -bool false')

    # Enable AirDrop over Ethernet and on unsupported Macs running Lion
    # run('defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true')

    # Show the ~/Library folder
    # chflags nohidden ~/Library

    # Show the /Volumes folder
    # run('sudo chflags nohidden /Volumes')

    # Remove Dropbox’s green checkmark icons in Finder
    # file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
    # [ -e "${file}" ] && mv -f "${file}" "${file}.bak"

    # Expand the following File Info panes:
    # “General”, “Open with”, and “Sharing & Permissions”
    # run('defaults write com.apple.finder FXInfoPanesExpanded -dict \')
    #   General -bool true \
    #   OpenWith -bool true \
    #   Privileges -bool true

    ###############################################################################
    # Dock, Dashboard, and hot corners                                            #
    ###############################################################################

    # Enable highlight hover effect for the grid view of a stack (Dock)
    # run('defaults write com.apple.dock mouse-over-hilite-stack -bool true')

    # Set the icon size of Dock items to 36 pixels
    # run('defaults write com.apple.dock tilesize -int 36')

    # Change minimize/maximize window effect
    # run('defaults write com.apple.dock mineffect -string "scale"')

    # Minimize windows into their application’s icon
    # run('defaults write com.apple.dock minimize-to-application -bool true')

    # Enable spring loading for all Dock items
    # run('defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true')

    # Show indicator lights for open applications in the Dock
    # run('defaults write com.apple.dock show-process-indicators -bool true')

    # Wipe all (default) app icons from the Dock
    # This is only really useful when setting up a new Mac, or if you don’t use
    # the Dock to launch apps.
    # run('defaults write com.apple.dock persistent-apps -array')

    # Show only open applications in the Dock
    # run('defaults write com.apple.dock static-only -bool true')

    # Don’t animate opening applications from the Dock
    # run('defaults write com.apple.dock launchanim -bool false')

    # Speed up Mission Control animations
    # run('defaults write com.apple.dock expose-animation-duration -float 0.1')

    # Don’t group windows by application in Mission Control
    # (i.e. use the old Exposé behavior instead)
    # run('defaults write com.apple.dock expose-group-by-app -bool false')

    # Disable Dashboard
    # run('defaults write com.apple.dashboard mcx-disabled -bool true')

    # Don’t show Dashboard as a Space
    # run('defaults write com.apple.dock dashboard-in-overlay -bool true')

    # Don’t automatically rearrange Spaces based on most recent use
    # run('defaults write com.apple.dock mru-spaces -bool false')

    # Remove the auto-hiding Dock delay
    # run('defaults write com.apple.dock autohide-delay -float 0')
    # Remove the animation when hiding/showing the Dock
    # run('defaults write com.apple.dock autohide-time-modifier -float 0')

    # Automatically hide and show the Dock
    # run('defaults write com.apple.dock autohide -bool true')

    # Make Dock icons of hidden applications translucent
    # run('defaults write com.apple.dock showhidden -bool true')

    # Disable the Launchpad gesture (pinch with thumb and three fingers)
    # run('defaults write com.apple.dock showLaunchpadGestureEnabled -int 0')

    # Reset Launchpad, but keep the desktop wallpaper intact
    # find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

    # Add iOS & Watch Simulator to Launchpad
    # run('sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"')
    # run('sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"')

    # Add a spacer to the left side of the Dock (where the applications are)
    # run('defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'')
    # Add a spacer to the right side of the Dock (where the Trash is)
    # run('defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'')

    # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # Top left screen corner → Mission Control
    # run('defaults write com.apple.dock wvous-tl-corner -int 2')
    # run('defaults write com.apple.dock wvous-tl-modifier -int 0')
    # Top right screen corner → Desktop
    # run('defaults write com.apple.dock wvous-tr-corner -int 4')
    # run('defaults write com.apple.dock wvous-tr-modifier -int 0')
    # Bottom left screen corner → Start screen saver
    # run('defaults write com.apple.dock wvous-bl-corner -int 5')
    # run('defaults write com.apple.dock wvous-bl-modifier -int 0')

    ###############################################################################
    # Safari & WebKit                                                             #
    ###############################################################################

    # Privacy: don’t send search queries to Apple
    # run('defaults write com.apple.Safari UniversalSearchEnabled -bool false')
    # run('defaults write com.apple.Safari SuppressSearchSuggestions -bool true')

    # Press Tab to highlight each item on a web page
    # run('defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true')
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true')

    # Show the full URL in the address bar (note: this still hides the scheme)
    # run('defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true')

    # Set Safari’s home page to `about:blank` for faster loading
    # run('defaults write com.apple.Safari HomePage -string "about:blank"')

    # Prevent Safari from opening ‘safe’ files automatically after downloading
    # run('defaults write com.apple.Safari AutoOpenSafeDownloads -bool false')

    # Allow hitting the Backspace key to go to the previous page in history
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true')

    # Hide Safari’s bookmarks bar by default
    # run('defaults write com.apple.Safari ShowFavoritesBar -bool false')

    # Hide Safari’s sidebar in Top Sites
    # run('defaults write com.apple.Safari ShowSidebarInTopSites -bool false')

    # Disable Safari’s thumbnail cache for History and Top Sites
    # run('defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2')

    # Enable Safari’s debug menu
    # run('defaults write com.apple.Safari IncludeInternalDebugMenu -bool true')

    # Make Safari’s search banners default to Contains instead of Starts With
    # run('defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false')

    # Remove useless icons from Safari’s bookmarks bar
    # run('defaults write com.apple.Safari ProxiesInBookmarksBar "()"')

    # Enable the Develop menu and the Web Inspector in Safari
    # run('defaults write com.apple.Safari IncludeDevelopMenu -bool true')
    # run('defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true')
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true')

    # Add a context menu item for showing the Web Inspector in web views
    # run('defaults write NSGlobalDomain WebKitDeveloperExtras -bool true')

    # Enable continuous spellchecking
    # run('defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true')
    # Disable auto-correct
    # run('defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false')

    # Disable AutoFill
    # run('defaults write com.apple.Safari AutoFillFromAddressBook -bool false')
    # run('defaults write com.apple.Safari AutoFillPasswords -bool false')
    # run('defaults write com.apple.Safari AutoFillCreditCardData -bool false')
    # run('defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false')

    # Warn about fraudulent websites
    # run('defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true')

    # Disable plug-ins
    # run('defaults write com.apple.Safari WebKitPluginsEnabled -bool false')
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false')

    # Disable Java
    # run('defaults write com.apple.Safari WebKitJavaEnabled -bool false')
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false')

    # Block pop-up windows
    # run('defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false')
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false')

    # Disable auto-playing video
    # run('defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false')
    # run('defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false')
    # run('defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false')
    # run('defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false')

    # Enable “Do Not Track”
    # run('defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true')

    # Update extensions automatically
    # run('defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true')

    ###############################################################################
    # Mail                                                                        #
    ###############################################################################

    # Disable send and reply animations in Mail.app
    # run('defaults write com.apple.mail DisableReplyAnimations -bool true')
    # run('defaults write com.apple.mail DisableSendAnimations -bool true')

    # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
    # run('defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false')

    # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
    # run('defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"')

    # Display emails in threaded mode, sorted by date (oldest at the top)
    # run('defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"')
    # run('defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"')
    # run('defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"')

    # Disable inline attachments (just show the icons)
    # run('defaults write com.apple.mail DisableInlineAttachmentViewing -bool true')

    # Disable automatic spell checking
    # run('defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"')

    ###############################################################################
    # Terminal                                                                    #
    ###############################################################################

    # Only use UTF-8 in Terminal.app
    # run('defaults write com.apple.terminal StringEncodings -array 4')

    ###############################################################################
    # Time Machine                                                                #
    ###############################################################################

    # Prevent Time Machine from prompting to use new hard drives as backup volume
    # run('defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true')

    # Disable local Time Machine backups
    # hash tmutil &> /dev/null && sudo tmutil disablelocal

    ###############################################################################
    # Activity Monitor                                                            #
    ###############################################################################

    # Show the main window when launching Activity Monitor
    # run('defaults write com.apple.ActivityMonitor OpenMainWindow -bool true')

    # Visualize CPU usage in the Activity Monitor Dock icon
    # run('defaults write com.apple.ActivityMonitor IconType -int 5')

    # Show all processes in Activity Monitor
    # run('defaults write com.apple.ActivityMonitor ShowCategory -int 0')

    # Sort Activity Monitor results by CPU usage
    # run('defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"')
    # run('defaults write com.apple.ActivityMonitor SortDirection -int 0')

    ###############################################################################
    # Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
    ###############################################################################

    # Enable the debug menu in Address Book
    # run('defaults write com.apple.addressbook ABShowDebugMenu -bool true')

    # Enable the debug menu in Disk Utility
    # run('defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true')
    # run('defaults write com.apple.DiskUtility advanced-image-options -bool true')

    ###############################################################################
    # Mac App Store                                                               #
    ###############################################################################

    # Enable the WebKit Developer Tools in the Mac App Store
    # run('defaults write com.apple.appstore WebKitDeveloperExtras -bool true')

    # Enable Debug Menu in the Mac App Store
    # run('defaults write com.apple.appstore ShowDebugMenu -bool true')

    # Enable the automatic update check
    # run('defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true')

    # Check for software updates daily, not just once per week
    # run('defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1')

    # Download newly available updates in background
    # run('defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1')

    # Install System data files & security updates
    # run('defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1')

    # Automatically download apps purchased on other Macs
    # run('defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1')

    # Turn on app auto-update
    # run('defaults write com.apple.commerce AutoUpdate -bool true')

    # Allow the App Store to reboot machine on macOS updates
    # run('defaults write com.apple.commerce AutoUpdateRestartRequired -bool true')

    ###############################################################################
    # Photos                                                                      #
    ###############################################################################

    # Prevent Photos from opening automatically when devices are plugged in
    # run('defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true')

    ###############################################################################
    # Google Chrome & Google Chrome Canary                                        #
    ###############################################################################

    # Disable the all too sensitive backswipe on trackpads
    # run('defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false')
    # run('defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false')

    # Disable the all too sensitive backswipe on Magic Mouse
    # run('defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false')
    # run('defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false')

    # Use the system-native print preview dialog
    # run('defaults write com.google.Chrome DisablePrintPreview -bool true')
    # run('defaults write com.google.Chrome.canary DisablePrintPreview -bool true')

    # Expand the print dialog by default
    # run('defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true')
    # run('defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true')

    ###############################################################################
    # GPGMail 2                                                                   #
    ###############################################################################

    # Disable signing emails by default
    # run('defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false')

    ###############################################################################
    # Transmission.app                                                            #
    ###############################################################################

    # Use `~/Documents/Torrents` to store incomplete downloads
    # run('defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true')
    # run('defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"')

    # Use `~/Downloads` to store completed downloads
    # run('defaults write org.m0k.transmission DownloadLocationConstant -bool true')

    # Don’t prompt for confirmation before downloading
    # run('defaults write org.m0k.transmission DownloadAsk -bool false')
    # run('defaults write org.m0k.transmission MagnetOpenAsk -bool false')

    # Don’t prompt for confirmation before removing non-downloading active transfers
    # run('defaults write org.m0k.transmission CheckRemoveDownloading -bool true')

    # Trash original torrent files
    # run('defaults write org.m0k.transmission DeleteOriginalTorrent -bool true')

    # Hide the donate message
    # run('defaults write org.m0k.transmission WarningDonate -bool false')
    # Hide the legal disclaimer
    # run('defaults write org.m0k.transmission WarningLegal -bool false')

    # IP block list.
    # Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
    # run('defaults write org.m0k.transmission BlocklistNew -bool true')
    # run('defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"')
    # run('defaults write org.m0k.transmission BlocklistAutoUpdate -bool true')

    # Randomize port on launch
    # run('defaults write org.m0k.transmission RandomPort -bool true')
  end

  desc "configure", "Set OS-specific configurations"
  def configure
    case RUBY_PLATFORM
    when /darwin/
      if defined?("configure_macos")
        say("Found configure_macos")
        invoke "configure_macos"
      else
        say("No configuration task found for platform `macos'. Please define `configure_macos' first", :red)
      end
    when /freebsd/
      if defined?("configure_freebsd")
        invoke "configure_freebsd"
      else
        say("No configuration task found for platform `freebsd'. Please define `configure_freebsd' first", :red)
      end
    when /win32|cygwin|mswin|mingw|bccwin|wince|emx/
      if defined?("configure_windows")
        invoke "configure_windows"
      else
        say("No configuration task found for platform `windows'. Please define `configure_windows' first", :red)
      end
    when /linux/
      if defined?("configure_linux")
        invoke "configure_linux"
      else
        say("No configuration task found for platform `linux'. Please define `configure_linux' first", :red)
      end
    else
      say("Unknown OS/platform: #{RUBY_PLATFORM.inspect}", :red)
    end
  end
end
