#!/bin/bash
PLIST="$HOME/Library/LaunchAgents/com.sangso.zhugeliang.plist"
launchctl unload "$PLIST" 2>/dev/null || true
rm -f "$PLIST"
echo "Removed."
