#!/bin/bash
# Script para executar DOSBox-X com configuração DosNET

DOSNET_ROOT="/Users/bencz/programming/DosNET"
DOSBOX_DIR="$DOSNET_ROOT/dosbox-x"
# Usar versão SDL1 que é mais estável no macOS
DOSBOX_APP="$DOSBOX_DIR/dosbox-x/dosbox-x.app/Contents/MacOS/dosbox-x"
CONFIG="$DOSBOX_DIR/dosbox.conf"

# Verificar se DOSBox-X existe
if [ ! -f "$DOSBOX_APP" ]; then
    echo "Erro: DOSBox-X não encontrado em $DOSBOX_APP"
    exit 1
fi

# Executar DOSBox-X com configuração
echo "Iniciando DOSBox-X..."
"$DOSBOX_APP" -conf "$CONFIG" "$@"
