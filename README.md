# ⏰ JuiceWRT AutoClock+2

Sinkronisasi waktu **OpenWrt via HTTP (xl.co.id)** dengan kompensasi tetap +2 menit dari server.  
Didesain khusus untuk router yang cenderung *terlambat 2–3 menit* karena drift hardware clock.

---

## ✨ Fitur Utama
✅ Sinkronisasi dari header `Date:` milik `xl.co.id`  
✅ Kompensasi otomatis +120 detik (2 menit) setiap sinkron  
✅ Tidak butuh `ntpd` / `chronyd`  
✅ Auto-start 30 detik setelah boot  
✅ Auto-cron setiap 30 menit  
✅ Log rotate otomatis (maks 50KB di `/tmp`)  
✅ Aman — tidak restart OpenClash / injektor / DNS  

---

## ⚙️ Instalasi Cepat
Jalankan di OpenWrt:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/juicewrt/autoclock-plus2/main/install.sh)"

##  🚧 Uninstall
rm -f /root/autoclock+2.sh
sed -i '/autoclock+2.sh/d' /etc/rc.local
sed -i '/autoclock+2.sh/d' /etc/crontabs/root
/etc/init.d/cron restart
rm -f /tmp/autoclock.log
echo "✅ AutoClock+2 sudah dihapus sepenuhnya."
