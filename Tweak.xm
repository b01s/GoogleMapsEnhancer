#pragma mark - Prefereces related

static NSMutableDictionary *prefs;

static BOOL tweakEnabled = YES;

static float alphaOfSearchBar = 0.5;
static float alphaOfFooterTabBar = 0.5;

static BOOL autoFollowingMode = NO;
static float cameraZoomLevelValue = 17.25;
static float cameraLookAheadValue = 0.4718;
static float cameraViewingAngleValue = 65;
static BOOL buildings3DMode = NO;

static BOOL translucentRouteGuidanceHeaderMode = YES;
static float alphaOfRouteGuidanceHeader = 0.2;

static BOOL translucentRouteGuidanceFooterMode = YES;
static float alphaOfRouteGuidanceFooter = 0.2;


inline BOOL boolValueForKey (NSString *keyString, BOOL fallback){
    return [prefs objectForKey:keyString] ? [[prefs objectForKey:keyString] boolValue] : fallback;
}

inline float floatValueForKey (NSString *keyString, float fallback){
    return [prefs objectForKey:keyString] ? [[prefs objectForKey:keyString] floatValue] : fallback;
}

static void loadPrefs()
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.b01s.googlemapsenhancer.plist"];
    if(prefs) {
        tweakEnabled = boolValueForKey(@"tweakEnabled", YES);
        
        alphaOfSearchBar = floatValueForKey(@"alphaOfSearchBar", 0.5);
        alphaOfFooterTabBar = floatValueForKey(@"alphaOfFooterTabBar", 0.5);
        
        autoFollowingMode = boolValueForKey(@"autoFollowingMode", NO);
        cameraZoomLevelValue = floatValueForKey(@"cameraZoomLevelValue", 17.25);
        cameraLookAheadValue = floatValueForKey(@"cameraLookAheadValue", 0.4718);
        cameraViewingAngleValue = floatValueForKey(@"cameraViewingAngleValue", 65);
        buildings3DMode = boolValueForKey(@"buildings3DMode", YES);

        translucentRouteGuidanceHeaderMode = boolValueForKey(@"translucentRouteGuidanceHeaderMode", YES);
        alphaOfRouteGuidanceHeader = floatValueForKey(@"alphaOfRouteGuidanceHeader", 0.2);
        
        translucentRouteGuidanceFooterMode = boolValueForKey(@"translucentRouteGuidanceFooterMode", YES);
        alphaOfRouteGuidanceFooter = floatValueForKey(@"alphaOfRouteGuidanceFooter", 0.2);
    }
    [prefs release];
}


#pragma mark - Auto compass mode

@interface AZImages
+ (id)locationButton;
@end

struct GMSVectorMapMode {
    unsigned long long mode_;
};

@interface RootViewController : UIViewController
{
    struct GMSVectorMapMode _lastLocationButtonMapMode;
}
// Search bar
@property(retain, nonatomic) UIView *headerView; // @synthesize headerView=_headerView;
// Hide Google logo mark
- (void)setWatermarkHidden:(_Bool)arg1 animated:(_Bool)arg2;
// Tap the bottom right circle button
- (void)didTapLocationButton:(id)arg1;
@end

@interface RootViewController ()
- (void)enterFollowingMode;
@end

RootViewController *rootViewController=nil;

%hook RootViewController
%new
- (void)enterFollowingMode {
#define TIME_ENTER_FOLLOWING_MODE 1.5
    NSTimer *timer = [NSTimer timerWithTimeInterval:TIME_ENTER_FOLLOWING_MODE repeats:NO
                                              block:^(NSTimer *timer){
                                                    [self didTapLocationButton:[%c(AZImages) locationButton]];
                                              }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//- (void)viewDidLoad{
- (void)viewWillAppear:(BOOL)arg1 {
    %orig;
    
    [self setWatermarkHidden:YES animated:NO];
    
    rootViewController=self;
    
    if (autoFollowingMode){
        [self enterFollowingMode];
    }
    
#pragma mark - Search Bar related
    
    [self.headerView setAlpha:alphaOfSearchBar];
}
%end

%hook AZUINavigationStateTransition
- (void)tweenHeaderView:(double)arg1 animating:(_Bool)arg2 {
    %orig;
    [rootViewController.headerView setAlpha:alphaOfSearchBar];
}
%end

#pragma mark - Driving mode like camera related

struct Point2D {};

struct CameraPosition {
    float zoom_;
    float look_ahead_;
    struct Point2D target_;
    double viewing_angle_radians_;
    double bearing_radians_;
};

@interface Location : NSObject
@property(readonly, nonatomic) double heading;
@end

@interface AZVectorMapViewController : UIViewController
@property(nonatomic) float cameraLookAhead;
@property(nonatomic) double cameraViewingAngle;
@property(nonatomic) float cameraZoomLevel;
@property(nonatomic) double cameraBearing;
@property(readonly, nonatomic) _Bool gesturesInProgress; // @synthesize gesturesInProgress=_gesturesInProgress;

- (void) setBuildingsEnabled:(BOOL)arg1;
@end

#define FOLLOWING_MODE 50
%hook AZVectorMapViewController
- (void)vectorMapView:(id)arg1 didMoveFromCameraPosition:(const struct CameraPosition *)arg2 toCameraPosition:(const struct CameraPosition *)arg3 reason:(unsigned long long)arg4 {
    %orig;

    struct GMSVectorMapMode mapMode = MSHookIvar<struct GMSVectorMapMode>(rootViewController, "_lastLocationButtonMapMode");

    if (mapMode.mode_ == FOLLOWING_MODE && !self.gesturesInProgress) { // If it is 3D map
        self.cameraZoomLevel=cameraZoomLevelValue;
        self.cameraLookAhead=cameraLookAheadValue;
        self.cameraViewingAngle=cameraViewingAngleValue;
    }
}

#pragma mark - 3D buildings

- (void)viewDidLoad{
    %orig;
    [self setBuildingsEnabled:buildings3DMode];
}
%end

#pragma mark - Footer view related

@interface AZHomeScreenTabBar : UIView
@end

@interface AZHomeScreenTabBarController
@property(readonly, nonatomic) AZHomeScreenTabBar *tabBarView; // @synthesize tabBarView=_tabBarView;
@end

@interface AZUINavigationController
@property(readonly, nonatomic) AZHomeScreenTabBarController *tabBarController; // @synthesize tabBarController=_tabBarController;
@end

%hook AZUINavigationController
- (void)viewDidLoad {
    %orig;
    [self.tabBarController.tabBarView setAlpha:alphaOfFooterTabBar];
}
%end

#pragma mark - Route Guidance Header View related

@interface GMSNHeaderView
@property(copy, nonatomic) UIColor *primaryBackgroundColor;
@property(copy, nonatomic) UIColor *secondaryBackgroundColor;
@property(copy, nonatomic) UIColor *stepSeparationColor;
@end

@interface AZNavStandardHeaderViewController
@property(readonly, nonatomic) GMSNHeaderView *headerView; // @synthesize headerView=_headerView;
@property(nonatomic) _Bool useTranslucentBackground; // @synthesize useTranslucentBackground=_useTranslucentBackground;

@end

%hook AZNavStandardHeaderViewController
- (void)viewDidLoad {
    %orig;

    if (translucentRouteGuidanceHeaderMode) {
        self.useTranslucentBackground=YES;

        UIColor* lastPrimaryColor = self.headerView.primaryBackgroundColor;
        self.headerView.primaryBackgroundColor = [lastPrimaryColor colorWithAlphaComponent:alphaOfRouteGuidanceHeader];

        UIColor* lastSecondaryColor = self.headerView.secondaryBackgroundColor;
        self.headerView.secondaryBackgroundColor = [lastSecondaryColor colorWithAlphaComponent:alphaOfRouteGuidanceHeader];

        UIColor* lastStepSeparationColor = self.headerView.stepSeparationColor;
        self.headerView.stepSeparationColor = [lastStepSeparationColor colorWithAlphaComponent:alphaOfRouteGuidanceHeader];
    }
}
%end


#pragma mark - Route Guidance Footer View related
@interface AZBackgroundLayerManager
@property(copy, nonatomic) UIColor *backgroundColor; // @synthesize backgroundColor=_backgroundColor;
@property(copy, nonatomic) UIColor *backgroundColorForNightMode; // @synthesize backgroundColorForNightMode=_backgroundColorForNightMode;
@end

@interface AZNavFooterContainerView : UIView
{
    AZBackgroundLayerManager *_backgroundLayerManager;
}
@end

@interface AZNavFooterViewController
@property(readonly, nonatomic) AZNavFooterContainerView *containerView; // @synthesize containerView=_containerView;

@property(nonatomic) _Bool useTranslucentBackground; // @synthesize useTranslucentBackground=_useTranslucentBackground;

@end

%hook AZNavFooterViewController
- (void)viewDidLoad {
    %orig;

    if (translucentRouteGuidanceFooterMode){
        self.useTranslucentBackground = YES;

        AZBackgroundLayerManager *ivar_backgroundLayerManager = MSHookIvar<AZBackgroundLayerManager*>(self.containerView, "_backgroundLayerManager");

        UIColor* lastColor = ivar_backgroundLayerManager.backgroundColor;
        ivar_backgroundLayerManager.backgroundColor = [lastColor colorWithAlphaComponent:alphaOfRouteGuidanceHeader];
    }
}
%end

@interface GMSNFooterRouteSummaryView : UIView
{
    UILabel *_arrivalTimeLabel;
}
@end

%hook GMSNFooterRouteSummaryView
- (void)updateTextColor {
    %orig;

    UILabel *ivar_arrivalTimeLabel = MSHookIvar<UILabel*>(self, "_arrivalTimeLabel");
    ivar_arrivalTimeLabel.textColor = UIColor.whiteColor;
}
%end

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.b01s.googlemapsenhancer/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
    
    if(tweakEnabled) %init;
}

