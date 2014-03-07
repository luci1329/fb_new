//
//  FacebookLoginViewController.m
//  project2
//
//  Created by luci on 11/20/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "FacebookLoginViewController.h"
#import "FacebookViewController.h"
#import "luciAppDelegate.h"
@interface FacebookLoginViewController ()
@property (weak,nonatomic) FBFriendPickerViewController* fbpk;
@property (weak,nonatomic) id<FBGraphUser> userDetails;
@property (retain,nonatomic) NSTimer * timer;

@end

@implementation FacebookLoginViewController
@synthesize timer = _timer;
@synthesize profileImage = _profileImage;
@synthesize fbpk = _fbpk;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.fbpick.hidden = YES;
    if ([[FBSession activeSession] isOpen]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTapped:)];

    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTapped:)];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(populateUserDetails) userInfo:nil repeats:YES];
    dispatch_queue_t sessionCheck = dispatch_queue_create("sessionCheck", NULL);
    dispatch_async(sessionCheck, ^{
        [self.timer fire];
    });
}
-(void)populateUserDetails
{
    NSLog(@"FIRE!");
    if ([[FBSession activeSession]isOpen]) {
        self.fbpick.hidden=NO;
        [[FBRequest requestForMe]startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error) {
            if (!error) {
                self.userDetails = result;
                self.user.text =[result name
                                 ];
                _profileImage.profileID = result.id;
                [self.spinner stopAnimating];
                self.loginBtn.hidden = YES;
            }
        }];
    }
    else {
        NSLog(@"Session is not open");
        self.loginBtn.hidden = NO;
        self.user.text = @"";
        self.userDetails = nil;
        _profileImage.profileID = nil;
        self.fbpick.hidden=YES;
    }
}

-(void) viewDidUnload {
    [self.timer invalidate];
}

-(IBAction)logoutButtonTapped:(id)sender
{
    if (!FBSession.activeSession.isOpen) {
        self.navigationItem.rightBarButtonItem.title = @"Logout";
        luciAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate openSession];
        [self.timer fire];
        [self.spinner startAnimating];
    }
    else {
        self.navigationItem.rightBarButtonItem.title = @"Login";
        [[FBSession activeSession] closeAndClearTokenInformation];
        self.loginBtn.hidden = NO;
        self.user.text = @"";
        self.userDetails = nil;
        [self.spinner stopAnimating];
        self.profileImage.hidden = YES;
    }
}
- (IBAction)fbpickTapped:(id)sender {
    FBFriendPickerViewController *fbpick = [[FBFriendPickerViewController alloc] init];
    [fbpick loadData];
    [fbpick presentModallyFromViewController:self animated:YES handler:nil];
}
-(void)performLogin:(id)sender {
    
}
-(void)loginFailed {
    
}

@end
