# 编译器设置
CROSS_COMPILE = riscv64-linux-gnu-
AS = $(CROSS_COMPILE)as
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

# 编译选项
ASFLAGS = -march=rv64gcv -mabi=lp64d
LDFLAGS = -T test.lds

# 目标文件
TARGET = fp16_to_int8_test
SRC = $(TARGET).S

.PHONY: all clean

all: $(TARGET).bin

$(TARGET).o: $(SRC)
	$(CC) $(ASFLAGS) -c $< -o $@

$(TARGET).elf: $(TARGET).o
	$(LD) $(LDFLAGS) $< -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f $(TARGET).o $(TARGET).elf $(TARGET).bin 