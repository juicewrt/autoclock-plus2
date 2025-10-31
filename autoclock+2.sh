#!/bin/sh
# =======================================================
# AutoClock+2 — Sinkron waktu via HTTP (XL) + Offset 2 Menit
# =======================================================

HOST="xl.co.id"
OFFSET=120    # kompensasi tetap 120 detik (2 menit)
LOG="/tmp/autoclock.log"

# 🔁 Reset log jika terlalu besar
if [ -f "$LOG" ] && [ "$(wc -c < "$LOG")" -gt 51200 ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔄 Log terlalu besar (>50KB), direset." > "$LOG"
else
  echo "-------------------------------------------------------" >> "$LOG"
fi

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"; }

log "== AutoClock+2 start (host: $HOST, offset +${OFFSET}s) =="

# Ambil header waktu dari XL
DATE_LINE=$(wget -q --max-redirect=3 --server-response -O- "http://$HOST" 2>&1 | grep -i "Date:" | head -n1 | tr -d '\r')
if [ -z "$DATE_LINE" ]; then
  log "❌ Gagal ambil header Date dari $HOST"
  exit 1
fi
log "✅ Header Date: $DATE_LINE"

# Parsing "Date: Fri, 31 Oct 2025 02:45:45 GMT"
DATE_CLEAN=$(echo "$DATE_LINE" | sed 's/Date: //;s/,//g')
DAY=$(echo "$DATE_CLEAN" | awk '{print $2}')
MON=$(echo "$DATE_CLEAN" | awk '{print $3}')
YEAR=$(echo "$DATE_CLEAN" | awk '{print $4}')
TIMEUTC=$(echo "$DATE_CLEAN" | awk '{print $5}')

case "$MON" in
  Jan) MON=01;; Feb) MON=02;; Mar) MON=03;; Apr) MON=04;;
  May) MON=05;; Jun) MON=06;; Jul) MON=07;; Aug) MON=08;;
  Sep) MON=09;; Oct) MON=10;; Nov) MON=11;; Dec) MON=12;;
esac

UTC_EPOCH=$(date -u -d "$YEAR-$MON-$DAY $TIMEUTC" +%s 2>/dev/null)
if [ -z "$UTC_EPOCH" ]; then
  log "❌ Format tanggal tidak dikenali: $DATE_CLEAN"
  exit 1
fi

# Tambahkan offset tetap +2 menit
FINAL_EPOCH=$((UTC_EPOCH + 25200 + OFFSET))
FINAL_TIME=$(date -u -d "@$FINAL_EPOCH" '+%Y-%m-%d %H:%M:%S')

date -s "$FINAL_TIME" >/dev/null 2>&1
log "🕒 Waktu sistem diset ke: $FINAL_TIME (WIB +${OFFSET}s)"

date >> "$LOG"
log "✅ Sinkronisasi selesai via $HOST (AutoClock+2)"
log "======================================================="
