//
//  AnimalsModel.h
//  PeytonA
//
//  Created by Peyton on 2019/8/22.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimalsModel : NSObject
//datas
@property (nonatomic, strong)NSArray *datas;

@end

@interface AModel : NSObject
//mainImage
@property (nonatomic, strong)NSString *mainImage;
//name
@property (nonatomic, strong)NSString *name;
//enName
@property (nonatomic, strong)NSString *enName;
//特点
@property (nonatomic, strong)NSString *characteristic;
//详情页的大图
@property (nonatomic, strong)NSArray *bigImages;

@end

NS_ASSUME_NONNULL_END
