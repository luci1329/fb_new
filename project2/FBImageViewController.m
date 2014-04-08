//
//  FBImageViewController.m
//  project2
//
//  Created by luci on 4/7/14.
//  Copyright (c) 2014 luci. All rights reserved.
//

#import "FBImageViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FBImageViewController ()
@property int currentIndex;
@end

@implementation FBImageViewController

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
    NSURL* url = [NSURL URLWithString:[self.urlArray objectAtIndex:0]];
    self.currentIndex = 0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self requestImage:url];
    self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",self.currentIndex+1,self.urlArray.count];
}
     
-(void)requestImage:(NSURL*) url
{
    __block NSData* urlImageData;
    __block UIImage* img;
    dispatch_queue_t download = dispatch_queue_create("download image", NULL);
    dispatch_async(download, ^{
        urlImageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
                img = [UIImage imageWithData:urlImageData];
                [self.imageView setImage:img];
        });
    });
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)prevPressed:(id)sender {
    if (self.currentIndex>0) {
        NSURL* url = [NSURL URLWithString:[self.urlArray objectAtIndex:self.currentIndex-1]];
            [self requestImage:url];
        self.currentIndex--;
        self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",self.currentIndex+1,self.urlArray.count];
    }
}
- (IBAction)nextPressed:(id)sender {
    if (self.currentIndex<self.urlArray.count-1) {
        NSURL* url = [NSURL URLWithString:[self.urlArray objectAtIndex:self.currentIndex+1]];
            [self requestImage:url];
        self.currentIndex++;
        self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",self.currentIndex+1,self.urlArray.count];
    }
}


@end
