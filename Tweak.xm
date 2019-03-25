static BOOL wantsHomeBar = YES;

// Enable home gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
		return 2;
}
%end

// Hide Camera and Flashlight Button on Coversheet
%hook SBDashBoardQuickActionsViewController	
	-(BOOL)hasFlashlight{
		return NO;
		}
	-(BOOL)hasCamera{
		return NO;
}
%end

//Statusbar
%hook _UIStatusBarVisualProvider_iOS
+ (Class)class {
    return NSClassFromString(@"_UIStatusBarVisualProvider_Split58");
}
%end
@interface _UIStatusBar
+ (void)setVisualProviderClass:(Class)classOb;
@end

%hook UIStatusBarWindow
+ (void)setStatusBar:(Class)arg1 {
    %orig(NSClassFromString(@"UIStatusBar_Modern"));
}
%end

%hook UIStatusBar_Base
+ (Class)_implementationClass {
    return NSClassFromString(@"UIStatusBar_Modern");
}
+ (void)_setImplementationClass:(Class)arg1 {
    %orig(NSClassFromString(@"UIStatusBar_Modern"));
}
%end

//Keyboard
%hook UIRemoteKeyboardWindowHosted
- (UIEdgeInsets)safeAreaInsets {
    UIEdgeInsets orig = %orig;
    orig.bottom = 44;
    return orig;
}
%end

%hook UIKeyboardImpl
+(UIEdgeInsets)deviceSpecificPaddingForInterfaceOrientation:(NSInteger)orientation inputMode:(id)mode {
    UIEdgeInsets orig = %orig;
    orig.bottom = 44;
    return orig;
}

%end

@interface UIKeyboardDockView : UIView
@end

%hook UIKeyboardDockView

- (CGRect)bounds {
    CGRect bounds = %orig;
    if (bounds.origin.y == 0) {
        bounds.origin.y -=13;
    }
    return bounds;
}

- (void)layoutSubviews {
    %orig;
}

%end

%hook UIInputWindowController
- (UIEdgeInsets)_viewSafeAreaInsetsFromScene {
    return UIEdgeInsetsMake(0,0,44,0);
}
%end


/Homebar
%hook UIScreen
- (UIEdgeInsets)_sceneSafeAreaInsets {
	UIEdgeInsets orig = %orig;
	if (orig.bottom == 34) orig.bottom = wantsHomeBar ? bottomBarInset : 0;
	return orig;
}
%end

%hook UIRemoteKeyboardWindowHosted
- (UIEdgeInsets)safeAreaInsets {
	UIEdgeInsets orig = %orig;
	orig.bottom = wantsKeyboardDock ? 44 : (wantsHomeBar ? bottomBarInset : 0);	
	return orig;
}
%end

%hook UIScreen
+ (UIEdgeInsets)sc_safeAreaInsets {
	UIEdgeInsets orig = %orig;
	orig.top = 0;
	orig.bottom = wantsHomeBar ? [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets].bottom : 0;
	return orig;
}

+ (UIEdgeInsets)sc_safeAreaInsetsForInterfaceOrientation:(UIInterfaceOrientation)orientation {
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		UIEdgeInsets insets = [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets];
		return UIEdgeInsetsMake(0, wantsStatusBar ? insets.top : 20, 0, wantsHomeBar ? insets.bottom : 0);
	} else {
		UIEdgeInsets orig = %orig;
		orig.top = 0;
		orig.bottom = wantsHomeBar ? [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets].bottom : 0;
		return orig;
	}
}

+ (UIEdgeInsets)sc_visualSafeInsets {
 	UIEdgeInsets orig = %orig;
	orig.top = 0;
	orig.bottom = wantsHomeBar ? [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets].bottom : 0;
	return orig;
}

+ (UIEdgeInsets)sc_filterSafeInsets {
 	UIEdgeInsets insets = [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets];
	return UIEdgeInsetsMake(wantsStatusBar ? insets.top : 20,0,0,0);
}

+ (UIEdgeInsets)sc_headerSafeInsets {
	UIEdgeInsets insets = [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets];
	return UIEdgeInsetsMake(wantsStatusBar ? insets.top : 20,0,0,0);
}

+ (UIEdgeInsets)sc_safeFooterButtonInset {
	UIEdgeInsets insets = [[NSClassFromString(@"UIScreen") mainScreen] _sceneSafeAreaInsets];
	return %orig;
}

+ (CGFloat)sc_headerHeight {
	CGFloat orig = %orig;
	return orig;
}
%end
%hook UIWindow
- (UIEdgeInsets)safeAreaInsets {
	UIEdgeInsets orig = %orig;
	if (orig.top > 30) orig.bottom = wantsHomeBar ? bottomBarInset : 0;
	else {
		if (orig.left < 10) orig.left = wantsHomeBar ? bottomBarInset : 0;
		else if (orig.right < 10) orig.right = wantsHomeBar ? bottomBarInset : 0; 
	}
	return orig;
}
%end
