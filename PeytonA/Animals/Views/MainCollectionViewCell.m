//
//  MainCollectionViewCell.m
//  PeytonA
//
//  Created by Company on 2019/8/19.
//  Copyright © 2019 Company. All rights reserved.
//

#import "MainCollectionViewCell.h"
@interface MainCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;

@end
@implementation MainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = NO;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.05 animations:^{
        self.leadingCons.constant = -10;
        self.topCons.constant = -10;
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [UIView animateWithDuration:0.05 animations:^{
        self.leadingCons.constant = 0;
        self.topCons.constant = 0;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.05 animations:^{
        self.leadingCons.constant = 0;
        self.topCons.constant = 0;
    }];
}


@end
