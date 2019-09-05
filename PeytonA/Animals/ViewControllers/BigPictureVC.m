//
//  BigPictureVC.m
//  PeytonA
//
//  Created by Company on 2019/8/20.
//  Copyright © 2019 Company. All rights reserved.
//

#import "BigPictureVC.h"
#import "BigPicturesView.h"
#import <AVFoundation/AVFoundation.h>
#import "DismissTransitionAnimation.h"

@interface BigPictureVC ()<BigPicDelegate, UIViewControllerTransitioningDelegate>
//bigPicView
@property (nonatomic, strong)BigPicturesView *bigPicView;
//timer
@property (nonatomic, strong)NSTimer *timer;
//
@property (nonatomic, strong)NSArray *datas;
//audioPlayer
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
//playBtn
@property (nonatomic, strong)UIButton *playBtn;
//
@property (nonatomic, strong)DismissTransitionAnimation *dismissTransitionAnimation;
@end

@implementation BigPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self playBtn];
    [self bigPicView];
    [self.bigPicView setNameLabel:self.animalModel.name enString:self.animalModel.enName andIntroductionString:self.animalModel.characteristic];
    [self.bigPicView reloadData];
    _dismissTransitionAnimation = [DismissTransitionAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissTransitionAnimation;
}

#pragma mark 播放
- (void)playMusic {
    NSString *southPath = [[NSBundle mainBundle] pathForResource:self.animalModel.mainImage ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:southPath];
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    self.audioPlayer.volume = 0.8;
    if (!error) {
        //成功
        [self.audioPlayer play];
        
    }else {
        //失败
    }
}

#pragma mark BigPicDelegate
- (NSInteger)numberOfItems {
    return 2;
}

- (UIImage *)imageForItemAtIndex:(NSInteger)index {
    NSString *imgNameString1 = [NSString stringWithFormat:@"%@1", self.animalModel.mainImage];
    NSString *imgNameString2 = [NSString stringWithFormat:@"%@2", self.animalModel.mainImage];
    NSArray *arr = [NSArray arrayWithObjects:imgNameString1, imgNameString2, nil];
    return [UIImage imageNamed:arr[index]];
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

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view insertSubview:_playBtn aboveSubview:self.bigPicView];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-50);
            make.bottom.mas_equalTo(-150);
            make.width.height.mas_equalTo(60);
        }];
        _playBtn.alpha = 0.5;
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"playImage"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

@end
