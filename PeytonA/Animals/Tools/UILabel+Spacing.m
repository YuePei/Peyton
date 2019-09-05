//
//  UILabel+Spacing.m
//  PeytonA
//
//  Created by Company on 2019/8/21.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "UILabel+Spacing.h"

@implementation UILabel (Spacing)
- (void)setText:(NSString *)text spacing:(CGFloat)spacing{
    // 設置文字間距原理是在每一個字符串後面添加一個空白的間距,這樣會使得居中出現問題
    // text = [NSString stringWithFormat:@" %@",text]; 錯誤方式,就算空白字符串,也會佔用寬度,居中有偏差
    // 正確解決辦法就是在xib中設置居中偏移量為 + spacing/2.0
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(spacing)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:self.textAlignment];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length]-1)];
    self.attributedText = attributedString;
    [self sizeToFit];
}

//设置行间距
- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing
{
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}
@end
