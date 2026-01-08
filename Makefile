# DosNET Makefile

BUILD_DIR = build
OUTPUT_DIR = $(BUILD_DIR)/output
SRC_DIR = src
SAMPLES_DIR = samples

CORLIB_DIR = $(SRC_DIR)/corlib/corlib
CORE_DIR = $(SRC_DIR)/DosNet.Core
COMPILER_DIR = $(SRC_DIR)/DosNet.Compiler

CSC = dotnet /usr/local/share/dotnet/sdk/10.0.100/Roslyn/bincore/csc.dll
DOSNETC = $(BUILD_DIR)/DosNet.Compiler

# Lista de samples
SAMPLES = HelloWorld SimpleInt Fibonacci Loop SimpleAdd SimpleClass ArrayTest SwitchTest ExceptionTest NullableTest InheritanceTest InterfaceTest GenericList

.PHONY: all clean corlib core compiler samples samples-dll samples-asm

all: corlib core compiler

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

corlib: $(BUILD_DIR)
	@echo "=== Building corlib ==="
	$(CSC) -nostdlib -noconfig \
		-target:library \
		-out:$(BUILD_DIR)/corlib.dll \
		-langversion:latest \
		-nullable:disable \
		-warn:0 \
		$(CORLIB_DIR)/*.cs

corlib-asm: corlib compiler $(OUTPUT_DIR)
	@echo "=== Generating corlib.asm ==="
	$(DOSNETC) -nostdlib -v -o $(OUTPUT_DIR)/corlib.asm $(BUILD_DIR)/corlib.dll

core: $(BUILD_DIR)
	@echo "=== Building DosNet.Core ==="
	dotnet build $(CORE_DIR)/DosNet.Core.csproj -c Release -o $(BUILD_DIR)

compiler: core $(BUILD_DIR)
	@echo "=== Building DosNet.Compiler ==="
	dotnet build $(COMPILER_DIR)/DosNet.Compiler.csproj -c Release -o $(BUILD_DIR)

# Compilar todos os samples para DLL
samples-dll: corlib $(OUTPUT_DIR)
	@echo "=== Compiling samples to DLL ==="
	@for sample in $(SAMPLES); do \
		echo "  Compiling $$sample.cs..."; \
		$(CSC) -nostdlib -noconfig \
			-target:exe \
			-out:$(OUTPUT_DIR)/$$sample.dll \
			-r:$(BUILD_DIR)/corlib.dll \
			-langversion:latest \
			-nullable:disable \
			-warn:0 \
			$(SAMPLES_DIR)/$$sample.cs 2>/dev/null || echo "    Failed: $$sample"; \
	done

# Gerar assembly para todos os samples
samples-asm: samples-dll compiler
	@echo "=== Generating assembly for samples ==="
	@for sample in $(SAMPLES); do \
		if [ -f $(OUTPUT_DIR)/$$sample.dll ]; then \
			echo "  Generating $$sample.asm..."; \
			$(DOSNETC) -v -o $(OUTPUT_DIR)/$$sample.asm $(OUTPUT_DIR)/$$sample.dll 2>/dev/null || echo "    Failed: $$sample"; \
		fi; \
	done

# Compilar e gerar assembly para todos os samples
samples: samples-asm
	@echo "=== Samples complete ==="
	@echo "Output files in $(OUTPUT_DIR)/"

# Compilar um sample específico: make sample-HelloWorld
sample-%: corlib compiler $(OUTPUT_DIR)
	@echo "=== Building sample: $* ==="
	$(CSC) -nostdlib -noconfig \
		-target:exe \
		-out:$(OUTPUT_DIR)/$*.dll \
		-r:$(BUILD_DIR)/corlib.dll \
		-langversion:latest \
		-nullable:disable \
		-warn:0 \
		$(SAMPLES_DIR)/$*.cs
	$(DOSNETC) -v -o $(OUTPUT_DIR)/$*.asm $(OUTPUT_DIR)/$*.dll

clean:
	@echo "=== Cleaning ==="
	rm -rf $(BUILD_DIR)

rebuild: clean all
