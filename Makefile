ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:9.1:7.0

include theos/makefiles/common.mk

TWEAK_NAME = CellularUsageOrder
CellularUsageOrder_FILES = Tweak.x Entry.m

include $(THEOS_MAKE_PATH)/tweak.mk
ADDITIONAL_OBJCFLAGS = -fobjc-arc

after-install::
	install.exec "killall -9 Preferences"
