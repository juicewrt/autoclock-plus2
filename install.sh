#!/bin/sh
# =======================================================
# JuiceWRT AutoClock+2 Installer for OpenWrt
# =======================================================

REPO="https://raw.githubusercontent.com/juicewrt/autoclock-plus2/main"
TARGET="/root/autoclock+2.sh"
RC="/etc/rc.local"
CRON="/etc/crontabs/root"

echo "📦 Menginstal AutoClock+2 (JuiceWRT)..."

# Unduh script utama
wget -q -O "$TARGET" "$REPO/autoclock+2.sh"
chmod +x "$TARGET"
echo "✅ Script terpasang di $TARGET"

# Tambahkan auto-startup (delay 30 detik)
if ! grep -q "autoclock+2.sh" "$RC" 2>/dev/null; then
  sed -i '/exit 0/d' "$RC" 2>/dev/null
  {
    echo ""
    echo "# AutoClock+2 startup"
    echo "(sleep 30 && /root/autoclock+2.sh) &"
    echo "exit 0"
  } >> "$RC"
  chmod +x "$RC"
  echo "✅ Ditambahkan ke rc.local (auto start 30 detik setelah boot)"
else
  echo "🕐 rc.local sudah berisi AutoClock+2, dilewati"
fi

# Tambahkan cron tiap 30 menit
if ! grep -q "autoclock+2.sh" "$CRON" 2>/dev/null; then
  echo "*/30 * * * * /root/autoclock+2.sh > /dev/null 2>&1" >> "$CRON"
  /etc/init.d/cron restart
  echo "✅ Cron ditambahkan (jalan tiap 30 menit)"
else
  echo "🕒 Cron sudah ada, dilewati"
fi

# Jalankan pertama kali
echo "🚀 Menjalankan pertama kali..."
/root/autoclock+2.sh

echo "✅ Instalasi selesai. Cek log di /tmp/autoclock.log"
