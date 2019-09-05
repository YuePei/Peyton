//
//  UIView+KeyBoardAdjust.m
//  Runtime
//
//  Created by Peyton on 2018/6/19.
//  Copyright © 2018年 Peyton. All rights reserved.
//
/**
 情况一: 为单个TextField添加上移功能, 不需要判断第一响应者, 为哪个TextField添加了, 点击该TextField的时候, 自动上移
 情况二: 为某个页面上的所有的TextField添加上移功能, 需要判断哪个TextField是第一响应者, 键盘上移的时候, 应该按照该第一响应者的frame去设置
 1. 添加观察者, 观察键盘即将出现或者收起
 2. 让textField的根视图偏移, 而不是让textField偏移
 */

#import "UIView+KeyBoardAdjust.h"

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@implementation UIView (KeyBoardAdjust)

UIView *rootView;
NSMutableArray *tfs;

//为单个TextField添加上移功能
- (void)adjustFrameWithKeyBoard {
    [self addNotificationToTextField];
//    [(id)self setDelegate:self];
}

//为页面上的所有TextField添加上移功能
- (void)adjustAllTextFieldsWithKeyBoard {
    if (!tfs) {
        tfs = [NSMutableArray array];
    }else {
        [tfs removeAllObjects];
    }
    [self addAllTheTextFieldsInPage:[self findRootView] IntoArray:tfs];
}

//移除某个TextField
- (void)removeKeyBoardAdjust {
    [tfs removeObject:self];
    [self removeKeyboardNotifications];
}

//为当前页面所有的TextField移除该功能
- (void)removePageKeyBoardAdjust {
    NSMutableArray *tempArray = [NSMutableArray array];
    [self addAllTheTextFieldsInPage:[self findRootView] IntoArray:tempArray];
    [tfs removeObjectsInArray:tempArray];
    [self removeKeyboardNotifications];
}

//将页面上的所有的TextField添加到数组tfs中, 并给每个TextField添加监听
- (void)addAllTheTextFieldsInPage:(UIView *)rootView IntoArray:(NSMutableArray *)textFieldArray {
    for (UIView *view in rootView.subviews) {
        if (view.subviews.count > 0) {
            [self addAllTheTextFieldsInPage:view IntoArray:textFieldArray];
        }
        if ([view isKindOfClass:[UITextField class]]) {
            [textFieldArray addObject:view];
//            [(id)view setDelegate:self];
            [view addNotificationToTextField];
        }
    }
}

//为textField添加监听
- (void)addNotificationToTextField{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//键盘将要展示
- (void)keyBoardWillShow:(NSNotification *)notification {
    //获取键盘高度
    float h = CGRectGetHeight([[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    //获取键盘弹出所需时间
    float duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UITextField *firstResponderTextField = [self findFirstResponder];
    //如果键盘弹起时会遮挡某个textField, 让页面上移
    if (SCREEN_HEIGHT - h - firstResponderTextField.frame.origin.y - firstResponderTextField.frame.size.height < 0) {
        [UIView animateWithDuration:duration animations:^{
//            [self findRootView];
            [rootView setFrame:CGRectMake(0, CGRectGetHeight(rootView.frame) - h - firstResponderTextField.frame.origin.y - firstResponderTextField.frame.size.height - 20, CGRectGetWidth(rootView.frame), CGRectGetHeight(rootView.frame))];
        }];
    }
}

//键盘将要隐藏
- (void)keyBoardWillHide:(NSNotification *)notification {
    
    float duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [rootView setFrame:CGRectMake(0, 0, CGRectGetWidth(rootView.frame), CGRectGetHeight(rootView.frame))];
    }];
}

//找到当前页面的根视图
- (UIView *)findRootView {
    UIView *view = self;
    UIView *superView;
    while (true) {
        superView = view.superview;
        if (superView == nil) {
            superView = view;
            break;
        }else {
            view = superView;
        }
    }
    return rootView = superView;
}

//找到第一响应者
- (UITextField *)findFirstResponder {
    __block UITextField *firstResponderTextField = nil;
    [tfs enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isFirstResponder]) {
            firstResponderTextField = obj;
            *stop = YES;
        }
    }];
    return firstResponderTextField;
}

//点击空白部分收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
    //如果用下面的方法会导致无法选择文字
    //[[self findFirstResponder] resignFirstResponder];
    
}

//移除监听
- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [[self findRootView] resignFirstResponder];
//    return true;
//}


@end
