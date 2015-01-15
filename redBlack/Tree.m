//
//  Tree.m
//  redBlack
//
//  Created by Ducky on 2015. 1. 1..
//  Copyright (c) 2015년 DuckyCho. All rights reserved.
//

#import "Tree.h"

@implementation Tree
@synthesize root;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        root = nil;
        NSNotificationCenter * notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self selector:@selector(redrawEdge:) name:@"redrawEdge" object:nil];
        [notiCenter addObserver:self selector:@selector(deleteNode:) name:@"deleteNode" object:nil];
        _edges =[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)deleteNode:(NSNotification *)noti{
    Node * node = noti.object;
    [self delete:node];
}
-(void)redrawEdge:(NSNotification *)noti{
    for(int i = 0 ; i < _edges.count ; i ++){
        [[_edges objectAtIndex:i]removeFromSuperview];
        [_edges removeObjectAtIndex:i];
    }
    if(root != nil)
        [self redrawAllEdge:root];
}

-(void)redrawAllEdge:(Node *)rootNode{
    NSMutableArray * queue = [[NSMutableArray alloc]init];
    Node * firstObj;
    [queue addObject:rootNode];
    
    while(queue.count != 0){
        firstObj = [queue firstObject];
        [queue removeObjectIdenticalTo:[queue firstObject]];
        if(firstObj.left != nil){
            [queue addObject:firstObj.left];
            [self drawEdge:firstObj child:firstObj.left];
        }
        if(firstObj.right != nil){
            [queue addObject:firstObj.right];
            [self drawEdge:firstObj child:firstObj.right];
        }
    }
}

-(void)addSubview:(UIView *)view{
    if([view isKindOfClass:[Node class]])
        view.frame = CGRectMake(self.frame.size.width*0.5, 0, view.frame.size.width, view.frame.size.height);
    [super addSubview:view];
    if([view isKindOfClass:[Node class]])
        [self insertTree:root insertedView:view];
}

-(void)setRootNodePos{
     if(root == nil){
        return;
    }
    float fullWidth = self.frame.size.width;
    [self.root setFrame:CGRectMake( (fullWidth - root.frame.size.width)*0.5, 0, root.frame.size.width, root.frame.size.height)];
    root.height = 0;
}
-(void)drawEdge:(Node *)rootNode child:(Node *)child{
    UIView * newEdge;
    if(child == rootNode.right)
        newEdge = [[edge alloc]initWithTwoNode:rootNode child:child];
    else
        newEdge = [[edge_reverse alloc]initWithTwoNode:rootNode child:child];
    newEdge.tag = child.value+EDGE_TAG;
    [self addSubview:newEdge];
    [self sendSubviewToBack:newEdge];
    [_edges addObject:newEdge];
}

-(void)setAllNodePos:(Node *)rootNode{
    if(rootNode == nil){
        return;
    }
    BOOL isPosDoubled;
    NSMutableArray * queue = [[NSMutableArray alloc]init];
    Node * firstObj;
    for(int i = 0 ; i < _edges.count ; i ++){
        [[_edges objectAtIndex:i]removeFromSuperview];
        [_edges removeObjectAtIndex:i];
    }
    [queue addObject:rootNode];
    
    while(queue.count != 0){
        firstObj = [queue firstObject];
        [queue removeObjectIdenticalTo:[queue firstObject]];
        if(firstObj.left != nil){
            [firstObj.left setFrame:CGRectMake(firstObj.frame.origin.x-(firstObj.frame.size.width), firstObj.frame.origin.y+(firstObj.frame.size.height*1.5), firstObj.left.frame.size.width, firstObj.left.frame.size.height)];
            firstObj.left.height = firstObj.left.dad.height+1;
            isPosDoubled = [self checkPosDoubled:firstObj.left];
            [queue addObject:firstObj.left];
            if(isPosDoubled == NO){
                [self drawEdge:firstObj child:firstObj.left];
            }
        }
        if(firstObj.right != nil){
            [firstObj.right setFrame:CGRectMake(firstObj.frame.origin.x+(firstObj.frame.size.width), firstObj.frame.origin.y+(firstObj.frame.size.height*1.5), firstObj.right.frame.size.width, firstObj.right.frame.size.height)];
            firstObj.right.height = firstObj.right.dad.height+1;
            isPosDoubled = [self checkPosDoubled:firstObj.right];
            [queue addObject:firstObj.right];
            if(isPosDoubled == NO){
                [self drawEdge:firstObj child:firstObj.right];
            }
        }
    }
    
}
-(BOOL)checkPosDoubled:(Node *)node{
    Node * uncle = [self getUncle:node];
    Node * similNode;
    
    if(node.dad == node.dad.dad.left && node == node.dad.right){
        similNode = uncle.left;
        if(similNode.frame.origin.x == node.frame.origin.x){
            [node.dad moveXpos:node.frame.size.width*-0.8];
            [uncle moveXpos:node.frame.size.width*0.8];
            [node moveXpos:node.frame.size.width*-0.8];
            [similNode moveXpos:node.frame.size.width*0.8];
            return YES;
        }
    }
    else if(node.dad == node.dad.dad.right && node == node.dad.left){
        similNode = uncle.right;
        if(similNode.frame.origin.x == node.frame.origin.x){
            [node.dad moveXpos:node.frame.size.width*0.8];
            [uncle moveXpos:node.frame.size.width*-0.8];
            [node moveXpos:node.frame.size.width*0.8];
            [similNode moveXpos:node.frame.size.width*-0.8];
            return YES;
        }
    }
    else{
        return NO;
    }
    return NO;
}

//redBlackTree Insert
-(void)insertTree:(Node *)tree insertedView:(UIView *)insertedView{
    Node * newNode;


    //parameter typecheck
    if ([insertedView isKindOfClass:[Node class]] == YES){
        newNode = insertedView;
    }
    else{
        return;
    }
    [newNode setDad:nil];
    [newNode setLeft:nil];
    [newNode setRight:nil];
  
    //empty root check
    if(self.root == nil){
        self.root = newNode;
        [newNode setColor_int:BLACK_INT];
        [newNode setColor:UIColorFromRGB(BLACK_HEX)];
        [self setRootNodePos];
    }
    //if, newNode is not a root node in the tree.
    else{
        //**first, insert into the tree**//
        [self bstInsertion:newNode ancestor:root ancestorStack:nil];
        //**second, fixup, if newNode->parent is RED **//
        while ( newNode.dad.color_int == RED_INT ){
            Node * uncle = [self getUncle:newNode];
            
            //parent가 left child일 경우
            if(newNode.dad == newNode.dad.dad.left){
                if(uncle.color_int == RED_INT){
                    newNode.dad.color_int = BLACK_INT;
                    [newNode.dad setColor:UIColorFromRGB(BLACK_HEX)];
                    
                    uncle.color_int = BLACK_INT;
                    [uncle setColor:UIColorFromRGB(BLACK_HEX)];
                    
                    newNode.dad.dad.color_int = RED_INT;
                    [newNode.dad.dad setColor:UIColorFromRGB(RED_HEX)];
                    
                    newNode = newNode.dad.dad;
                }
                else{
                    if(newNode == newNode.dad.right){
                        newNode = newNode.dad;
                        [self leftRotate:self node:newNode];
                    }
                    newNode.dad.color_int = BLACK_INT;
                    [newNode.dad setColor:UIColorFromRGB(BLACK_HEX)];
                    newNode.dad.dad.color_int = RED_INT;
                    [newNode.dad.dad setColor:UIColorFromRGB(RED_HEX)];
                    [self rightRotate:self node:newNode.dad.dad];
                }
            }
            else{
                if(uncle.color_int == RED_INT){
                    newNode.dad.color_int = BLACK_INT;
                    [newNode.dad setColor:UIColorFromRGB(BLACK_HEX)];
                    
                    uncle.color_int = BLACK_INT;
                    [uncle setColor:UIColorFromRGB(BLACK_HEX)];
                    
                    newNode.dad.dad.color_int = RED_INT;
                    [newNode.dad.dad setColor:UIColorFromRGB(RED_HEX)];
                    
                    newNode = newNode.dad.dad;
                }
                else{
                    if(newNode == newNode.dad.left){
                        newNode = newNode.dad;
                        [self rightRotate:self node:newNode];
                    }
                    newNode.dad.color_int = BLACK_INT;
                    [newNode.dad setColor:UIColorFromRGB(BLACK_HEX)];
                    newNode.dad.dad.color_int = RED_INT;
                    [newNode.dad.dad setColor:UIColorFromRGB(RED_HEX)];
                    [self leftRotate:self node:newNode.dad.dad];
                }
            }
        }
    }
    self.root.color_int = BLACK_INT;
    [self.root setColor:UIColorFromRGB(BLACK_HEX)];
    [self setRootNodePos];
    [self setAllNodePos:root];
}

-(void)rightRotate:(Tree *)tree node:(Node *)node{
    if(tree.root == nil){
        return;
    }
    else if(node == nil){
        return;
    }
    else{
        Node * parent = node.dad;
        Node * leftNode = node.left;
        Node * newLeft;
        if(leftNode != nil){
            newLeft = leftNode.right;
        }
        
        if(parent.right == node){
            parent.right = leftNode;
        }
        else{
            parent.left = leftNode;
        }
        leftNode.dad = parent;
        
        leftNode.right = node;
        node.dad = leftNode;
        
        node.left = newLeft;
        newLeft.dad = node;
    }
    if(root == node){
        root = node.dad;
    }
    root.height = 0;
}

-(void)leftRotate:(Tree *)tree node:(Node *)node{
    if(tree.root == nil){
        return;
    }
    else if(node == nil){
        return;
    }
    else{
        Node * parent = node.dad;
        Node * rightNode = node.right;
        Node * newRight;
        if(rightNode != nil){
            newRight = rightNode.left;
        }
        
        if(parent.left == node){
            parent.left = rightNode;
        }
        else{
            parent.right = rightNode;
        }
        rightNode.dad = parent;
        
        rightNode.left = node;
        node.dad = rightNode;

        node.right = newRight;
        newRight.dad = node;
    }
    if(root == node){
        root = node.dad;
    }
    root.height = 0;
}

-(Node *)getUncle:(Node *)node{
    Node * uncle;
    if(node == nil){
        uncle = nil;
    }
    else if(node.dad == self.root){
        uncle = nil;
    }
    else{
        if(node.dad == node.dad.dad.left){
            uncle = node.dad.dad.right;
        }
        else{
            uncle = node.dad.dad.left;
        }
    }
    
    if(uncle == nil){
        uncle = [[Node alloc]initWithValue:-INFINITY];
        uncle.color_int = BLACK_INT;
        [uncle setColor:UIColorFromRGB(BLACK_HEX)];
    }
    return uncle;
}

-(void)bstInsertion:(Node *)node ancestor:(Node *)ancestor ancestorStack:(NSMutableArray *)ancestorStack{
    if(ancestorStack == nil){
        ancestorStack = [[NSMutableArray alloc]init];
        [ancestorStack addObject:node];
    }
    [node setHeight:node.height+1];
    [ancestorStack addObject:ancestor];
    if(ancestor.value <= node.value){
        if(ancestor.right == nil){
            [node setDad:ancestor];
            [node setRight:nil];
            [node setLeft:nil];
            
            [ancestor setRight:node];
        }
        else{
            [self bstInsertion:node ancestor:ancestor.right ancestorStack:ancestorStack];
        }
    }
    else{
        if(ancestor.left == nil){
            [node setDad:ancestor];
            [node setRight:nil];
            [node setLeft:nil];
            
            [ancestor setLeft:node];
        }
        else{
            [self bstInsertion:node ancestor:ancestor.left ancestorStack:ancestorStack];
        }
    
    }
}

-(void)printAllTree:(Tree *)tree node:(Node *)node{
    if(node == nil){
        return;
    }
    if(node.left != nil){
        [self printAllTree:tree node:node.left];
    }

    if(node.color_int == RED_INT && node.dad.color_int == RED_INT){
        NSLog(@"Function - printAllTree / Violation occured / node value : %d, color : %d / dad value :%d , color : %d",node.value,node.color_int,node.dad.value,node.dad.color_int);
    }
    if(node.right != nil){
        [self printAllTree:tree node:node.right];
    }
}

-(void)delete:(Node *)node{
    NSUInteger erasedColor = node.color_int;
    Node * fixupNode;
    Node * successor;
   if(node.left == nil){
        fixupNode = node.right;
        [self transplant:node plantNode:node.right];
    }
    else if(node.right == nil){
        fixupNode = node.left;
        [self transplant:node plantNode:node.left];
    }
    else{
        successor = [self treeMinimum:node.right];
        erasedColor = successor.color_int;
        fixupNode = successor.right;
        if(successor.dad == node)
            fixupNode.dad = successor;
        else{
            [self transplant:successor plantNode:successor.right];
            successor.right = node.right;
            successor.right.dad = successor;
        }
        [self transplant:node plantNode:successor];
        successor.left = node.left;
        successor.left.dad = successor;
        successor.color_int = node.color_int;
        [successor setColor:node.color];
    }
    if(erasedColor == BLACK_INT){
        [self deleteFixup:fixupNode];
    }
    node.dad = nil;
    node.left = nil;
    node.right = nil;
    [node removeFromSuperview];
    [self setRootNodePos];
    [self setAllNodePos:root];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"redrawEdge" object:nil];
    
}
-(void)deleteFixup:(Node *)fixupNode{
    while (fixupNode != root && fixupNode.color_int != BLACK_INT) {
        if(fixupNode == fixupNode.dad.left){
            Node * sibling = fixupNode.dad.right;
            if(sibling.color_int == RED_INT){
                sibling.color_int = BLACK_INT;
                [sibling setColor:UIColorFromRGB(BLACK_HEX)];
                fixupNode.dad.color_int = RED_INT;
                [fixupNode.dad setColor:UIColorFromRGB(RED_HEX)];
                [self leftRotate:self node:fixupNode.dad];
                sibling = fixupNode.dad.right;
            }
            if(sibling.left.color_int == BLACK_INT && sibling.right.color_int == BLACK_INT){
                sibling.color_int = RED_INT;
                [sibling setColor:UIColorFromRGB(RED_HEX)];
                fixupNode = fixupNode.dad;
            }
            else{
                if(sibling.right.color_int == BLACK_INT){
                    sibling.left.color_int = BLACK_INT;
                    [sibling.left setColor:UIColorFromRGB(BLACK_HEX)];
                    sibling.color_int = RED_INT;
                    [sibling setColor:UIColorFromRGB(RED_HEX)];
                    [self rightRotate:self node:sibling];
                    sibling = fixupNode.dad.right;
                }
                sibling.color_int = fixupNode.dad.color_int;
                [sibling setColor:fixupNode.dad.color];
                fixupNode.dad.color_int = BLACK_INT;
                [fixupNode setColor:UIColorFromRGB(BLACK_HEX)];
                sibling.right.color_int = BLACK_INT;
                [sibling.right setColor:UIColorFromRGB(BLACK_HEX)];
                [self leftRotate:self node:fixupNode.dad];
                fixupNode = root;
            }
        }
        else{
            Node * sibling = fixupNode.dad.left;
            if(sibling.color_int == RED_INT){
                sibling.color_int = BLACK_INT;
                [sibling setColor:UIColorFromRGB(BLACK_HEX)];
                fixupNode.dad.color_int = RED_INT;
                [fixupNode.dad setColor:UIColorFromRGB(RED_HEX)];
                [self rightRotate:self node:fixupNode.dad];
                sibling = fixupNode.dad.left;
            }
            if(sibling.right.color_int == BLACK_INT && sibling.left.color_int == BLACK_INT){
                sibling.color_int = RED_INT;
                [sibling setColor:UIColorFromRGB(RED_HEX)];
                fixupNode = fixupNode.dad;
            }
            else{
                if(sibling.left.color_int == BLACK_INT){
                    sibling.right.color_int = BLACK_INT;
                    [sibling.right setColor:UIColorFromRGB(BLACK_HEX)];
                    sibling.color_int = RED_INT;
                    [sibling setColor:UIColorFromRGB(RED_HEX)];
                    [self leftRotate:self node:sibling];
                    sibling = fixupNode.dad.left;
                }
                sibling.color_int = fixupNode.dad.color_int;
                [sibling setColor:fixupNode.dad.color];
                fixupNode.dad.color_int = BLACK_INT;
                [fixupNode.dad setColor:UIColorFromRGB(BLACK_HEX)];
                sibling.left.color_int = BLACK_INT;
                [sibling.left setColor:UIColorFromRGB(BLACK_HEX)];
                [self rightRotate:self node:fixupNode.dad];
                fixupNode = root;
            }
        }
    }
    fixupNode.color_int = BLACK_INT;
    [fixupNode setColor:UIColorFromRGB(BLACK_HEX)];
}

-(Node *)treeMinimum:(Node *)node{
    Node * tmp = node;
    while(tmp.left != nil){
        tmp = tmp.left;
    }
    return tmp;
}

-(Node *)treeMaximum:(Node *)node{
    Node * tmp = node;
    while(tmp.right != nil){
        tmp = tmp.right;
    }
    return tmp;
}
-(void)transplant:(Node *)target plantNode:(Node *)plantNode{
    if (target.dad == nil) {
        root = plantNode;
    }
    else if (target == target.dad.left){
        target.dad.left = plantNode;
    }
    else{
        target.dad.right = plantNode;
    }
    plantNode.dad = target.dad;
}

@end
