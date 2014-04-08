//
//  FBProfileViewController.m
//  project2
//
//  Created by luci on 2/21/14.
//  Copyright (c) 2014 luci. All rights reserved.
//

#import "FacebookRequestViewController.h"
#import "FBImageViewController.h"
#import <Foundation/Foundation.h>

@interface FacebookRequestViewController ()
@property (nonatomic,strong) NSMutableArray* albumArray;
@property (nonatomic,strong) NSMutableArray* photos;
@end

@implementation FacebookRequestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataTableView setDataSource:self];
    [self.dataTableView setDelegate:self];
    [self.dataTableView setSeparatorInset:UIEdgeInsetsZero];
    [self showProfile];
    self.photos = [[NSMutableArray alloc] init];
    //self.dataTableView.backgroundColor = self.view.backgroundColor;
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
    FBRequest *feedRequest = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@?fields=cover,first_name,last_name,relationship_status,feed",user] parameters:nil HTTPMethod:nil];
    [feedRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (!error) {
            _poze = [[NSMutableArray alloc] init];
            NSArray * tmp = [[NSArray alloc] initWithArray:[result valueForKeyPath:@"feed.data.picture"]];
            for (int i=0;i<tmp.count;i++) {
                [_poze addObject:[result valueForKey:@"id"]];
            }
            NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[result valueForKeyPath:@"feed.data.story"]];
            self.dataSource = [[NSMutableArray alloc] init];
            [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (![obj isKindOfClass:[NSNull class]]) {
                    [self.dataSource addObject:obj];
                }
            }];
            [self.dataTableView reloadData];
        }
        else NSLog(@"request error %@",[error localizedDescription]);
    }];
}

-(NSArray*)getAlbumPhotos:(NSString*)acces_token
{
    NSArray *jsonObjects = [[NSArray alloc]init];
    __block NSError *error;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/albums?&access_token=%@",acces_token]];
    NSString *json = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        jsonObjects = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        //self.albumArray = [jsonObjects valueForKeyPath:@"data.id"];
        
    }
    self.dataSource = [jsonObjects valueForKeyPath:@"data.name"];
    self.poze = [jsonObjects valueForKeyPath:@"data.cover_photo"];
    if (!self.albumArray) {
        self.albumArray = [[NSMutableArray alloc] init];
    }
    [[jsonObjects valueForKeyPath:@"data.id"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSURL *photosURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?fields=source&access_token=%@",obj,acces_token]];
        NSString *jsonPhotos = [[NSString alloc] initWithContentsOfURL:photosURL encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *tmp = [NSJSONSerialization JSONObjectWithData:[jsonPhotos dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        [self.albumArray addObject:[tmp valueForKeyPath:@"data.source"]];
    }];
    return self.albumArray;
}
-(NSArray*)fetchMyData :(NSString*) data :(NSString*)access_token {
    NSError* error = nil;
    NSArray *jsonObjects;
    _poze = [[NSMutableArray alloc]init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/%@?access_token=%@",data,access_token]];
    NSString *json = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        jsonObjects = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        self.dataSource = [jsonObjects valueForKeyPath:@"data.name"];
        _poze = [[NSMutableArray alloc] initWithArray:[jsonObjects valueForKeyPath:@"data.id"]];
        [self.dataTableView reloadData];
    }
    else {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    return jsonObjects;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
   /*
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        UILabel *textLabel = [[UILabel alloc]init];
        [textLabel setNumberOfLines:0];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        NSString* text = [self.dataSource objectAtIndex:indexPath.row];
        textLabel.text = text;
        [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        textLabel.textAlignment = NSTextAlignmentLeft;
        NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: textLabel.font}];
       
        
        //handle picture
        CGFloat pos = (cell.textLabel.frame.size.height - cell.imageView.frame.size.height);
        CGRect imageViewRect = CGRectMake(cell.imageView.frame.origin.x, pos, 50, 50);
        cell.imageView.frame = imageViewRect;
        //cell.backgroundColor = self.view.backgroundColor;
        if (_poze.count>0) {
            if (![[_poze objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
                NSURL *testUrl = [NSURL URLWithString:[_poze objectAtIndex:indexPath.row]];
                if ([NSURLConnection canHandleRequest:[NSURLRequest requestWithURL:testUrl]]) {
                    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:testUrl]];
                    [cell.imageView setImage:img];
                }
                else {
                    NSString *picURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?",[_poze objectAtIndex:indexPath.row]];
                    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    [cell.imageView setImage:img];
                }
            }
            else {
                [cell.imageView setImage:[UIImage imageNamed:@"facebook.png"]];
            }
        }
        else {
            [cell.imageView setImage:[UIImage imageNamed:@"facebook.png"]];
        }
        CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(self.view.frame.size.width-(cell.imageView.image.size.width + 25), cell.textLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        if (self.dataTableView.tag == 1) {
            rect.origin.x = cell.imageView.frame.size.width + 60;
            rect.origin.y = cell.imageView.frame.origin.y+cell.imageView.frame.size.height/4.5;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:@">" forState:UIControlStateNormal];
            [btn setTag:indexPath.row];
            btn.frame = CGRectMake(self.view.frame.size.width-50,cell.frame.size.height-50, 50, 50);
            [btn addTarget:self action:@selector(albumInfoPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
        else {
            rect.origin.x = cell.frame.size.width - (self.view.frame.size.width - cell.imageView.image.size.width -20);
            rect.origin.y = cell.imageView.frame.origin.y+cell.imageView.frame.size.height/4.5;
        }
        textLabel.frame = rect;
        [cell addSubview:textLabel];
        return cell;
    }
    else return cell;
    */
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    UILabel *textLabel = [[UILabel alloc]init];
    [textLabel setNumberOfLines:0];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    NSString* text = [self.dataSource objectAtIndex:indexPath.row];
    textLabel.text = text;
    [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    textLabel.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: textLabel.font}];
    
    
    //handle picture
    CGFloat pos = (cell.textLabel.frame.size.height - cell.imageView.frame.size.height);
    CGRect imageViewRect = CGRectMake(cell.imageView.frame.origin.x, pos, 50, 50);
    cell.imageView.frame = imageViewRect;
    //cell.backgroundColor = self.view.backgroundColor;
    if (_poze.count>0) {
        if (![[_poze objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            NSURL *testUrl = [NSURL URLWithString:[_poze objectAtIndex:indexPath.row]];
            if ([NSURLConnection canHandleRequest:[NSURLRequest requestWithURL:testUrl]]) {
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:testUrl]];
                [cell.imageView setImage:img];
            }
            else {
                NSString *picURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?",[_poze objectAtIndex:indexPath.row]];
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [cell.imageView setImage:img];
            }
        }
        else {
            [cell.imageView setImage:[UIImage imageNamed:@"facebook.png"]];
        }
    }
    else {
        [cell.imageView setImage:[UIImage imageNamed:@"facebook.png"]];
    }
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(self.view.frame.size.width-(cell.imageView.image.size.width + 25), cell.textLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (self.dataTableView.tag == 1) {
        rect.origin.x = cell.imageView.frame.size.width + 60;
        rect.origin.y = cell.imageView.frame.origin.y+cell.imageView.frame.size.height/4.5;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@">" forState:UIControlStateNormal];
        [btn setTag:indexPath.row];
        btn.frame = CGRectMake(self.view.frame.size.width-50,cell.frame.size.height-50, 50, 50);
        [btn addTarget:self action:@selector(albumInfoPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    else {
        rect.origin.x = cell.frame.size.width - (self.view.frame.size.width - cell.imageView.image.size.width -20);
        rect.origin.y = cell.imageView.frame.origin.y+cell.imageView.frame.size.height/4.5;
    }
    textLabel.frame = rect;
    [cell addSubview:textLabel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = [self.dataSource objectAtIndex:indexPath.row];
    return [self heightForText:text];
}

-(CGFloat)heightForText:(NSString*)text
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, CGFLOAT_MAX)];
    textView.text = text;
    textView.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [textView sizeToFit];
    if (textView.frame.size.height < 55) {
        return 55;
    }
    else return textView.frame.size.height;
}
-(IBAction)albumInfoPressed:(id)sender
{
    [self performSegueWithIdentifier:@"Images" sender:sender];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton* btn = sender;
    [segue.destinationViewController setUrlArray:[self.albumArray objectAtIndex:btn.tag]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
