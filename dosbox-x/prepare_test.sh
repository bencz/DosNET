#!/bin/bash
# Script para preparar ambiente de testes no DOSBox-X

DOSNET_ROOT="/Users/bencz/programming/DosNET"
DOSBOX_DIR="$DOSNET_ROOT/dosbox-x"
DRIVE_C="$DOSBOX_DIR/drive_c"

echo "=== Preparando ambiente de testes DosNET ==="

# Criar diretórios
mkdir -p "$DRIVE_C/OUTPUT"
mkdir -p "$DRIVE_C/MASM611"
mkdir -p "$DRIVE_C/HX"

# Copiar arquivos de output
echo "Copiando arquivos de build..."
cp -v "$DOSNET_ROOT/build/output/"*.asm "$DRIVE_C/OUTPUT/" 2>/dev/null
cp -v "$DOSNET_ROOT/build/output/"*.bat "$DRIVE_C/OUTPUT/" 2>/dev/null

echo ""
echo "=== Estrutura de diretórios ==="
echo "C:\\ (drive_c/):"
ls -la "$DRIVE_C/"
echo ""
echo "C:\\OUTPUT:"
ls -la "$DRIVE_C/OUTPUT/"
echo ""
echo "=== Próximos passos ==="
echo "1. Instale MASM 6.11 em: $DRIVE_C/MASM611/"
echo "2. Instale HX DOS Extender em: $DRIVE_C/HX/"
echo "3. Execute: ./run_dosbox.sh"
