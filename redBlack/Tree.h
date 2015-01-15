//
//  Tree.h
//  redBlack
//
//  Created by Ducky on 2015. 1. 1..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "edge.h"
#import "edge_reverse.h"
#import <math.h>

#define EDGE_TAG 67

typedef enum{DOWN,UP} updown;
typedef enum{UPPERLEFT, UPPERRIGHT, LOWERLEFT, LOWERRIGHT} direction;

@interface Tree : UIView

@property(readwrite)Node * root;
@property(readwrite)NSMutableArray * edges;
-(void)insertTree:(Node *)tree insertedView:(UIView *)insertedView;
-(void)bstInsertion:(Node *)node ancestor:(Node *)ancestor ancestorStack:(NSMutableArray *)ancestorStack;
-(Node *)getUncle:(Node *)node;
-(void)printAllTree:(Tree *)tree node:(Node *)node;
@end
