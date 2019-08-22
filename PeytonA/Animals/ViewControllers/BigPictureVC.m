//
//  BigPictureVC.m
//  PeytonA
//
//  Created by Peyton on 2019/8/20.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "BigPictureVC.h"
#import "BigPicturesView.h"

@interface BigPictureVC ()<BigPicDelegate>
//bigPicView
@property (nonatomic, strong)BigPicturesView *bigPicView;
//timer
@property (nonatomic, strong)NSTimer *timer;
//
@property (nonatomic, strong)NSArray *datas;

@end

@implementation BigPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self bigPicView];
    [self.bigPicView setNameLabel:self.animalModel.name enString:self.animalModel.enName andIntroductionString:self.animalModel.characteristic];
    [self.bigPicView reloadData];
}

#pragma mark BigPicDelegate
- (NSInteger)numberOfItems {
    return 3;
}

- (UIImage *)imageForItemAtIndex:(NSInteger)index {
    return [UIImage imageNamed:@"cat1"];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark lazy
- (BigPicturesView *)bigPicView {
    if (!_bigPicView) {
        _bigPicView = [[BigPicturesView alloc]init];
        [self.view addSubview:_bigPicView];
        [_bigPicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        _bigPicView.delegate = self;
    }
    return _bigPicView;
}



@end
