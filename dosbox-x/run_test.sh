#!/bin/bash
# Script para executar comandos no DOSBox-X com captura de output
# Uso: ./run_test.sh [timeout_seconds] "COMANDO1" "COMANDO2" ...

DOSNET_ROOT="/Users/bencz/programming/DosNET"
DOSBOX_DIR="$DOSNET_ROOT/dosbox-x"
DRIVE_C="$DOSBOX_DIR/drive_c"
OUTPUT_DIR="$DRIVE_C/OUTPUT"
DOSBOX_APP="$DOSBOX_DIR/dosbox-x/dosbox-x.app/Contents/MacOS/dosbox-x"
CONFIG="$DOSBOX_DIR/dosbox.conf"
LOG_FILE="$OUTPUT_DIR/LOG.TXT"

# Timeout padrão de 120 segundos
TIMEOUT=${1:-120}
shift

# Listar arquivos antes
echo "=== Arquivos antes do build ==="
ls -la "$OUTPUT_DIR/"*.obj "$OUTPUT_DIR/"*.lib "$OUTPUT_DIR/"*.exe 2>/dev/null || echo "(nenhum arquivo .obj/.lib/.exe)"

# Limpar log anterior
rm -f "$LOG_FILE"

echo ""
echo "Executando DOSBox-X (timeout: ${TIMEOUT}s)..."
echo "Comandos: $@"

# Executar DOSBox-X com comandos e redirecionamento para log
# Formato: dosbox EXIT -c "comando1 >>LOG.TXT" -c "comando2 >>LOG.TXT" -exit
"$DOSBOX_APP" -conf "$CONFIG" \
    -c "CD \\OUTPUT" \
    -c "$1 > LOG.TXT" \
    -c "EXIT" \
    -exit 2>/dev/null &
DOSBOX_PID=$!

# Aguardar com timeout
ELAPSED=0
while kill -0 $DOSBOX_PID 2>/dev/null; do
    sleep 1
    ELAPSED=$((ELAPSED + 1))
    if [ $ELAPSED -ge $TIMEOUT ]; then
        echo "ERRO: Timeout após ${TIMEOUT} segundos!"
        kill -9 $DOSBOX_PID 2>/dev/null
        break
    fi
done

wait $DOSBOX_PID 2>/dev/null

# Mostrar log se existir
echo ""
echo "=== OUTPUT DO COMANDO ==="
if [ -f "$LOG_FILE" ]; then
    cat "$LOG_FILE"
else
    echo "(log não gerado)"
fi

# Listar arquivos depois
echo ""
echo "=== Arquivos após o build ==="
ls -la "$OUTPUT_DIR/"*.obj "$OUTPUT_DIR/"*.lib "$OUTPUT_DIR/"*.exe 2>/dev/null || echo "(nenhum arquivo .obj/.lib/.exe)"
