//
//  CircularButtons.m
//  project2
//
//  Created by luci on 10/13/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "CircularPoints.h"


@implementation CircularPoints

#define PI 3.14159265359
#define radius 100

+(NSMutableArray*)adjustCirclePoints:(CGPoint) centerPoint
{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    CGFloat circleLength = 2*PI*radius;
    CGFloat radian = 1*PI/180;
    CGFloat distance = radius * sinf(radian);
    int nrOfPoints = circleLength/distance;
    CGFloat alpha =PI *2/nrOfPoints;
    for (int i=0; i<nrOfPoints; i++) {
        CGFloat tetha = alpha * i;
        CGPoint point;
        point.x = cosf(tetha) * radius +centerPoint.x;
        point.y = sinf(tetha) * radius +centerPoint.y;
        NSValue * finalPoint = [NSValue valueWithCGPoint:point];
        [points addObject:finalPoint];
    }
    return points;
}
+(NSMutableArray*)findNextAngles:(int)numberOfButtons :(CGPoint) centerPoint
{
    CGPoint point;
    NSMutableArray* angles = [[NSMutableArray alloc] initWithCapacity:numberOfButtons];
    CGFloat beta = PI *2/numberOfButtons;
    CGFloat tetha;
    for (int i=0;i<numberOfButtons;i++){
        tetha = beta*i;
        point.x = cosf(tetha) * radius +centerPoint.x;
        point.y = sinf(tetha) * radius +centerPoint.y;
        NSNumber * val = [NSNumber numberWithFloat:tetha];
        [angles addObject:val];
    }
    return angles;
}
+(void)rotate:(int)direction : (NSArray *) array : (NSMutableArray*) angles :(CGPoint) centerPoint
{
    [array enumerateObjectsUsingBlock:^(id currentButton,NSUInteger pos,BOOL *stop){
        UIButton* tmp = [array objectAtIndex:pos];
        NSNumber * val = [angles objectAtIndex:pos];
        CGFloat alpha =  2*PI/360;
        CGFloat tetha;
        CGPoint nextPoint;
        if (direction>0) {
            tetha = [val floatValue]+alpha;
            nextPoint.x = cosf(tetha)*100+centerPoint.x;
            nextPoint.y = sinf(tetha)*100+centerPoint.y;
            nextPoint = CGPointMake(nextPoint.x, nextPoint.y);
            [tmp setCenter:CGPointMake(nextPoint.x, nextPoint.y)];
            val = [NSNumber numberWithFloat:tetha];;
            [angles setObject:val atIndexedSubscript:pos];
        } else {
            tetha = [val floatValue]-alpha;
            nextPoint.x = cosf(tetha)*100+centerPoint.x;
            nextPoint.y = sinf(tetha)*100+centerPoint.y;
            nextPoint = CGPointMake(nextPoint.x, nextPoint.y);
            [tmp setCenter:nextPoint];
            val = [NSNumber numberWithFloat:tetha];;
            [angles setObject:val atIndexedSubscript:pos];
        }
    }];
}
@end