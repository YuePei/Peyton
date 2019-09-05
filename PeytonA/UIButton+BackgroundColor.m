//
//  UIButton+BackgroundColor.m
//  Runtime
//
//  Created by Peyton on 2018/6/12.
//  Copyright © 2018年 Peyton. All rights reserved.
//

#import "UIButton+BackgroundColor.h"
#import <objc/runtime.h>

@interface UIButton()
//背景色集合
@property (nonatomic, strong)NSMutableDictionary *bgColorDic;

@end

@implementation UIButton (BackgroundColor)
static const void *bgcolor         = @"bgcolor";
static NSString *y_StateNomal      = @"y_StateNomal";
static NSString *y_StateHighlight  = @"y_StateHighlight";
static NSString *y_StateDisabled   = @"y_StateDisabled";
static NSString *y_StateSelected   = @"y_StateSelected";

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (!self.bgColorDic) {
        self.bgColorDic = [NSMutableDictionary dictionary];
    }
    NSLog(@"...%@",[self getKeyFromButtonState:state]);
    [self.bgColorDic setValue:backgroundColor forKey:[self getKeyFromButtonState:state]];
//    [self.bgColorDic setObject:backgroundColor forKey:[self getKeyFromButtonState:state]];
}

- (NSString *)getKeyFromButtonState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            return y_StateNomal;
            break;
        case UIControlStateHighlighted:
            return y_StateHighlight;
            break;
        case UIControlStateDisabled:
            return y_StateDisabled;
            break;
        case UIControlStateSelected:
            return y_StateSelected;
            break;
        default:
            return y_StateNomal;
            break;
    }
}

//下面是开始对各个状态设置颜色
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = (UIColor *)[self.bgColorDic valueForKey:y_StateHighlight];
    }else {
        self.backgroundColor = (UIColor *)[self.bgColorDic valueForKey:y_StateNomal];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = (UIColor *)[self.bgColorDic valueForKey:y_StateSelected];
    }else {
        self.backgroundColor = (UIColor *)[self.bgColorDic valueForKey:y_StateNomal];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = (UIColor *)[self.bgColorDic valueForKey:y_StateNomal];
    }else {
        self.backgroundColor = (UIColor *)[self.bgColorDic valueForKey:y_StateDisabled];
    }
}
#pragma mark lazy
- (NSMutableDictionary *)bgColorDic
{
    return objc_getAssociatedObject(self, bgcolor);
}

- (void)setBgColorDic:(NSMutableDictionary *)bgColorDic
{
    objc_setAssociatedObject(self, bgcolor, bgColorDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
