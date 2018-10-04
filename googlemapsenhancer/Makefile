include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = googlemapsenhancer
googlemapsenhancer_FILES = GMERootListController.m
googlemapsenhancer_INSTALL_PATH = /Library/PreferenceBundles
googlemapsenhancer_FRAMEWORKS = UIKit
googlemapsenhancer_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/googlemapsenhancer.plist$(ECHO_END)
