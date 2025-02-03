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
COPY . .

# Git repository'yi initialize et
RUN git init && \
    git config --global user.email "bot@example.com" && \
    git config --global user.name "TidalBot" && \
    git config --global --add safe.directory /app && \
    git add . && \
    git commit -m "Initial commit"

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