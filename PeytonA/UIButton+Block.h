//
//  UIButton+Block.h
//  GCD
//
//  Created by Peyton on 2019/5/10.
//  Copyright © 2019 shzygk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BLK)(UIButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Block)

- (void)addActionBlock:(BLK)actionBlock;

@end

NS_ASSUME_NONNULL_END
