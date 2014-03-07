//
//  FBProfileViewController.m
//  project2
//
//  Created by luci on 2/21/14.
//  Copyright (c) 2014 luci. All rights reserved.
//

#import "FacebookRequestViewController.h"
#import <Foundation/Foundation.h>

@interface FacebookRequestViewController ()

@end

@implementation FacebookRequestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.fbTimelineTableView setDataSource:self];
    [self.fbTimelineTableView setDelegate:self];
    [self showProfile];  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(void)showProfile
{
        [[FBRequest requestForMe]startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error) {
            if (!error) {
                self.profile_IMG.profileID = result.id;
                self.profile_name.text = result.name;
            }
            else NSLog(@"fbrequest error");
        }];
}
-(void)getTimelineForUser: (NSString*)user
{
    FBRequest *friendsRequest = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@?fields=cover,first_name,last_name,relationship_status,feed",user] parameters:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"en_EN", @"locale", nil] HTTPMethod:nil];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        
        self.dataSource = [[NSMutableArray alloc] initWithArray:[result valueForKeyPath:@"feed.data.story"]];
        [self.fbTimelineTableView reloadData];
    }];
}
-(NSArray*)fetchMyData :(NSString*) data :(NSString*)access_token {
    NSError* error = nil;
    NSArray *jsonObjects;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/%@?access_token=%@",data,access_token]];
    NSString *json = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        jsonObjects = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        NSLog(@"%@",jsonObjects);
        self.dataSource = [jsonObjects valueForKeyPath:@"data.name"];
        [self.fbTimelineTableView reloadData];
    }
    else {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    return jsonObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSString* text = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
