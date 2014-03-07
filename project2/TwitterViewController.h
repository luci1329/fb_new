//
//  TweetListViewController.h
//  project2
//
//  Created by luci on 10/13/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface TwitterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *userName;

- (void)getTimeLine: (ACAccountType*)accountType :(NSURL*)requestURL :(NSDictionary*)parameters;
@end

