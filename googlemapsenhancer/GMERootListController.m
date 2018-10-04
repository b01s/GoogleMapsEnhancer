#include "GMERootListController.h"

@interface DefaultModeListController : PSListController
@end
@implementation DefaultModeListController
-(NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"DefaultMode" target:self] retain];
    }
    
    return _specifiers;
}
@end

@interface FollowingModeListController : PSListController
@end
@implementation FollowingModeListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"FollowingMode" target:self] retain];
    }
    
    return _specifiers;
}
@end

@interface NavigationModeListController : PSListController
@end
@implementation NavigationModeListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"NavigationMode" target:self] retain];
    }
    
    return _specifiers;
}
@end


@implementation GMERootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:b01s2791@gmail.com?subject=GoogleMapsEnhancer"]];
}

-(void)donate {
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = @"b01s2791@gmail.com";
    
//    NSURL *url1 = [NSURL URLWithString:@"com.amazon.mobile.shopping.web://www.amazon.com/gp/product/B01FIS82WQ"];
//    NSURL *url2 = [NSURL URLWithString:@"https://www.amazon.com/dp/B01FIS82WQ"];
        NSURL *url2 = [NSURL URLWithString:@"https://ko-fi.com/V7V3KCB0"];
    
//    if ([[UIApplication sharedApplication] canOpenURL:url1]) {
//        [[UIApplication sharedApplication] openURL:url1];
//    }
//    else {
        [[UIApplication sharedApplication] openURL:url2];
//    }
}

-(void)openGitHub {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/b01s/GoogleMapsEnhancer"]];
}

-(void)openNoGMS {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/com.b01s.nogmstartupfootercard"]];
}

-(void)openTwitter_b01s {
    NSURL *url1 = [NSURL URLWithString:@"twitter://user?screen_name=b01s_"];
    NSURL *url2 = [NSURL URLWithString:@"https://twitter.com/b01s_"];

    if ([[UIApplication sharedApplication] canOpenURL:url1]) {
        [[UIApplication sharedApplication] openURL:url1];
    }
    else {
        [[UIApplication sharedApplication] openURL:url2];
    }
}

-(void)openSayed {
    NSURL *url = [NSURL URLWithString:@"https://www.reddit.com/user/sayed_000"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
