# Copyright (C) 2020-2022 Hyy2001X <https://github.com/Hyy2001X>

include $(TOPDIR)/rules.mk

PKG_NAME:=Postapplication
PKG_VERSION:=1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Upgrade OpenWrt by one-key
	DEPENDS:=+grep
endef

define Package/$(PKG_NAME)/description
	Postapplication - Upgrade OpenWrt by one-key
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/default-setting $(1)/etc/uci-defaults/66-default-settings
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
