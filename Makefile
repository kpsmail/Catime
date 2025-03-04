# 设置编译器为 MinGW
CC = x86_64-w64-mingw32-gcc
WINDRES = x86_64-w64-mingw32-windres

# 设置目标文件夹路径
OUTPUT_DIR = /mnt/c/Users/vladelaina/Desktop
ASSET_DIR = $(OUTPUT_DIR)/asset

# 创建构建目录
BUILD_DIR = build

# 设置文件名 - 添加 window_procedure.c
SRC_FILES = main.c src/window.c src/tray.c src/color.c src/font.c src/language.c src/timer.c src/tray_menu.c src/startup.c src/config.c src/window_procedure.c
RC_FILE = resource/resource.rc

# 创建目标文件夹和资源文件夹
$(shell mkdir -p $(OUTPUT_DIR) $(ASSET_DIR))

# 编译选项
CFLAGS = -mwindows -Iinclude

# 链接选项 - 添加必要的库
LDFLAGS = -lole32 -lshell32 -lcomdlg32 -luuid

# 确保 dwmapi.lib 被链接
LIBS = -ldwmapi -luser32 -lgdi32 -lcomdlg32

# 生成目标文件列表 - 添加 window_procedure.o
OBJS = $(BUILD_DIR)/main.o \
       $(BUILD_DIR)/window.o \
       $(BUILD_DIR)/tray.o \
       $(BUILD_DIR)/color.o \
       $(BUILD_DIR)/font.o \
       $(BUILD_DIR)/language.o \
       $(BUILD_DIR)/timer.o \
       $(BUILD_DIR)/tray_menu.o \
       $(BUILD_DIR)/startup.o \
       $(BUILD_DIR)/config.o \
       $(BUILD_DIR)/window_procedure.o

# 生成目标
all: directories $(OUTPUT_DIR)/catime.exe
	@rm -f $(BUILD_DIR)/*.o  # 编译完成后删除所有 .o 文件
	@cmd.exe /C start "" "$(shell echo '$(OUTPUT_DIR)/catime.exe' | sed 's#/mnt/c/#C:/#')"  # 转换路径格式

# 创建必要的目录
directories:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OUTPUT_DIR)

# 编译资源文件
$(BUILD_DIR)/resource.o: $(RC_FILE)
	@$(WINDRES) $(RC_FILE) -o $(BUILD_DIR)/resource.o

# 编译主程序
$(BUILD_DIR)/main.o: main.c
	@$(CC) -c main.c -o $(BUILD_DIR)/main.o $(CFLAGS)

# 编译语言模块
$(BUILD_DIR)/language.o: src/language.c
	@$(CC) -c src/language.c -o $(BUILD_DIR)/language.o $(CFLAGS)

# 编译字体模块
$(BUILD_DIR)/font.o: src/font.c
	@$(CC) -c src/font.c -o $(BUILD_DIR)/font.o $(CFLAGS)

# 编译颜色模块
$(BUILD_DIR)/color.o: src/color.c
	@$(CC) -c src/color.c -o $(BUILD_DIR)/color.o $(CFLAGS)

# 编译托盘模块
$(BUILD_DIR)/tray.o: src/tray.c
	@$(CC) -c src/tray.c -o $(BUILD_DIR)/tray.o $(CFLAGS)

# 编译托盘菜单模块
$(BUILD_DIR)/tray_menu.o: src/tray_menu.c
	@$(CC) -c src/tray_menu.c -o $(BUILD_DIR)/tray_menu.o $(CFLAGS)

# 编译计时器模块
$(BUILD_DIR)/timer.o: src/timer.c
	@$(CC) -c src/timer.c -o $(BUILD_DIR)/timer.o $(CFLAGS)

# 编译窗口模块
$(BUILD_DIR)/window.o: src/window.c
	@$(CC) -c src/window.c -o $(BUILD_DIR)/window.o $(CFLAGS)

# 编译自启动模块
$(BUILD_DIR)/startup.o: src/startup.c
	@$(CC) -c src/startup.c -o $(BUILD_DIR)/startup.o $(CFLAGS)

# 编译配置模块
$(BUILD_DIR)/config.o: src/config.c
	@$(CC) -c src/config.c -o $(BUILD_DIR)/config.o $(CFLAGS)

# 编译窗口过程处理模块
$(BUILD_DIR)/window_procedure.o: src/window_procedure.c
	@$(CC) -c src/window_procedure.c -o $(BUILD_DIR)/window_procedure.o $(CFLAGS)

# 链接编译目标文件，输出到输出目录
$(OUTPUT_DIR)/catime.exe: $(OBJS) $(BUILD_DIR)/resource.o
	@$(CC) -o $(OUTPUT_DIR)/catime.exe $(OBJS) $(BUILD_DIR)/resource.o $(CFLAGS) $(LDFLAGS) $(LIBS)

# 清理构建文件
clean:
	@powershell.exe -Command "Stop-Process -Name catime -Force -ErrorAction SilentlyContinue"
	@rm -f $(BUILD_DIR)/*.o $(OUTPUT_DIR)/catime.exe
	@rm -rf $(BUILD_DIR)/include $(BUILD_DIR)/resource

.PHONY: all clean
