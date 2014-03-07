//
//  luciAppDelegate.h
//  project2
//
//  Created by io on 9/25/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
/*
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0


#else

*/
@interface mainAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) MainViewController* mainVC;
-(int)openSession;

@end

//"FacebookSDK/FacebookSDK.framework/Headers/FacebookSDK.h"#endif