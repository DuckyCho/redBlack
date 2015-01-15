//
//  Node.h
//  redBlack
//
//  Created by Ducky on 2015. 1. 1..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BLACK_HEX 0x0C274D
#define RED_HEX 0xEF4089
typedef enum{BLACK_INT, RED_INT} nodeColor;

@interface Node : UIButton
{
@public
    BOOL isAnimationEnd;
}
@property(readwrite)NSUInteger color_int;
@property(readwrite)NSUInteger value;
@property(readwrite)NSUInteger height;
@property(readwrite)Node * dad;
@property(readwrite)Node * left;
@property(readwrite)Node * right;

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIColor *color;

-(id)initWithValue:(NSUInteger)valueNum;
-(void)drawCircleButton:(UIColor *)newColor;
-(void)moveXpos:(float)difference;
-(void)aniDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end
