//
//  BigPicturesView.m
//  PeytonA
//
//  Created by Peyton on 2019/8/21.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "BigPicturesView.h"
#import "UILabel+Spacing.h"


@interface BigPicturesView()<UIScrollViewDelegate>
//scrollView
@property (nonatomic, strong)UIScrollView *scrollView;
//datas
@property (nonatomic, strong)NSArray *datas;
//pageControl
@property (nonatomic, strong)UIPageControl *pageControl;
//backBtn
@property (nonatomic, strong)UIButton *backBtn;
//forwardBtn
@property (nonatomic, strong)UIButton *forwardBtn;
//name
@property (nonatomic, strong)UILabel *nameLabel;
//特征
@property (nonatomic, strong)UILabel *characterLabel;
//英文名
@property (nonatomic, strong)UILabel *englishNameLabel;
@end

@implementation BigPicturesView

- (instancetype)init {
    if (self = [super init]) {
        [self scrollView];
        [self pageControl];
        [self backBtn];
        [self forwardBtn];
        [self characterLabel];
        [self englishNameLabel];
        [self nameLabel];
    }
    return self;
}

- (void)reloadData {
    [self.superview layoutIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItems)] && [self.delegate respondsToSelector:@selector(imageForItemAtIndex:)]) {
        
        NSInteger itemsNumber = [self.delegate numberOfItems];
        CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.bounds);
        CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.bounds);
        
        //设置pegeControl
        self.pageControl.numberOfPages = itemsNumber;
        //设置scrollView的contentSize以及数据显示
        self.scrollView.contentSize = CGSizeMake(itemsNumber * scrollViewWidth, scrollViewHeight);
        for (int i = 0; i < [self.delegate numberOfItems]; i ++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
            
            [self.scrollView addSubview:iv];
            iv.image = [self.delegate imageForItemAtIndex:i];
        }
    }
}

- (void)setNameLabel:(NSString *)nameString enString:(NSString *)enString andIntroductionString:(NSString *)introductionString {
    self.nameLabel.text = nameString;
    
    self.englishNameLabel.text = [NSString stringWithFormat:@"英文: %@", enString];
    
    [self.characterLabel setText:introductionString lineSpacing:8];
    self.characterLabel.text = introductionString;
}
#pragma mark 底部按钮的实现方法
- (void)dismissVC {
    [self.delegate dismissVC];
}

- (void)beginScrollPics {
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x;
    if (scrollViewOffsetX < (self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds))) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), 0);
        }];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
}

#pragma mark lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        [self insertSubview:_pageControl aboveSubview:self.scrollView];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-50);
            make.width.mas_equalTo(200);
            make.centerX.mas_equalTo(self.centerX);
            make.height.mas_equalTo(50);
        }];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:247 / 255.0 green:232 / 255.0 blue:90 / 255.0 alpha:1];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    }
    return _pageControl;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self insertSubview:_backBtn aboveSubview:self.scrollView];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(64);
            make.centerY.mas_equalTo(self.pageControl.mas_centerY);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UIButton *)forwardBtn {
    if (!_forwardBtn) {
        _forwardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self insertSubview:_forwardBtn aboveSubview:self.scrollView];
        [_forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-64);
            make.centerY.mas_equalTo(self.pageControl.mas_centerY);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        [_forwardBtn setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
        [_forwardBtn addTarget:self action:@selector(beginScrollPics) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardBtn;
}

- (UILabel *)characterLabel {
    if (!_characterLabel) {
        _characterLabel = [UILabel new];
        [self insertSubview:_characterLabel aboveSubview:self.scrollView];
        [_characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.pageControl.mas_top).mas_offset(-50);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-50);
        }];
        _characterLabel.numberOfLines = 0;
        _characterLabel.textColor = [UIColor whiteColor];
        _characterLabel.textAlignment = NSTextAlignmentLeft;
        
        _characterLabel.font = [UIFont fontWithName:@"PingFang TC" size:15];
        if (@available(iOS 8.2, *)) {
            _characterLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        } else {
            // Fallback on earlier versions
        }
    }
    return _characterLabel;
}

- (UILabel *)englishNameLabel {
    if (!_englishNameLabel) {
        _englishNameLabel = [UILabel new];
        [self insertSubview:_englishNameLabel aboveSubview:self.scrollView];
        [_englishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.characterLabel.mas_left);
            make.bottom.mas_equalTo(self.characterLabel.mas_top).mas_offset(-20);
        }];
        _englishNameLabel.textColor = [UIColor whiteColor];
        _englishNameLabel.font = [UIFont fontWithName:@"Noteworthy" size:20];
        if (@available(iOS 8.2, *)) {
            _englishNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
        } else {
            // Fallback on earlier versions
        }
        _englishNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _englishNameLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [self insertSubview:_nameLabel aboveSubview:self.scrollView];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.characterLabel.mas_left);
            make.bottom.mas_equalTo(self.englishNameLabel.mas_top).mas_offset(-10);
        }];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"Noteworthy" size:60];
        if (@available(iOS 8.2, *)) {
            _nameLabel.font = [UIFont systemFontOfSize:60 weight:UIFontWeightLight];
        } else {
            // Fallback on earlier versions
        }
        _nameLabel.textAlignment = NSTextAlignmentLeft;

    }
    return _nameLabel;
}
@end
