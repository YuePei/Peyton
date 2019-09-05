//
//  CCBottomBtn.m
//  PeytonA
//
//  Created by Peyton on 2019/9/4.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "CCBottomBtn.h"

@implementation CCBottomBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)commonInit{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = self.imageView.frame.origin.x + self.imageView.frame.size.height - 3;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height - y;
    return CGRectMake(x, y, w, h);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat w = 30;
    CGFloat h = 30;
    CGFloat x = (contentRect.size.width - w) * 0.5;
    CGFloat y = (contentRect.size.height - h) * 0.5 - 5;
    return CGRectMake(x, y, w, h);
}


@end
