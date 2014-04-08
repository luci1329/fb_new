//
//  FBImageViewController.h
//  project2
//
//  Created by luci on 4/7/14.
//  Copyright (c) 2014 luci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *prev;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) NSArray* urlArray;
@end
