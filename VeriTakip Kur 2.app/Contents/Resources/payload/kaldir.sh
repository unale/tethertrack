#!/bin/bash
# VeriTakip kaldırma betiği
UID_="$(id -u)"
launchctl bootout "gui/$UID_/com.veritakip.olcum" 2>/dev/null || true
launchctl bootout "gui/$UID_/com.veritakip.app" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.veritakip.olcum.plist" \
      "$HOME/Library/LaunchAgents/com.veritakip.app.plist"
pkill -f "VeriTakip.app/Contents/MacOS/VeriTakip" 2>/dev/null || true
rm -rf "$HOME/Applications/VeriTakip.app"
rm -f "$HOME/Desktop/VeriTakip Raporu.html"
echo "VeriTakip kaldırıldı."
echo "Toplanan veriler ~/VeriTakip klasöründe duruyor;"
echo "onları da silmek isterseniz:  rm -rf ~/VeriTakip"
