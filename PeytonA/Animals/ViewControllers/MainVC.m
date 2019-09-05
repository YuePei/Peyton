//
//  MainVC.m
//  PeytonA
//
//  Created by Company on 2019/8/19.
//  Copyright © 2019 Company. All rights reserved.
//

#import "MainVC.h"
#import "DataSource.h"
#import "MainCollectionViewCell.h"
#import "BigPictureVC.h"
#import "TransitionAnimation.h"
#import "DismissTransitionAnimation.h"

#define Screen_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define Screen_Height CGRectGetHeight([UIScreen mainScreen].bounds)

static const float leftInset = 10;
static const float rightInset = 10;
static const float topInset = 10;
static const float bottomInset = 10;
static const float lineSpacing = 10;
static const float interitemSpacing = 20;

NSString *const reuseID = @"mainPageCell";

@interface MainVC ()<UIViewControllerTransitioningDelegate>
//背景图
@property (nonatomic, strong)UIImageView *backgroundImageView;
//collectionView
@property (nonatomic, strong)UICollectionView *collectionView;
//dataSource
@property (nonatomic, strong)DataSource *dataSource;
//transtionAnimation
@property (nonatomic, strong)TransitionAnimation *transitionAnimation;
//
@property (nonatomic, strong)DismissTransitionAnimation *dismissTransitionAnimation;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
    _transitionAnimation = [[TransitionAnimation alloc]init];
    _dismissTransitionAnimation = [DismissTransitionAnimation new];
}

#pragma mark
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {

    return self.transitionAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissTransitionAnimation;
}
#pragma mark lazy
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
//        _backgroundImageView.image = [UIImage imageNamed:@"bgImage"];
        _backgroundImageView.backgroundColor = [UIColor colorWithRed:39 / 255.0 green:52 / 255.0 blue:43 / 255.0 alpha:0.8];
    }
    return _backgroundImageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = lineSpacing;
        flowLayout.minimumInteritemSpacing = interitemSpacing;
        flowLayout.sectionInset = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
        float estimateWidth = (Screen_Width - leftInset - rightInset - interitemSpacing * 2 - 5 ) / 3.0;
        flowLayout.itemSize = CGSizeMake(estimateWidth, estimateWidth);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view insertSubview:_collectionView aboveSubview:self.backgroundImageView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = (id<UICollectionViewDelegate>)self.dataSource;
        _collectionView.dataSource = (id<UICollectionViewDataSource>)self.dataSource;
        [_collectionView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseID];
    }
    return _collectionView;
}

- (DataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[DataSource alloc]initWithReuseID:reuseID andConfigureCellBlock:^(MainCollectionViewCell* _Nonnull cell, NSString *  _Nonnull m) {
            //配置cell
            cell.imageView.image = [UIImage imageNamed:m];
        }];
        __weak typeof(self) weakSelf = self;
        [_dataSource setSelectedCellBlock:^(UICollectionView * _Nonnull collectionView, MainCollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, AModel *model) {
            __strong typeof(self) strongSelf = weakSelf;
            BigPictureVC* vc = [BigPictureVC new];
            vc.animalModel = model;
            vc.transitioningDelegate = strongSelf;
            [strongSelf presentViewController:vc animated:YES completion:^{
                //加载大图页面完成
            }];
        }];
    }
    return _dataSource;
}
@end
