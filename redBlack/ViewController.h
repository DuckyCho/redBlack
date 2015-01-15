//
//  ViewController.h
//  redBlack
//
//  Created by Ducky on 2015. 1. 1..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainScrollview.h"
#import "Delete.h"
#import "Node.h"
#import "Tree.h"
#define POPUP 899
#define TEXTFIELD 900
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet mainScrollview *mainScrollView;
@property (weak, nonatomic) IBOutlet Tree *tree;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *validCheck;
@property (weak, nonatomic) IBOutlet UIButton *close;


@end

