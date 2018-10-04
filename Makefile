ARCH = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoogleMapsEnhancer
GoogleMapsEnhancer_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard" 
SUBPROJECTS += googlemapsenhancer
include $(THEOS_MAKE_PATH)/aggregate.mk
