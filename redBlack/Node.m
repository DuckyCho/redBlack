//
//  Node.m
//  redBlack
//
//  Created by Ducky on 2015. 1. 1..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import "Node.h"

@implementation Node

@synthesize color;
@synthesize value;
@synthesize height;
@synthesize dad;
@synthesize left;
@synthesize right;


-(id)initWithValue:(NSUInteger)valueNum{
    if([super init]){
        value = valueNum;
        _color_int = RED_INT;
        self.frame = CGRectMake(0, 0, 20, 20);
        [self drawCircleButton:UIColorFromRGB(RED_HEX)];
        [self setTitle:[NSString stringWithFormat:@"%d",value] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setHeight:0];
        [self addTarget:self action:@selector(touchesEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nodeDelete" object:self];
}
-(void)checkPosDoubled:(NSNotification *)noti{
    Node * node = noti.object;
    if(node.value != self.value)
        NSLog(@"%@",node);
}

-(void)modifyParentNodePos{
    Node * uncle;
    if(dad.dad.left == dad){
        uncle = dad.dad.right;
        [dad moveXpos:-(self.frame.size.width*0.8)];
        [uncle moveXpos:self.frame.size.width*0.8];
    }
    else{
        uncle = dad.dad.left;
        [dad moveXpos:self.frame.size.width*0.8];
        [uncle moveXpos:-(self.frame.size.width*0.8)];
    }
}
-(void)moveXpos:(float)difference{
    [UIView beginAnimations:@"moveXPos" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(aniDidStop:finished:context:)];
    [UIView setAnimationDuration:1.0f];
    CGPoint newLeftCenter = CGPointMake( difference + self.center.x, self.center.y);
    self.center = newLeftCenter;
    [UIView commitAnimations];
}

-(void)aniDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"redrawEdge" object:self];
}

-(void)drawCircleButton:(UIColor *)newColor
{
    self.color = newColor;
    [self setTitleColor:color forState:UIControlStateNormal];
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,[self bounds].size.height)];
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.circleLayer setPath:[path CGPath]];
    [self.circleLayer setStrokeColor:[color CGColor]];
    [self.circleLayer setLineWidth:2.0f];
    [self.circleLayer setFillColor:[newColor CGColor]];
    [[self layer] addSublayer:self.circleLayer];
}

-(void)setHighlighted:(BOOL)highlighted
{
    if (!highlighted)
    {
        [self.circleLayer setLineWidth:0.0];
    }
    else
    {
        [self.circleLayer setStrokeColor:[UIColor whiteColor].CGColor];
        [self.circleLayer setLineWidth:3.0];
    }
}

-(void)setColor:(UIColor *)newColor{
    color = newColor;
    [self.circleLayer setStrokeColor:[color CGColor]];
    [self.circleLayer setFillColor:[color CGColor]];
}

@end
