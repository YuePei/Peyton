//
//  UIButton+BackgroundColor.h
//  Runtime
//
//  Created by Peyton on 2018/6/12.
//  Copyright © 2018年 Peyton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BackgroundColor)

/**
 @param backgroundColor  背景色
 @param state            按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
