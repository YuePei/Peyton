//
//  MainVC.m
//  PeytonA
//
//  Created by Peyton on 2019/8/19.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "MainVC.h"
#import "DataSource.h"
#import "MainCollectionViewCell.h"
#import "BigPictureVC.h"


#define Screen_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define Screen_Height CGRectGetHeight([UIScreen mainScreen].bounds)

static const float leftInset = 10;
static const float rightInset = 10;
static const float topInset = 10;
static const float bottomInset = 10;
static const float lineSpacing = 10;
static const float interitemSpacing = 5;

NSString *const reuseID = @"mainPageCell";

@interface MainVC ()
//背景图
@property (nonatomic, strong)UIImageView *backgroundImageView;
//collectionView
@property (nonatomic, strong)UICollectionView *collectionView;
//dataSource
@property (nonatomic, strong)DataSource *dataSource;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
    
}

#pragma mark lazy
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        _backgroundImageView.image = [UIImage imageNamed:@"bgImage"];
//        _backgroundImageView.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:31 / 255.0 blue:29 / 255.0 alpha:0.8];
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
            [strongSelf presentViewController:vc animated:YES completion:^{
                //加载大图页面完成
            }];
        }];
    }
    return _dataSource;
}
@end