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

# Gerekli dosyaları kopyala
COPY requirements.txt .
COPY bot.py .
COPY run.sh .
COPY default/ default/

# Python bağımlılıklarını yükle ve yt-dlp'yi güncelle
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade yt-dlp

# downloads klasörünü oluştur
RUN mkdir downloads

# Çalışma izinlerini ayarla
RUN chmod +x run.sh

# Tidal yapılandırma dosyasını kopyala
RUN mkdir -p /root/.cache/tidal-dl

CMD ["./run.sh"] 