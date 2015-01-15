//
//  Delete.m
//  redBlack
//
//  Created by Ducky on 2015. 1. 15..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import "Delete.h"

@implementation Delete

-(void)viewWillAppear:(BOOL)animated{
    _comment.text = [NSString stringWithFormat:@"정말 %d 노드를\n삭제하시겠습니까?",targetNode.value];

}
-(void)setTargetNode:(Node *)node{
    targetNode = node;
}
- (IBAction)ok:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteNode" object:targetNode];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
