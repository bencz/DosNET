# DosNET - Guia de Testes

Este documento descreve como compilar, testar e executar programas DosNET no DOSBox-X.

## Pré-requisitos

- .NET SDK 10.0+
- DOSBox-X instalado
- JWASM e JWLINK em `C:\JWASM` (dentro do DOSBox)
- HX DOS Extender em `C:\HX` (dentro do DOSBox)

## Estrutura do Projeto

```
DosNET/
├── src/
│   ├── corlib/corlib/     # Biblioteca base (System.*, etc.)
│   ├── DosNet.Core/       # Runtime (GC, Exceptions, I/O)
│   └── DosNet.Compiler/   # Compilador C# -> ASM
├── samples/               # Exemplos de programas
├── build/output/          # Arquivos .ASM gerados
└── dosbox-x/
    ├── drive_c/OUTPUT/    # Arquivos para teste no DOSBox
    └── run_test.sh        # Script para executar testes
```

## Compilação

### 1. Compilar o Compilador

```bash
make all
```

Isso compila:
- `corlib.dll` - Biblioteca base
- `DosNet.Core.dll` - Runtime
- `DosNet.Compiler` - Compilador

### 2. Gerar Assembly do CORLIB

```bash
make corlib-asm
```

Gera `build/output/CORLIB.ASM` com todo o runtime.

### 3. Gerar Assembly dos Samples

```bash
make samples
```

Gera arquivos `.ASM` para cada sample em `build/output/`.

### 4. Compilar Tudo de Uma Vez

```bash
make corlib-asm samples
```

## Testando no DOSBox-X

### Passo 1: Copiar Arquivos para o DOSBox

```bash
# Copiar CORLIB e o sample desejado
cp build/output/CORLIB.ASM dosbox-x/drive_c/OUTPUT/
cp build/output/HELLOWLD.ASM dosbox-x/drive_c/OUTPUT/
```

### Passo 2: Criar Script de Build (.BAT)

Exemplo para HelloWorld (`HELLOWLD.BAT`):

```batch
@ECHO OFF
ECHO Building HelloWorld... > LOG.TXT

REM Limpar arquivos antigos
DEL *.OBJ 2>NUL
DEL *.EXE 2>NUL

REM Assemblar CORLIB
ECHO [1/4] Assembling CORLIB... >> LOG.TXT
C:\JWASM\JWASMR.EXE CORLIB.ASM >> LOG.TXT
IF NOT EXIST CORLIB.OBJ GOTO ERROR

REM Assemblar aplicação
ECHO [2/4] Assembling HELLOWLD... >> LOG.TXT
C:\JWASM\JWASMR.EXE HELLOWLD.ASM >> LOG.TXT
IF NOT EXIST HELLOWLD.OBJ GOTO ERROR

REM Linkar
ECHO [3/4] Linking... >> LOG.TXT
C:\JWASM\JWLINKD.EXE format windows pe file HELLOWLD.OBJ,CORLIB.OBJ name HELLOWLD.EXE >> LOG.TXT
IF NOT EXIST HELLOWLD.EXE GOTO ERROR

REM Adicionar stub do HX DOS Extender
ECHO [4/4] Adding stub... >> LOG.TXT
C:\HX\BIN\PESTUB.EXE HELLOWLD.EXE C:\HX\BIN\DPMIST32.BIN >> LOG.TXT

REM Executar
ECHO Running... >> LOG.TXT
HELLOWLD.EXE > RESULT.TXT
TYPE RESULT.TXT >> LOG.TXT
GOTO END

:ERROR
ECHO BUILD FAILED! >> LOG.TXT

:END
```

### Passo 3: Executar no DOSBox

**Opção A: Usando o script automatizado**

```bash
./dosbox-x/run_test.sh 120 "HELLOWLD.BAT"
```

Parâmetros:
- `120` - Timeout em segundos
- `HELLOWLD.BAT` - Script a executar

**Opção B: Manualmente no DOSBox**

1. Abrir DOSBox-X
2. Montar o drive: `MOUNT C dosbox-x/drive_c`
3. Ir para o diretório: `C:` e `CD OUTPUT`
4. Executar o script: `HELLOWLD.BAT`
5. Ver resultado: `TYPE LOG.TXT`

### Passo 4: Verificar Resultado

O output é capturado em:
- `LOG.TXT` - Log completo do build
- `RESULT.TXT` - Output do programa

## Samples Disponíveis

| Sample | Descrição | Status |
|--------|-----------|--------|
| HelloWorld | Imprime "Hello, DOS World!" | ✅ Funcionando |
| TestNoAlloc | Teste sem alocação de memória | ✅ Funcionando |
| SimpleInt | Imprime número inteiro | 🔧 Em desenvolvimento |
| Fibonacci | Calcula Fibonacci(10) | 🔧 Em desenvolvimento |
| TestAlloc | Teste de alocação de array | 🔧 Em desenvolvimento |
| TestObj | Teste de alocação de objeto | 🔧 Em desenvolvimento |

## Troubleshooting

### Programa não produz output

1. Verificar `LOG.TXT` para erros de build
2. Verificar se CORLIB.ASM foi atualizado
3. Verificar se o GC está sendo inicializado

### Erro "undefined reference"

- Verificar se o símbolo está declarado como `PUBLIC` no CORLIB
- Verificar se o símbolo está declarado como `EXTRN` na aplicação

### Programa crasha

- Verificar se `__gc_init` está sendo chamado antes de `Main`
- Verificar se `__program_end` está no final do código
- Verificar convenções de chamada (cdecl)

## Fluxo de Desenvolvimento

1. Editar código em `src/`
2. Recompilar: `make all`
3. Gerar assembly: `make corlib-asm samples`
4. Copiar para DOSBox: `cp build/output/*.ASM dosbox-x/drive_c/OUTPUT/`
5. Testar: `./dosbox-x/run_test.sh 120 "SCRIPT.BAT"`
6. Verificar: `cat dosbox-x/drive_c/OUTPUT/LOG.TXT`

## Comandos Úteis

```bash
# Limpar tudo
make clean

# Recompilar tudo do zero
make clean && make all && make corlib-asm samples

# Copiar todos os arquivos para DOSBox
cp build/output/*.ASM dosbox-x/drive_c/OUTPUT/

# Ver últimas linhas do log
tail -20 dosbox-x/drive_c/OUTPUT/LOG.TXT
```
