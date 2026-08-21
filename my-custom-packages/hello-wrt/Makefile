include $(TOPDIR)/rules.mk

PKG_NAME:=hello-wrt
PKG_RELEASE:=1
PKG_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk

define Package/hello-wrt
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Minimal Inverted Wrapper OpenWrt Validation Package
enddefine

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	echo '#include <stdio.h>' > $(PKG_BUILD_DIR)/hello.c
	echo 'int main(void) { printf("Hello from the Master OpenWrt Wrapper Setup!\\n"); return 0; }' >> $(PKG_BUILD_DIR)/hello.c
enddefine

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(PKG_BUILD_DIR)/hello.c -o $(PKG_BUILD_DIR)/hello_wrt_test
enddefine

define Package/hello-wrt/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/hello_wrt_test $(1)/usr/bin/
enddefine

$(eval $(call BuildPackage,hello-wrt))
