# QwenPaw — Dockerfile para deploy no Coolify
# Usamos a imagem oficial pré-construída do Docker Hub.
# Este Dockerfile é um wrapper mínimo que adiciona volumes e configurações,
# permitindo que o Coolify faça o deploy automaticamente via build pack Dockerfile.

FROM agentscope/qwenpaw:latest

# Instalar curl para o healthcheck do Coolify (baseado em Alpine/Debian conforme a imagem oficial)
# A imagem oficial geralmente é baseada em Python (Debian-slim ou Alpine)
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* || \
    (apk add --no-cache curl)

# Instalar suporte nativo a Whisper para STT e edge-tts para TTS no Telegram.
RUN if [ -x /app/venv/bin/pip ]; then \
      /app/venv/bin/pip install --no-cache-dir "qwenpaw[whisper]" edge-tts; \
    else \
      python -m pip install --no-cache-dir "qwenpaw[whisper]" edge-tts; \
    fi

# Portas expostas pelo QwenPaw
EXPOSE 8088

# Volumes persistentes — o Coolify mapeia esses paths automaticamente
# Data de trabalho do agente
VOLUME ["/app/working"]

# Arquivos sensíveis (chaves, credenciais)
VOLUME ["/app/working.secret"]

# Backups do QwenPaw
VOLUME ["/app/working.backups"]

# A imagem oficial já define o entrypoint/cmd corretamente,
# então não precisamos sobrescrever.
