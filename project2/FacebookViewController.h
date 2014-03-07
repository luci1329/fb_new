//
//  FacebookViewController.h
//  project2
//
//  Created by luci on 10/20/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "MainViewController.h"
#import "CircularView.h"

@interface FacebookViewController : UIViewController

-(NSMutableArray*)animateButtons;
-(void)setAccessToken:(NSString*)token;

@end
