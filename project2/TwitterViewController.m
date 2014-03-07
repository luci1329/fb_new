//
//  TweetListViewController.m
//  project2
//
//  Created by luci on 10/13/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "TwitterViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


@interface TwitterViewController ()
@end

@implementation TwitterViewController

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tweetTableView setDataSource:self];
    [self.tweetTableView setDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (void)getTimeLine: (ACAccountType*) accountType :(NSURL*) requestURL :(NSDictionary*) params{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 _userName.text = [twitterAccount username];
                 NSURL *requestURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/home_timeline.json"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:params];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                      self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                      if (self.dataSource.count > 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tweetTableView reloadData];
                          });
                      }
                      else {
                          UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Info" message:@"No results returned."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
                          [alert show];
                      }
                  }];
             }
         } else {
             UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not get access to your twitter account!"
                                                      delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
             [alert show];
         }
     }];
}
-(void)getFacebookFriends
{
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UILabel *label=nil;
    UITableViewCell *cell = [self.tweetTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setMinimumScaleFactor:14.0f];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:14.0f]];
        [label setTag:1];
        [[cell contentView] addSubview:label];
    }
    NSDictionary *tweet = _dataSource[indexPath.row];
    NSString *currentCellText = tweet[@"text"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:[NSString stringWithFormat:@"%d.%@",indexPath.row+1,currentCellText]];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(constraint.height, 44.0f))];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSDictionary *tweet = _dataSource[indexPath.row];
    NSString * currentCellText = tweet[@"text"];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [currentCellText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(constraint.height, 44.0f);
    return height+CELL_CONTENT_MARGIN*2;
     */
    return 0;
}
@end
