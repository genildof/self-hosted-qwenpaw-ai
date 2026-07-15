# QwenPaw — Dockerfile para deploy no Coolify
# Usamos a imagem oficial pré-construída do Docker Hub.
# Este Dockerfile é um wrapper mínimo que adiciona volumes e configurações,
# permitindo que o Coolify faça o deploy automaticamente via build pack Dockerfile.

FROM agentscope/qwenpaw:latest

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
