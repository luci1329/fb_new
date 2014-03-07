//
//  FacebookLoginViewController.h
//  project2
//
//  Created by luci on 11/20/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FacebookLoginViewController : UIViewController
- (IBAction)performLogin:(id)sender;
-(void)loginFailed;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *user;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *fbpick;
@property (weak, nonatomic) IBOutlet UIButton *fbplace;
@property (weak, nonatomic) IBOutlet UIButton *fbfriends;

@end
