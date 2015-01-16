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
    
    while(_edges.count!=0){
        [[_edges firstObject]removeFromSuperview];
        [_edges removeObjectAtIndex:0];
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
    while(_edges.count != 0){
        [[_edges firstObject]removeFromSuperview];
        [_edges removeObjectAtIndex:0];
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
    Node * successor;
    Node * successorL = node.left == nil ? node : [self treeMaximum:node.left];
    Node * successorR = node.right == nil ? node : [self treeMinimum:node.right];
    if(successorL.color_int == RED_INT)
        successor = successorL;
    else if(successorR.color_int == RED_INT)
        successor = successorR;
    else
        successor = successorL;
    
    
    
    ///successor를 선출하여 삭제할 node 를 successor로 대치시킬 때 발생하는 경우의 수
    ///00. successor가 red일 경우 : 삭제할 node를 successor로 대치시키고 delete end
    
    ///01. successor가 black일 경우
    ///01-0.successor의 자식이 없을 경우 : deleteStep 진행
    ///01-1.successor의 자식이 있을 경우 : successor를 successor의 자식으로 대치시키고 successor의 자식의 색을 successor로 바꾼 후 delete end
    
    
    ///c.f. 예외case : successor가 root일 경우 : free(root)
    
    //c.f. successor가 root인경우 : 트리에 root노드 단 하나만 존재하는 경우, root를 free, delete끝
    
    if(root == successor){
        [root removeFromSuperview];
        root = nil;
        return;
    }
    else if (successor.color_int ==  RED_INT){
        node.value = successor.value;
        [node setTitle:successor.titleLabel.text forState:UIControlStateNormal];
        if(successor.dad.right == successor)
            successor.dad.right = nil;
        else
            successor.dad.left = nil;
        successor.dad = nil;
        [successor removeFromSuperview];
    }
    else{
        node.value = successor.value;
        [node setTitle:successor.titleLabel.text forState:UIControlStateNormal];
        if(successor.left == nil && successor.right == nil){
            [self deleteSuccessor_step1:successor];
            if(successor.dad.left == successor)
                successor.dad.left = nil;
            else
                successor.dad.right = nil;
            successor.dad = nil;
            [successor removeFromSuperview];
        }
        else{
            if(successor.value < node.value){
                successor.value = successor.left.value;
                [successor.left removeFromSuperview];
                successor.left.dad = nil;
                successor.left = nil;
                
            }
            else{
                successor.value = successor.right.value;
                [successor.right removeFromSuperview];
                successor.right.dad = nil;
                successor.right = nil;
            }
        }
    }
    
    [self setRootNodePos];
    [self setAllNodePos:root];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"redrawEdge" object:nil];
}

-(Node *)getSibling:(Node *)node{
    if(node.dad.left == node)
        return node.dad.right;
    else
        return node.dad.left;

}

-(void)deleteSuccessor_step1:(Node *)node{
    Node * sibling = [self getSibling:node];
    if(sibling.color_int == RED_INT){
        node.dad.color_int = RED_INT;
        [node.dad setColor:UIColorFromRGB(RED_HEX)];
        sibling.color_int = BLACK_INT;
        [sibling setColor:UIColorFromRGB(BLACK_HEX)];
        
        if(node.dad.left == node){
            [self leftRotate:self node:sibling.dad];
        }
        else{
            [self rightRotate:self node:sibling.dad];
        }
    }
    else{
        [self deleteSuccessor_step2:node];
    }
}
-(void)deleteSuccessor_step2:(Node *)node{
    Node * sibling = [self getSibling:node];
    if(node.dad.left ==node){
        if(sibling.color_int == BLACK_INT && sibling.right.color_int == RED_INT && (sibling.left.color_int == RED_INT || sibling.left.color_int == BLACK_INT)){
            sibling.color_int = sibling.dad.color_int;
            [sibling setColor:sibling.dad.color];
            sibling.dad.color_int = BLACK_INT;
            [sibling.dad setColor:UIColorFromRGB(BLACK_HEX)];
            sibling.right.color_int = BLACK_INT;
            [sibling.right setColor:UIColorFromRGB(BLACK_HEX)];
            [self leftRotate:self node:sibling.dad];
            
        }
        else{
            [self deleteSuccessor_step3:node];
        }
    }
    else{
        if(sibling.color_int == BLACK_INT && sibling.left.color_int == RED_INT && (sibling.right.color_int == RED_INT || sibling.right.color_int ==BLACK_INT)){
                sibling.color_int = sibling.dad.color_int;
                [sibling setColor:sibling.dad.color];
                sibling.dad.color_int = BLACK_INT;
                [sibling.dad setColor:UIColorFromRGB(BLACK_HEX)];
                sibling.right.color = BLACK_INT;
                [sibling.right setColor:UIColorFromRGB(BLACK_HEX)];
                [self rightRotate:self node:sibling.dad];
            }
            else{
                [self deleteSuccessor_step3:node];
            }
    }
}

-(void)deleteSuccessor_step3:(Node *)node{
    Node * sibling = [self getSibling:node];
    if(node.dad.left == node){
        if(sibling.color_int == BLACK_INT && sibling.left.color_int == RED_INT && sibling.right.color_int == BLACK_INT){
            sibling.left.color_int = BLACK_INT;
            [sibling.left setColor:UIColorFromRGB(BLACK_HEX)];
            sibling.color_int = RED_INT;
            [sibling setColor:UIColorFromRGB(RED_HEX)];
            [self rightRotate:self node:sibling.dad];
            [self deleteSuccessor_step2:node];
        }
        else{
            [self deleteSuccessor_step4:node];
        }
    }
    else{
        if(sibling.color_int == BLACK_INT && sibling.right.color_int == RED_INT && sibling.left.color_int == BLACK_INT){
            sibling.right.color_int = BLACK_INT;
            [sibling.right setColor:UIColorFromRGB(BLACK_HEX)];
            sibling.color_int = RED_INT;
            [sibling setColor:UIColorFromRGB(RED_HEX)];
            [self leftRotate:self node:sibling.dad];
            [self deleteSuccessor_step2:node];
        }
        else{
            [self deleteSuccessor_step4:node];
        }
    }
}

-(void)deleteSuccessor_step4:(Node *)node{
    Node * sibling = [self getSibling:node];
    if(sibling.color_int ==BLACK_INT && sibling.left.color_int ==BLACK_INT && sibling.right.color_int ==BLACK_INT){
        sibling.color_int = RED_INT;
        [sibling setColor:UIColorFromRGB(RED_HEX)];
        if(sibling.dad.color_int == RED_INT){
            sibling.dad.color_int = BLACK_INT;
            [sibling.dad setColor:UIColorFromRGB(BLACK_HEX)];
        }
        else{
            if(root != sibling.dad){
                [self deleteSuccessor_step1:sibling.dad];
            }
        }
    }
}

//
//-(void)delete:(Node *)node{
//    Node * tmp = node;
//    int originalColor = tmp.color_int;
//    Node * x;
//    if (node.left == nil) {
//        x = node.right;
//        [self transplant:node plantNode:node.right];
//    }
//    else if (node.right == nil) {
//        x = node.left;
//        [self transplant:node plantNode:node.left];
//    }
//    else{
//        tmp = [self treeMinimum:node.right];
//        originalColor = tmp.color_int;
//        x = tmp.right;
//        if (tmp.dad == node) {
//            x.dad = tmp;
//        }
//        else{
//            [self transplant:tmp plantNode:tmp.right];
//            tmp.right = node.right;
//            tmp.right.dad = tmp;
//        }
//        [self transplant:node plantNode:tmp];
//        tmp.left = node.left;
//        tmp.left.dad = tmp;
//        tmp.color_int = node.color_int;
//        [tmp setColor:node.color];
//    }
//    if(originalColor == BLACK_INT){
//        [self deleteFixUp:x];
//    }
//
//}
//
//-(void)deleteFixUp:(Node *)x{
//    Node * w;
//    while (x != root && x.color_int == BLACK_INT) {
//        if(x == x.dad.left){
//            w = x.dad.right;
//            if(w.color_int == RED_INT){
//                w.color_int = BLACK_INT;
//                [w setColor:UIColorFromRGB(BLACK_HEX)];
//                x.dad.color_int = RED_INT;
//                [x.dad setColor:UIColorFromRGB(RED_HEX)];
//                [self leftRotate:self node:x.dad];
//                w = x.dad.right;
//            }
//            if(w.left.color_int == BLACK_INT && w.right.color_int == BLACK_INT){
//                w.color_int = RED_INT;
//                [w setColor:UIColorFromRGB(RED_HEX)];
//                x = x.dad;
//            }
//            else{
//                if(w.right.color_int == BLACK_INT){
//                    w.left.color_int = BLACK_INT;
//                    [w.left setColor:UIColorFromRGB(BLACK_HEX)];
//                    w.color_int = RED_INT;
//                    [w setColor:UIColorFromRGB(RED_HEX)];
//                    [self rightRotate:self node:w];
//                    w = x.dad.right;
//                }
//                w.color_int = x.dad.color_int;
//                [w setColor:x.dad.color];
//                x.dad.color_int = BLACK_INT;
//                [x.dad setColor:UIColorFromRGB(BLACK_HEX)];
//                w.right.color_int = BLACK_INT;
//                [w.right setColor:UIColorFromRGB(BLACK_HEX)];
//                [self leftRotate:self node:x.dad];
//                x = root;
//            }
//        }
//        else{
//            w = x.dad.left;
//            if(w.color_int == RED_INT){
//                w.color_int = BLACK_INT;
//                [w setColor:UIColorFromRGB(BLACK_HEX)];
//                x.dad.color_int = RED_INT;
//                [x.dad setColor:UIColorFromRGB(RED_HEX)];
//                [self rightRotate:self node:x.dad];
//                w = x.dad.left;
//            }
//            if(w.right.color_int == BLACK_INT && w.left.color_int == BLACK_INT){
//                w.color_int = RED_INT;
//                [w setColor:UIColorFromRGB(RED_HEX)];
//                x = x.dad;
//            }
//            else{
//                if(w.left.color_int == BLACK_INT){
//                    w.right.color_int = BLACK_INT;
//                    [w.right setColor:UIColorFromRGB(BLACK_HEX)];
//                    w.color_int = RED_INT;
//                    [w setColor:UIColorFromRGB(RED_HEX)];
//                    [self leftRotate:self node:w];
//                    w = x.dad.left;
//                }
//                w.color_int = x.dad.color_int;
//                [w setColor:x.dad.color];
//                x.dad.color_int = BLACK_INT;
//                [x.dad setColor:UIColorFromRGB(BLACK_HEX)];
//                w.right.color_int = BLACK_INT;
//                [w.right setColor:UIColorFromRGB(BLACK_HEX)];
//                [self rightRotate:self node:x.dad];
//                x = root;
//            }
//        }
//    }
//    x.color_int = BLACK_INT;
//    [x setColor:UIColorFromRGB(BLACK_HEX)];
//}

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
