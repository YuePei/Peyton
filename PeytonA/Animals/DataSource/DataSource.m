//
//  DataSource.m
//  PeytonA
//
//  Created by Company on 2019/8/19.
//  Copyright © 2019 Company. All rights reserved.
//

#import "DataSource.h"
#import "AnimalsModel.h"
#import "MJExtension.h"

@interface DataSource()<UICollectionViewDataSource, UICollectionViewDelegate>
//reuseID
@property (nonatomic, strong)NSString *reuseID;
//configureCellBlock
@property (nonatomic, copy)ConfigurationCellBlock configureCellBlock;
//selectCellBlock
@property (nonatomic, copy)SelectCellBlock selectCellBlock;
//model
@property (nonatomic, strong)AnimalsModel *animalsModel;
@end

@implementation DataSource
- (instancetype)initWithReuseID:(NSString *)reuseID andConfigureCellBlock:(ConfigurationCellBlock )block {
    if (self = [super init]) {
        self.reuseID = reuseID;
        self.configureCellBlock = block;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Animal" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        //dic 转model
        _animalsModel = [AnimalsModel mj_objectWithKeyValues:dic];
    }
    return self;
}

- (void)setSelectedCellBlock:(SelectCellBlock)block {
    self.selectCellBlock = block;
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.animalsModel.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseID forIndexPath:indexPath];
    AModel *m = self.animalsModel.datas[indexPath.row];
    self.configureCellBlock(cell, m.mainImage);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    self.selectCellBlock(collectionView, cell, indexPath, self.animalsModel.datas[indexPath.row]);
}
@end
