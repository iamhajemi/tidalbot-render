FROM python:3.9-slim

# Gerekli paketlerin kurulumu
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Git repository'yi klonla ve yapılandır
RUN git clone https://github.com/yourusername/tidalbot-render.git . && \
    git config --global user.email "bot@example.com" && \
    git config --global user.name "TidalBot"

# Gerekli dosyaları kopyala
COPY requirements.txt .
COPY bot.py .
COPY run.sh .
COPY default/ default/

# Python bağımlılıklarını yükle ve yt-dlp'yi güncelle
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade yt-dlp

# downloads klasörünü oluştur
RUN mkdir -p downloads

# Çalışma izinlerini ayarla
RUN chmod +x run.sh

# Tidal yapılandırma dosyasını kopyala
RUN mkdir -p /root/.cache/tidal-dl

CMD ["./run.sh"] 