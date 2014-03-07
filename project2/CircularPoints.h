//
//  CircularButtons.h
//  project2
//
//  Created by luci on 10/13/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircularPoints : NSObject

+(NSMutableArray*)adjustCirclePoints:(CGPoint) centerPoint;
+(NSMutableArray*)findNextAngles:(int)numberOfButtons :(CGPoint) centerPoint;
+(void)rotate:(int)direction : (NSArray *) btnarray : (NSMutableArray*) angles :(CGPoint) centerPoint;
@end
