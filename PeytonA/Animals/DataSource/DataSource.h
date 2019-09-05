//
//  DataSource.h
//  PeytonA
//
//  Created by Company on 2019/8/19.
//  Copyright © 2019 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainCollectionViewCell.h"
#import "AnimalsModel.h"


NS_ASSUME_NONNULL_BEGIN

//配置cell的block
typedef void (^ConfigurationCellBlock) (MainCollectionViewCell *cell, id m);

//选择cell的block
typedef void (^SelectCellBlock)(UICollectionView *collectionView, MainCollectionViewCell *cell, NSIndexPath *indexPath, AModel *model);

@interface DataSource : NSObject

//init方法
- (instancetype)initWithReuseID:(NSString *)reuseID andConfigureCellBlock:(ConfigurationCellBlock )block;

- (void)setSelectedCellBlock:(SelectCellBlock )block;

@end

NS_ASSUME_NONNULL_END
