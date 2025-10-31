## 🔧 Uninstall
Jika kamu ingin menghapus AutoClock+2 sepenuhnya dari sistem OpenWrt:

```bash
rm -f /root/autoclock+2.sh
sed -i '/autoclock+2.sh/d' /etc/rc.local
sed -i '/autoclock+2.sh/d' /etc/crontabs/root
/etc/init.d/cron restart
rm -f /tmp/autoclock.log
echo "✅ AutoClock+2 sudah dihapus sepenuhnya."
