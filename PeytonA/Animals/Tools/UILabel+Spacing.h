//
//  UILabel+Spacing.h
//  PeytonA
//
//  Created by Company on 2019/8/21.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Spacing)
- (void)setText:(NSString *)text spacing:(CGFloat)spacing;
- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;
@end

NS_ASSUME_NONNULL_END
