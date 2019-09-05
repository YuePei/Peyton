//
//  CCObserverManager.m
//  PeytonA
//
//  Created by Peyton on 2019/9/4.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "CCObserverManager.h"

@interface CCAsscsadsdasd : NSObject
@property (strong, nonatomic) NSMutableDictionary<NSString *, ObBlock> *handlers;
@end
@implementation CCAsscsadsdasd
@end

@interface CCObserverManager()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, CCAsscsadsdasd *> *subscribers;

@end

@implementation CCObserverManager

- (void)addObject:(NSObject *)object andKP:(NSString *)kp block:(ObBlock)handler {
    [object addObserver:self forKeyPath:kp options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    NSNumber *key = @(object.hash);
    CCAsscsadsdasd *ass = [self fetchSubscriber:key];
    [ass.handlers setValue:handler forKey:kp];
    
    [self.subscribers setObject:ass forKey:@(object.hash)];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSObject *obj = (NSObject *)object;
    NSNumber *key = @(obj.hash);
    if (![self.subscribers.allKeys containsObject:key]) return;
    CCAsscsadsdasd *ass = self.subscribers[key];
    
    if (![ass.handlers.allKeys containsObject:keyPath]) return;
    ObBlock handler = ass.handlers[keyPath];
    handler(change);
}

#pragma mark toolMethods
- (CCAsscsadsdasd *)fetchSubscriber:(NSNumber *)key {
    CCAsscsadsdasd *ass;
    if ([self.subscribers.allKeys containsObject:key]) {
        ass = self.subscribers[key];
    } else {
        ass = [CCAsscsadsdasd new];
        ass.handlers = [NSMutableDictionary new];
    }
    return ass;
}

+ (instancetype)manager {
    static CCObserverManager *manager = nil;
    static dispatch_once_t ccManager;
    dispatch_once(&ccManager, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSMutableDictionary *)subscribers {
    if (!_subscribers) {
        _subscribers = [NSMutableDictionary dictionary];
    }
    return _subscribers;
}
@end
