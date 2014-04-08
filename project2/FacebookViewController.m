//
//  FacebookViewController.m
//  project2
//
//  Created by luci on 10/20/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "FacebookViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CircularView.h"
#import "CircularPoints.h"
#import "FacebookRequestViewController.h"
#import "FacebookRequestViewController.h"

@interface FacebookViewController ()

@property CGPoint centerPoint;
@property NSMutableArray * circlePoints;
@property (nonatomic,strong)NSMutableArray* angles;
@property BOOL hasAnimated;
@property NSMutableArray* btnarray;
@property (nonatomic,weak) IBOutlet CircularView * circularView;
@property (retain) NSTimer * timer;
@property NSString* access_token;

@end

@implementation FacebookViewController


-(void)setAccessToken:(NSString *)token
{
    _access_token = token;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_circularView) {
        [self facebookInit];
        [self setup];
        [self setView:_circularView];
    }
}
-(void)setupNavigationBar {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutTapped:)];
    [btn setEnabled:YES];
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(viewProfile:)];
    [btn setEnabled:YES];        [self setView:_circularView];
    
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithTitle:@"Requests" style:UIBarButtonItemStylePlain target:self action:@selector(viewRequests:)];
    [btn setEnabled:YES];
    UIBarButtonItem *btn3 = [[UIBarButtonItem alloc] initWithTitle:@"Messages" style:UIBarButtonItemStylePlain target:self action:@selector(viewConversations:)];
    [btn setEnabled:YES];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btn,btn1, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:btn2,btn3, nil];
    [self.navigationItem setHidesBackButton:YES];
}

-(void) viewDidUnload {
    [self.timer invalidate];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.timer fire];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (self.hasAnimated) {
        [_circularView.btnarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *btn = obj;
            if (btn.alpha==0) {
                btn.alpha=1;
                btn.transform = CGAffineTransformMakeScale(1, 1);
            }
        }];
    }
}
-(void)isLoggedIn
{
    if (!FBSession.activeSession.isOpen) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"No facebook connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [alert show];
        [self.timer invalidate];
    }
}
-(void)facebookInit
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(isLoggedIn) userInfo:nil repeats:YES];
}

- (IBAction)logoutTapped:(id)sender
{
    if (FBSession.activeSession.isOpen) {
        [[FBSession activeSession] closeAndClearTokenInformation];
        //[_circularView animateOut];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setup
{
    _circularView.centerPoint = CGPointMake(_circularView.center.x , _circularView.center.y);
    _circularView.circlePoints = [CircularPoints adjustCirclePoints:_circularView.centerPoint];
    _btnarray = [_circularView createButtons];
    _circlePoints = _circularView.circlePoints;
    _circularView.btnarray = [self animateButtons];
    _circularView.angles = _angles;
    UIGestureRecognizer *panThis =[[UIPanGestureRecognizer alloc]initWithTarget:self.circularView action:@selector(pan:)];
    [self.circularView addGestureRecognizer:panThis];
    [self setupNavigationBar];
}


-(NSMutableArray*)animateButtons
{
    [_btnarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSValue * value = _circlePoints[(idx+1)*359/_btnarray.count];
        UIButton* btn =obj;
        [btn setCenter:_circularView.centerPoint];
        btn.alpha = 0;
        CGPoint pt = value.CGPointValue;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void)
         {
             btn.alpha = 1;
             [btn setCenter:CGPointMake(pt.x, pt.y)];
         }
                         completion:^(BOOL finished) {
                         }
         ];
    }];
    self.angles = [CircularPoints findNextAngles:(int)_btnarray.count
                                                :_centerPoint];
    self.hasAnimated = YES;
    return _btnarray;
}
-(IBAction)userFeedTapped:(id)sender
{
    [self performSegueWithIdentifier:@"feedForFriend" sender:sender];
}
-(IBAction)loadTableViewWithSenderId:(id)sender
{
    [self performSegueWithIdentifier:@"populate" sender:sender];
}
-(IBAction)viewProfile:(id)sender
{
    [self performSegueWithIdentifier:@"Profile" sender:sender];
}
-(void)viewRequests:(id)sender
{
   // [self performSegueWithIdentifier:@"Requests" sender:sender];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"!" message:@"under construction" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}
-(IBAction)loadAlbums:(id)sender
{
    [self performSegueWithIdentifier:@"Albums" sender:sender];
}
-(void)viewConversations:(id)sender
{
   //[self performSegueWithIdentifier:@"Conversations" sender:sender];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"!" message:@"under construction" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [segue.destinationViewController getTimelineForUser:@"ghita.mariuslucian"];
            break;
        case 1:
            [segue.destinationViewController fetchMyData:@"Friends":_access_token];
            break;
        case 2:
            [segue.destinationViewController fetchMyData:@"Books":_access_token];
            break;
        case 3:
            [segue.destinationViewController fetchMyData:@"Likes":_access_token];
            break;
        case 4:
            [segue.destinationViewController fetchMyData:@"Movies":_access_token];
            break;
        case 5:
            [segue.destinationViewController getAlbumPhotos:_access_token];
            break;
        default:
            NSLog(@"sender tag unknown");
            break;
    }
}
@end
