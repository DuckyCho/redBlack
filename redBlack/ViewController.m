//
//  ViewController.m
//  redBlack
//
//  Created by Ducky on 2015. 1. 1..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nodeDelete:) name:@"nodeDelete" object:nil];
    [_validCheck setBackgroundColor:[UIColor clearColor]];
    [_validCheck setTextColor:[UIColor clearColor]];
    [_close setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];


}

-(void)nodeDelete:(NSNotification *)noti{
    Node * targetNode = noti.object;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Delete * controller = [storyboard instantiateViewControllerWithIdentifier:@"Delete"];
    [controller setTargetNode:targetNode];
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)addButtonTouched:(id)sender {
    UIView * popup = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.1, self.view.frame.size.width*0.9, self.view.frame.size.height*0.3)];
    [popup setBackgroundColor:[UIColor blackColor]];

    UILabel * desc = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, popup.frame.size.width-10, 20)];
    [popup setBackgroundColor:[UIColor blackColor]];
    popup.tag = POPUP;
    
    desc.text = @"새로 생성할 노드의 값을 입력하세요.";
    [desc setTextColor:[UIColor whiteColor]];

    UITextField * input = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, popup.frame.size.width-20, 50)];
    [input setBackgroundColor:[UIColor whiteColor]];
    [input setKeyboardType:UIKeyboardTypeDecimalPad];
    input.placeholder = @"숫자만 가능함요. 취소버튼 없음요";
    input.tag = TEXTFIELD;
    
    UIButton * ok = [[UIButton alloc]initWithFrame:CGRectMake(30, 130, popup.frame.size.width-60, 30)];
    [ok setBackgroundColor:[UIColor greenColor]];
    [ok setTitle:@"OK" forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(okButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [popup addSubview:ok];
    [popup addSubview:input];
    [popup addSubview:desc];
    [self.view addSubview:popup];
}
-(void)okButtonTouched{
    UITextField * tf = [self.view viewWithTag:TEXTFIELD];
    NSUInteger userInputValue = [tf.text integerValue];
    Node * newNode =[[Node alloc]initWithValue:userInputValue];
    [_tree addSubview:newNode];
    [[self.view viewWithTag:POPUP] removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkRBtree:(id)sender {
    BOOL isValid;
    if(_tree.root == nil){
        isValid = YES;
    }
    else{
        isValid = [self checkStepOne:_tree];
        if(isValid == YES){
            isValid = [self checkStepTwo:_tree];
            if(isValid == YES){
                isValid = [self checkStepThree:_tree];
            }
        }
    }
    
    if(isValid == NO){
        _validCheck.textColor = UIColorFromRGB(RED_HEX);
        _validCheck.text = [NSString stringWithFormat:@"올바른 레드블랙트리가 아닙니다.\n공부하세요!"];
        _validCheck.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        [_close setTitleColor:UIColorFromRGB(BLACK_HEX) forState:UIControlStateNormal];
        [_mainScrollView bringSubviewToFront:_close];
    }
    else{
        _validCheck.textColor = [UIColor blueColor];
        _validCheck.text = [NSString stringWithFormat:@"올바른 레드블랙트리입니다.\n멋있다요!"];
        _validCheck.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        [_close setTitleColor:UIColorFromRGB(BLACK_HEX) forState:UIControlStateNormal];
        [_mainScrollView bringSubviewToFront:_close];

    }
    
}
- (IBAction)closeValidity:(id)sender {
    UIButton * close = sender;
    [close setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_validCheck setBackgroundColor:[UIColor clearColor]];
    [_validCheck setTextColor:[UIColor clearColor]];
}

//rootnode의 색이 black인지 체크
-(BOOL)checkStepOne:(Tree *)tree{
    if(tree.root.color_int == BLACK_INT)
        return YES;
    else
        return NO;
}
//rednode의 부모가 black인지 체크
-(BOOL)checkStepTwo:(Tree *)tree{
    NSMutableArray * queue = [[NSMutableArray alloc]init];
    Node * firstObj;
    [queue addObject:tree.root];
    while(queue.count != 0){
        firstObj = [queue firstObject];
        [queue removeObjectIdenticalTo:[queue firstObject]];
        if(firstObj.color_int == RED_INT){
            if(firstObj.dad.color_int == RED_INT){
                return NO;
            }
        }
        if(firstObj.left != nil){
            [queue addObject:firstObj.left];
        }
        if(firstObj.right != nil){
            [queue addObject:firstObj.right];
        }
    }
    return YES;
}
//black height check
-(BOOL)checkStepThree:(Tree *)tree{
    Node * rootNode = tree.root;
    NSUInteger leftHeight = [self getBlackHeight:rootNode.left];
    NSUInteger rightHeight = [self getBlackHeight:rootNode.right];

    if(leftHeight != rightHeight || leftHeight == -1 || rightHeight == -1){
        return NO;
    }
    else{
        return YES;
    }
}

-(NSUInteger)getBlackHeight:(Node *)root{
    if(root == nil){
        return 0;
    }
    NSUInteger left = [self getBlackHeight:root.left];
    NSUInteger right = [self getBlackHeight:root.right];

    if(left == -1 || right == -1){
        return -1;
    }
    else{
        if(left != right)
            return -1;
        else if(root.color_int == BLACK_INT && left == right)
            return left+1;
        else
            return left;
    }
}
@end
