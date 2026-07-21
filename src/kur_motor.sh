#!/bin/bash
# VeriTakip kurulum motoru — "VeriTakip Kur.app" tarafından çağrılır.
# Kullanım: kur_motor.sh <kota_gb> <kesim_gunu> <iphone|android> [--dry]
# NOT: Python GEREKTİRMEZ — ölçüm motoru uygulama paketine gömülü universal binary.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
KOTA="${1:-60}"
GUN="${2:-1}"
TEL="${3:-iphone}"
DRY="${4:-}"

case "$KOTA" in (*[!0-9]*|"") echo "HATA: Kota sayı olmalı (örn. 60)"; exit 1;; esac
case "$GUN" in (*[!0-9]*|"") echo "HATA: Kesim günü 1-28 arası olmalı"; exit 1;; esac
[ "$GUN" -ge 1 ] && [ "$GUN" -le 28 ] || { echo "HATA: Kesim günü 1-28 arası olmalı"; exit 1; }

if [ "$TEL" = "android" ]; then
    ONEKLER='["172.20.10.", "192.168.42.", "192.168.43.", "192.168.44."]'
else
    ONEKLER='["172.20.10."]'
fi

mkdir -p "$HOME/VeriTakip"
CFG="$HOME/VeriTakip/config.json"
# Config birleştirme: güncelleme/yeniden kurulumda kullanıcının öğrenilmiş
# ayarları (bilinen_aglar = ağ hafızası, bildirim tercihleri, kalan kota…)
# KORUNUR; yalnız sihirbazda girilen kota/kesim günü güncellenir, telefon
# önekleri birleştirilir. JSON birleştirme macOS'ta her zaman bulunan
# JavaScript-for-Automation ile yapılır (Python gerektirmez).
VT_OLD=""
[ -f "$CFG" ] && VT_OLD="$(cat "$CFG")"
export VT_OLD VT_KOTA="$KOTA" VT_GUN="$GUN" VT_ONEKLER="$ONEKLER"
YENI_CFG="$(osascript -l JavaScript <<'JXA' 2>/dev/null || true
function run() {
  ObjC.import('Foundation');
  var env = $.NSProcessInfo.processInfo.environment.js;
  var cfg = {};
  var old = env['VT_OLD'] ? ObjC.unwrap(env['VT_OLD']) : '';
  if (old) { try { cfg = JSON.parse(old); } catch(e) { cfg = {}; } }
  cfg.aylik_kota_gb = parseInt(ObjC.unwrap(env['VT_KOTA']), 10);
  cfg.donem_baslangic_gunu = parseInt(ObjC.unwrap(env['VT_GUN']), 10);
  var yeni = JSON.parse(ObjC.unwrap(env['VT_ONEKLER']));
  var cur = cfg.hotspot_onekler || [];
  yeni.forEach(function(o){ if (cur.indexOf(o) < 0) cur.push(o); });
  cfg.hotspot_onekler = cur;
  if (!cfg.bilinen_aglar) cfg.bilinen_aglar = {};
  return JSON.stringify(cfg, null, 2);
}
JXA
)"
# JXA başarısız olursa (çok eski/kısıtlı sistem) temiz config'e düş
if [ -z "$YENI_CFG" ]; then
    YENI_CFG="{\"aylik_kota_gb\": $KOTA, \"donem_baslangic_gunu\": $GUN, \"hotspot_onekler\": $ONEKLER, \"bilinen_aglar\": {}}"
fi
printf '%s\n' "$YENI_CFG" > "$CFG"

mkdir -p "$HOME/Applications"
rm -rf "$HOME/Applications/VeriTakip.app"
cp -R "$DIR/VeriTakip.app" "$HOME/Applications/"
xattr -dr com.apple.quarantine "$HOME/Applications/VeriTakip.app" 2>/dev/null || true

# Ölçüm motoru: uygulama paketine gömülü universal binary (Python gerekmez)
OLCUM_BIN="$HOME/Applications/VeriTakip.app/Contents/Resources/veri_takip"
chmod +x "$OLCUM_BIN" 2>/dev/null || true

UID_="$(id -u)"
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Desktop"
OLCUM="$HOME/Library/LaunchAgents/com.veritakip.olcum.plist"
cat > "$OLCUM" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.veritakip.olcum</string>
    <key>ProgramArguments</key>
    <array><string>$OLCUM_BIN</string></array>
    <key>StartInterval</key><integer>60</integer>
    <key>WatchPaths</key>
    <array>
        <string>/private/var/run/resolv.conf</string>
        <string>/Library/Preferences/SystemConfiguration/preferences.plist</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>StandardErrorPath</key><string>$HOME/VeriTakip/hata.log</string>
</dict>
</plist>
EOF

APP="$HOME/Library/LaunchAgents/com.veritakip.app.plist"
cat > "$APP" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.veritakip.app</string>
    <key>ProgramArguments</key>
    <array><string>$HOME/Applications/VeriTakip.app/Contents/MacOS/VeriTakip</string></array>
    <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

if [ "$DRY" != "--dry" ]; then
    launchctl bootout "gui/$UID_/com.veritakip.olcum" 2>/dev/null || true
    launchctl bootstrap "gui/$UID_" "$OLCUM"
    launchctl bootout "gui/$UID_/com.veritakip.app" 2>/dev/null || true
    launchctl bootstrap "gui/$UID_" "$APP"
fi

# İlk ölçümü çalıştır (rapor + veri dosyaları oluşsun)
"$OLCUM_BIN" || true
ln -sf "$HOME/VeriTakip/rapor.html" "$HOME/Desktop/VeriTakip Raporu.html"
echo "KURULUM_TAMAM"
