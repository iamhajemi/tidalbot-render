#!/bin/bash

# Mevcut bot process'lerini temizle
cleanup_bot() {
    echo "Mevcut bot process'leri temizleniyor..."
    pkill -f "python bot.py" || true
    sleep 2
    
    # Webhook'u temizle
    TELEGRAM_TOKEN=$(grep "TELEGRAM_TOKEN" bot.py | cut -d'"' -f2)
    if [ ! -z "$TELEGRAM_TOKEN" ]; then
        echo "Webhook temizleniyor..."
        curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/deleteWebhook?drop_pending_updates=true"
        sleep 2
    fi
}

# Ana bot döngüsü
start_bot() {
    echo "Bot başlatılıyor..."
    cleanup_bot
    python bot.py &
    BOT_PID=$!
}

# İlk çalıştırma
start_bot

# Bot çalışır durumda mı kontrol et
while true; do
    if ! ps -p $BOT_PID > /dev/null; then
        echo "Bot çöktü, yeniden başlatılıyor..."
        start_bot
    fi
    sleep 60
done 