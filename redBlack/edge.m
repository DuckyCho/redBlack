//
//  edge.m
//  redBlack
//
//  Created by Ducky on 2015. 1. 7..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import "edge.h"

@implementation edge
-(id)initWithTwoNode:(Node *)rootNode child:(Node *)child{
    CGRect rec = CGRectMake(rootNode.center.x, rootNode.center.y, child.center.x-rootNode.center.x,child.center.y-rootNode.center.y);
    if([super initWithFrame:rec]){
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;

}

-(id)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void)setFrameWithTwoNode:(Node *)rootNode child:(Node *)child{
    CGRect rec = CGRectMake(rootNode.center.x, rootNode.center.y, child.center.x-rootNode.center.x,child.center.y-rootNode.center.y);
    [self setFrame:rec];
}

- (void)drawRect:(CGRect)rect{
    [[UIColor blackColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height);
    CGContextStrokePath(context);
}

@end
