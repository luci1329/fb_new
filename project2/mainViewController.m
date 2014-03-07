//
//  luciViewController.m
//  project2
//
//  Created by io on 9/25/13.
//  Copyright (c) 2013 luci. All rights reserved.
//
#import "UIKit/UIKit.h"
#import "MainViewController.h"
#import "CircularPoints.h"
#import "TwitterViewController.h"
#import "FacebookViewController.h"
#import "mainAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController ()
@end

@implementation MainViewController

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.loginBtn.hidden = NO;
    self.spinner.hidesWhenStopped=YES;
}
-(void) viewDidUnload {
}
-(void)viewDidAppear:(BOOL)animated
{
    if (FBSession.activeSession.isOpen) {
        [self performSegueWithIdentifier:@"FBLoggedIn" sender:self];
        self.spinner.hidden = YES;
    }
    [self.spinner stopAnimating];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.spinner stopAnimating];
}

-(IBAction)logTapped:(id)sender {
    [self.spinner startAnimating];
    if (!FBSession.activeSession.isOpen) {
        mainAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
        int res = [appDelegate openSession];
        if (res==1) {
            NSLog(@"Successfuly logged in.");
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
        }
    }
    else if (FBSession.activeSession.isOpen) {
        [self performSegueWithIdentifier:@"FBLoggedIn" sender:sender];
        NSLog(@"Successfuly logged in.");
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FBLoggedIn"]) {
        FBSession *session = [FBSession activeSession];
        [segue.destinationViewController setAccessToken:[NSString stringWithFormat:@"%@",session.accessTokenData]];
    }
}

@end
