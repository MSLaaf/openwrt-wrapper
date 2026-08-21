# ==============================================================================
#  OPENWRT MASTER WRAPPER ENVIRONMENT
# ==============================================================================

OW_VERSION = 24.10
OW_DIR     = $(CURDIR)/.openwrt-core
OW_URL     = https://github.com

.PHONY: all sysconfig sync_ow clean

all: sync_ow
	@echo "[*] Synchronizing Custom Local Package Feeds..."
	@cp -f $(CURDIR)/feeds.conf $(OW_DIR)/feeds.conf
	@cd $(OW_DIR) && ./scripts/feeds update -a && ./scripts/feeds install -a
	@if [ -f $(CURDIR)/configs/product_defconfig ]; then \
		cp -f $(CURDIR)/configs/product_defconfig $(OW_DIR)/.config; \
	fi
	@$(MAKE) -C $(OW_DIR) defconfig
	@echo "[*] Launching Master Core Compilation Layer..."
	@$(MAKE) -C $(OW_DIR) -j$$(nproc)

sync_ow:
	@if [ ! -d "$(OW_DIR)" ]; then \
		echo "[*] Fetching OpenWrt Base Source Code v$(OW_VERSION)..."; \
		mkdir -p $(OW_DIR); \
		curl -sL $(OW_URL) | tar -xz --strip-components=1 -C $(OW_DIR); \
	fi

sysconfig: sync_ow
	@cp -f $(CURDIR)/feeds.conf $(OW_DIR)/feeds.conf
	@cd $(OW_DIR) && ./scripts/feeds update -a && ./scripts/feeds install -a
	@if [ -f $(CURDIR)/configs/product_defconfig ]; then \
		cp -f $(CURDIR)/configs/product_defconfig $(OW_DIR)/.config; \
	fi
	@$(MAKE) -C $(OW_DIR) menuconfig
	@echo "[*] Preserving Config Alterations to configs/product_defconfig..."
	@mkdir -p $(CURDIR)/configs
	@cp -f $(OW_DIR)/.config $(CURDIR)/configs/product_defconfig

clean:
	@if [ -d "$(OW_DIR)" ]; then $(MAKE) -C $(OW_DIR) clean; fi
