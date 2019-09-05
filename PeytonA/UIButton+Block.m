//
//  UIButton+Block.m
//  GCD
//
//  Created by Peyton on 2019/5/10.
//  Copyright © 2019 shzygk. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/Runtime.h>



#define BlockKey "blockKey"
@interface UIButton()

@end

@implementation UIButton (Block)
- (void)addActionBlock:(BLK)actionBlock {
    self.block = actionBlock;
    [self addTarget:self action:@selector(clickMethod:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickMethod:(UIButton *)sender {
    self.block(sender);
}
#pragma mark lazy
- (void)setBlock:(BLK)block {
    objc_setAssociatedObject(self, BlockKey, block, OBJC_ASSOCIATION_RETAIN);
}

- (BLK)block{
    return objc_getAssociatedObject(self, BlockKey);
}
@end
