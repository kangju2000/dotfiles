#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "💾 Backing up current macOS settings..."

BACKUP_DIR="$DOTFILES_DIR/macos"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/settings-backup-${TIMESTAMP}.sh"

# Helper function to backup a setting only if it exists
backup_setting() {
  local domain=$1
  local key=$2
  local type=$3
  local comment=$4

  if defaults read "$domain" "$key" &>/dev/null; then
    local value=$(defaults read "$domain" "$key")
    echo "" >> "$BACKUP_FILE"
    echo "# $comment" >> "$BACKUP_FILE"
    echo "defaults write $domain $key -$type $value" >> "$BACKUP_FILE"
  fi
}

# Create backup script header
cat > "$BACKUP_FILE" << 'EOF'
#!/bin/zsh

echo "🍎 Applying macOS system settings..."

# Close System Preferences to prevent override
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Keyboard & Input
###############################################################################

echo "⌨️ Setting keyboard preferences..."
EOF

# Backup Keyboard settings
echo "⌨️ Backing up keyboard preferences..."
backup_setting "NSGlobalDomain" "KeyRepeat" "int" "Set key repeat rate (1 = fastest)"
backup_setting "NSGlobalDomain" "InitialKeyRepeat" "int" "Set delay until repeat (15 = shortest)"
backup_setting "NSGlobalDomain" "NSAutomaticCapitalizationEnabled" "bool" "Disable automatic capitalization"
backup_setting "NSGlobalDomain" "NSAutomaticDashSubstitutionEnabled" "bool" "Disable smart dashes"
backup_setting "NSGlobalDomain" "NSAutomaticPeriodSubstitutionEnabled" "bool" "Disable automatic period substitution"
backup_setting "NSGlobalDomain" "NSAutomaticQuoteSubstitutionEnabled" "bool" "Disable smart quotes"
backup_setting "NSGlobalDomain" "NSAutomaticSpellingCorrectionEnabled" "bool" "Disable auto-correct"

# Backup Finder settings
echo "📁 Backing up Finder preferences..."
cat >> "$BACKUP_FILE" << 'EOF'

###############################################################################
# Finder
###############################################################################

echo "📁 Setting Finder preferences..."
EOF

backup_setting "com.apple.finder" "AppleShowAllFiles" "bool" "Show hidden files"
backup_setting "com.apple.finder" "ShowPathbar" "bool" "Show path bar"
backup_setting "com.apple.finder" "ShowStatusBar" "bool" "Show status bar"
backup_setting "NSGlobalDomain" "AppleShowAllExtensions" "bool" "Show file extensions"
backup_setting "com.apple.finder" "FXEnableExtensionChangeWarning" "bool" "Warning when changing file extension"
backup_setting "com.apple.finder" "FXPreferredViewStyle" "string" "Finder view style"

# Add Library and Volumes folder visibility commands if needed
if [ ! $(ls -dOl ~/Library | awk '{print $5}') = "hidden" ]; then
  cat >> "$BACKUP_FILE" << 'EOF'

# Show the ~/Library folder
chflags nohidden ~/Library
EOF
fi

# Backup Dock settings
echo "🎯 Backing up Dock preferences..."
cat >> "$BACKUP_FILE" << 'EOF'

###############################################################################
# Dock
###############################################################################

echo "🎯 Setting Dock preferences..."
EOF

backup_setting "com.apple.dock" "tilesize" "int" "Set Dock icon size"
backup_setting "com.apple.dock" "autohide" "bool" "Auto-hide the Dock"
backup_setting "com.apple.dock" "autohide-delay" "float" "Auto-hiding delay"
backup_setting "com.apple.dock" "show-recents" "bool" "Show recent applications in Dock"

# Backup Screenshot settings
echo "📸 Backing up screenshot preferences..."
cat >> "$BACKUP_FILE" << 'EOF'

###############################################################################
# Screenshots
###############################################################################

echo "📸 Setting screenshot preferences..."
EOF

if defaults read com.apple.screencapture location &>/dev/null; then
  SCREENSHOT_LOC=$(defaults read com.apple.screencapture location)
  cat >> "$BACKUP_FILE" << EOF

# Create Screenshots directory
mkdir -p "$SCREENSHOT_LOC"

# Screenshot location
defaults write com.apple.screencapture location -string "$SCREENSHOT_LOC"
EOF
fi

backup_setting "com.apple.screencapture" "type" "string" "Screenshot format"
backup_setting "com.apple.screencapture" "disable-shadow" "bool" "Disable shadow in screenshots"

# Backup Trackpad settings
echo "👆 Backing up trackpad preferences..."
cat >> "$BACKUP_FILE" << 'EOF'

###############################################################################
# Trackpad
###############################################################################

echo "👆 Setting trackpad preferences..."
EOF

if defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking &>/dev/null; then
  TAP_TO_CLICK=$(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking)
  cat >> "$BACKUP_FILE" << EOF

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool $TAP_TO_CLICK
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
EOF
fi

if defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag &>/dev/null; then
  THREE_FINGER=$(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag)
  cat >> "$BACKUP_FILE" << EOF

# Enable three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool $THREE_FINGER
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool $THREE_FINGER
EOF
fi

# Add restart commands
cat >> "$BACKUP_FILE" << 'EOF'

###############################################################################
# Apply changes
###############################################################################

echo "✨ Restarting affected applications..."

# Restart Finder and Dock
killall Finder
killall Dock

# Restart SystemUIServer
killall SystemUIServer

echo "✅ macOS settings applied!"
echo "⚠️ Some changes may require a logout/restart to take effect."
EOF

# Make the backup file executable
chmod +x "$BACKUP_FILE"

echo ""
echo "✅ Backup complete!"
echo ""
echo "📄 Backup file created: $BACKUP_FILE"
echo ""
echo "💡 Only settings that are explicitly configured were backed up."
echo "   Settings with default values (not yet modified) were skipped."
echo ""
echo "To apply these settings later, run:"
echo "  $BACKUP_FILE"
