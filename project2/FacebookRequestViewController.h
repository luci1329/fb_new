//
//  FBProfileViewController.h
//  project2
//
//  Created by luci on 2/21/14.
//  Copyright (c) 2014 luci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookRequestViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *profile_name;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profile_IMG;
@property (strong, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong,atomic) NSMutableArray* poze;

@property (strong, nonatomic) IBOutlet UIImageView *fbImageView;


-(void)getTimelineForUser: (NSString*)user;
-(NSArray*)fetchMyData: (NSString*)data : (NSString*)access_token;
-(NSArray*)getAlbumPhotos:(NSString*)acces_token;

@end
