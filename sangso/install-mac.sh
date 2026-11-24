#!/bin/bash
# Zhuge Liang memorial popup - macOS installer
# Opens index.html every day at 07:00 and every time you log in.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/index.html"
[ -f "$HTML" ] || { echo "index.html not found: $HTML"; exit 1; }
LABEL="com.sangso.zhugeliang"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array><string>/usr/bin/open</string><string>$HTML</string></array>
  <key>RunAtLoad</key><true/>
  <key>StartCalendarInterval</key>
  <dict><key>Hour</key><integer>7</integer><key>Minute</key><integer>0</integer></dict>
</dict>
</plist>
PL
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"
echo "Installed: daily 07:00 + at login ($PLIST)"
