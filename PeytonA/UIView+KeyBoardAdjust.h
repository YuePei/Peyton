//
//  UIView+KeyBoardAdjust.h
//  Runtime
//
//  Created by Peyton on 2018/6/19.
//  Copyright © 2018年 Peyton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface UIView (KeyBoardAdjust)

/**
 为单个TextField添加调整, 如[textField1 adjustFrameWithKeyBoard]
 */
- (void)adjustFrameWithKeyBoard;

/**
 为页面上所有的TextField作调整, 如[self.view adjustAllTextFieldsWithKeyBoard]
 */
- (void)adjustAllTextFieldsWithKeyBoard;

/**
 移除某个TextField, 如[textField2 adjustFrameWithKeyBoard]
 */
- (void)removeKeyBoardAdjust;

/**
 为当前页面所有的TextField移除该功能, 如[self.view removePageKeyBoardAdjust]
 */
- (void)removePageKeyBoardAdjust;
@end
