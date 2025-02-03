#!/bin/bash

# Git yapılandırması
git config --global user.email "bot@example.com"
git config --global user.name "TidalBot"

# Git remote'u ekle (eğer yoksa)
if ! git remote | grep -q '^origin$'; then
    git remote add origin https://github.com/iamhajemi/tidalbot-render.git
fi

check_updates() {
    # Uzak değişiklikleri kontrol et
    git fetch origin main
    
    # Yerel ve uzak commit hash'lerini al
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)
    
    # Eğer farklılarsa güncelleme var demektir
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Yeni güncelleme bulundu!"
        git pull origin main
        return 0
    else
        echo "Güncelleme yok."
        return 1
    fi
}

# Ana bot döngüsü
start_bot() {
    echo "Bot başlatılıyor..."
    python bot.py &
    BOT_PID=$!
}

# İlk çalıştırma
start_bot

while true; do
    # Her dakika güncelleme kontrolü yap
    if check_updates; then
        echo "Güncelleme bulundu, bot yeniden başlatılıyor..."
        # Eğer bot çalışıyorsa durdur
        if ps -p $BOT_PID > /dev/null; then
            kill $BOT_PID
            wait $BOT_PID 2>/dev/null
        fi
        # Botu yeniden başlat
        start_bot
    fi
    
    # 60 saniye bekle
    sleep 60
done 