//
//  BigPicturesView.h
//  PeytonA
//
//  Created by Peyton on 2019/8/21.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BigPicDelegate <NSObject>

@required
- (NSInteger )numberOfItems;
- (UIImage *)imageForItemAtIndex:(NSInteger )index;

- (void)dismissVC;

@end
@interface BigPicturesView : UIView

//delegate
@property (nonatomic, weak)id<BigPicDelegate> delegate;

- (void)reloadData;

- (void)setNameLabel:(NSString *)nameString enString:(NSString *)enString andIntroductionString:(NSString *)introductionString;

@end

NS_ASSUME_NONNULL_END
