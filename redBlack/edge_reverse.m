//
//  edge_reverse.m
//  redBlack
//
//  Created by Ducky on 2015. 1. 7..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import "edge_reverse.h"

@implementation edge_reverse
-(id)initWithTwoNode:(Node *)rootNode child:(Node *)child{
    CGRect rec = CGRectMake(child.center.x, rootNode.center.y, rootNode.center.x - child.center.x, child.center.y - rootNode.center.y);
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
- (void)drawRect:(CGRect)rect{
    [[UIColor blackColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context,0,rect.size.height);
    CGContextAddLineToPoint(context,self.frame.size.width,0);
    CGContextStrokePath(context);
}
@end
