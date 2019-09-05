//
//  CCObserverManager.h
//  PeytonA
//
//  Created by Peyton on 2019/9/4.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCObserverManager : NSObject

typedef void(^ObBlock)(NSDictionary<NSKeyValueChangeKey,id> *changes);

+ (instancetype)manager;

- (void)addObject:(NSObject *)object andKP:(NSString *)kp block:(ObBlock)handler;



#pragma mark - 不让外部调用的方法

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
