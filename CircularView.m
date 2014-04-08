//
//  CircularView.m
//  project2
//
//  Created by luci on 12/4/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "CircularView.h"
#import "CircularPoints.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookViewController.h"

@interface CircularView()

@property BOOL animatedUpRight;
@property BOOL animatedDownRight;
@property BOOL animatedUpLeft;
@property BOOL animatedDownLeft;

@end
@implementation CircularView

#define PI 3.14159265359

-(void)setup
{
    self.animatedDownLeft = NO;
    self.animatedDownRight = NO;
    self.animatedUpLeft = NO;
    self.animatedUpRight = NO;
}
-(void)awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
        
    }
    return self;
}
-(void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized ||
        gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged)
    {
        _touchPoint = [gesture locationInView:self];
        [gesture translationInView:self];
        _velocity = [gesture velocityInView:self];
        [self performRotation:_velocity];
    }
    
    /*  HANDLE INERTIA
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self endAnimation];
    }
     */
}
-(void)endAnimation {
    if (self.animatedDownLeft) {
        return;
    }
    if (self.animatedDownRight) {
        
        return;
    }
    if (self.animatedUpLeft) {
        
        return;
    }
    if (self.animatedUpRight) {
        
        return;
    }
}
-(NSMutableArray*)createButtons
{
    self.btnarray = [[NSMutableArray alloc]
                     initWithObjects:_user1,_user2,_user4,_user5,_user6,_user7, nil];
    [_btnarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        btn.alpha = 0;
        btn.tag = idx;
    }];
    return _btnarray;
}

-(void)fadeOut
{
    [_btnarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:1 animations:^{
            UIButton* btn = obj;
            [btn setCenter:CGPointMake(arc4random_uniform(400), arc4random_uniform(400))];
            btn.alpha = 0;
        } completion:^(BOOL finished) {
            self.hasAnimated = NO;
        }];
        
    }];
}
-(void)adjustButtonVisibility : (UIButton*) btn : (int) alpha
{
    if (alpha==1) {
        [UIView animateWithDuration:1 animations:^{
            btn.alpha=1;
        }];
    }
    else {
        [UIView animateWithDuration:1 animations:^{
            btn.alpha = 0;
        }];
    }
}

-(void)animateDownRight:(CGPoint)velocity
{
    [UIView animateWithDuration:.5 delay:0 options: UIViewAnimationOptionBeginFromCurrentState animations:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_touchPoint.x<_centerPoint.x && _touchPoint.y<_centerPoint.y){             //#2
                 if (velocity.x>0 && velocity.y==0) {
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y>0 && velocity.x==0){
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 }/*
                   else if(_touchPoint.x>=_centerPoint.x-85){
                   [self rotate:1];
                   }
                   else if (_touchPoint.x<=_centerPoint.x-175){
                   [self rotate:-1];
                   }*/
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y>_centerPoint.y){         //#4
                 if (velocity.x>0 && velocity.y==0) {
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y>0 && velocity.x==0){
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 }/*
                   else if(_touchPoint.x<=_centerPoint.x+85){
                   [self rotate:-1];
                   }
                   else if (_touchPoint.x>=_centerPoint.x+175){
                   [self rotate:1];
                   }*/
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y<_centerPoint.y){             //#1
                 [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
             }
             else if(_touchPoint.x<_centerPoint.x && _touchPoint.y>_centerPoint.y){         //#3
                 [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
             }
         });
     }
                     completion:^(BOOL finished) {  }
     ];
}
-(void)animateUpLeft:(CGPoint)velocity
{
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_touchPoint.x<_centerPoint.x && _touchPoint.y<_centerPoint.y){             //#2
                 if (velocity.x<0 && velocity.y==0) {
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y<0 && velocity.x==0){
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 }/*
                   else if(_touchPoint.x>=_centerPoint.x-85){
                   [self rotate:-1];
                   }
                   else if (_touchPoint.x<=_centerPoint.x-175){
                   [self rotate:1];
                   }*/
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y>_centerPoint.y){             //#4
                 if (velocity.x<0 && velocity.y==0) {
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y<0 && velocity.x==0){
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 }/*
                   else if(_touchPoint.x<=_centerPoint.x+85){
                   [self rotate:1];
                   }
                   else if (_touchPoint.x>=_centerPoint.x+175){
                   [self rotate:-1];
                   }*/
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y<_centerPoint.y){         //#1
                 [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
             }
             else if(_touchPoint.x<_centerPoint.x && _touchPoint.y>_centerPoint.y){         //#3
                 [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
             }
         });
     }
                     completion:^(BOOL finished) {  }
     ];
}
-(void)animateUpRight:(CGPoint)velocity
{
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_touchPoint.x<_centerPoint.x && _touchPoint.y<_centerPoint.y){     //      #2
                 [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y>_centerPoint.y){     //      #4
                 [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y<_centerPoint.y){     //      #1
                 if (velocity.x>0 && velocity.y==0) {
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y<0 && velocity.x==0){
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 }/*
                   else if(_touchPoint.x<=_centerPoint.x+85){
                   [self rotate:1];
                   }
                   else if (_touchPoint.x>=_centerPoint.x+175){
                   [self rotate:-1];
                   }*/
             }
             else if(_touchPoint.x<_centerPoint.x && _touchPoint.y>_centerPoint.y){     //      #3
                 if (velocity.x>0 && velocity.y==0) {
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y<0 && velocity.x==0){
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 }/*
                   else if(_touchPoint.x<=_centerPoint.x-175){
                   [self rotate:1];
                   }
                   else if (_touchPoint.x>=_centerPoint.x-85){
                   [self rotate:-1];
                   }*/
             }
         });
     }
                     completion:^(BOOL finished) {  }
     ];
    
}
-(void)animateDownLeft:(CGPoint)velocity
{
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_touchPoint.x<_centerPoint.x && _touchPoint.y<_centerPoint.y){                 // Quadrant #2
                 [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y>_centerPoint.y){             // Quadrant #4
                 [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
             }
             else if(_touchPoint.x>_centerPoint.x && _touchPoint.y<_centerPoint.y){             // Quadrant #1
                 if (velocity.x<0&&velocity.y==0) {
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y>0&&velocity.x==0){
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 }
                 /*
                  else if(_touchPoint.x<=_centerPoint.x+85){
                  [self rotate:-1];
                  }
                  else if (_touchPoint.x>=_centerPoint.x+175){
                  [self rotate:1];
                  }
                  */
             }
             else if(_touchPoint.x<_centerPoint.x && _touchPoint.y>_centerPoint.y){            // Quadrant #3
                 if (velocity.x<0&&velocity.y==0) {
                     [CircularPoints rotate:1 :self.btnarray :_angles :_centerPoint];
                 } else if(velocity.y>0&&velocity.x==0){
                     [CircularPoints rotate:-1 :self.btnarray :_angles :_centerPoint];
                 }
                 /*  else if(_touchPoint.x<=_centerPoint.x-175){
                  [self rotate:-1];
                  }
                  else if (_touchPoint.x>=_centerPoint.x-85){
                  [self rotate:.1];
                  }
                  */
             }
         });
     }
                     completion:^(BOOL finished) {  }
     ];
    
}

-(void)finalizeAnimatedState : (BOOL) animated   //Under construction (INERTIA)
{
    self.animatedDownLeft = NO;
    self.animatedDownRight = NO;
    self.animatedUpLeft = NO;
    self.animatedUpRight = NO;
    //animated = YES;
}
-(void)animate:(CGPoint)vel :(int)speed {
    for (int i=0; i<speed; i++) {
        if (vel.x>=0 && vel.y>=0) {                             //  >^ (DOWN-RIGHT)
            [self animateDownRight:vel];
            [self finalizeAnimatedState:_animatedDownRight];
        }
        else
            if(vel.x<=0 && vel.y<=0) {                         //  <^ (UP-LEFT)
                [self animateUpLeft:vel];
                [self finalizeAnimatedState:_animatedUpLeft];
            }
            else
                if(vel.x>=0 && vel.y<=0) {                        // ^> (UP-RIGHT)
                    [self animateUpRight:vel];
                    [self finalizeAnimatedState:_animatedUpRight];
                }
                else
                    if(vel.x<=0 && vel.y>=0) {                          // <. DOWN-LEFT
                        [self animateDownLeft:vel];
                        [self finalizeAnimatedState:_animatedDownLeft];
                    }
    }
}
-(void)performRotation:(CGPoint)vel
{
    if (fabsf(vel.x)>fabsf(vel.y)) {
        [self animate:vel:fabsf(vel.x/20)];
    }
    else
        [self animate:vel:fabsf(vel.y)/20];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}


@end
