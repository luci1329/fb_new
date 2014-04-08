//
//  CircularView.h
//  project2
//
//  Created by luci on 12/4/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularView : UIView

@property (weak, nonatomic) IBOutlet UIButton* user1;
@property (weak, nonatomic) IBOutlet UIButton* user2;
@property (weak, nonatomic) IBOutlet UIButton* user3;
@property (weak, nonatomic) IBOutlet UIButton* user4;
@property (weak, nonatomic) IBOutlet UIButton* user5;
@property (weak, nonatomic) IBOutlet UIButton* user6;
@property (weak, nonatomic) IBOutlet UIButton *user7;



@property NSMutableArray* circlePoints;
@property (nonatomic) NSMutableArray* btnarray;

-(void) pan : (UIGestureRecognizer*)gesture;
-(void)fadeOut;
@property CGPoint centerPoint;
@property CGPoint touchPoint;
@property NSMutableArray* angles;
@property BOOL hasAnimated;
@property CGPoint velocity;
-(NSMutableArray*)createButtons;


@end
