//
//  Delete.h
//  redBlack
//
//  Created by Ducky on 2015. 1. 15..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
@interface Delete : UIViewController
{
@public
    Node * targetNode;
}
@property (weak, nonatomic) IBOutlet UILabel *comment;
-(void)setTargetNode:(Node *)node;
@end
