//
//  JPushManager.h
//  WebViewStructure
//
//  Created by Company on 2018/8/9.
//  Copyright © 2018年 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushManager : NSObject

+ (void)configJPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

+ (void)handleRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+ (void)registerDeviceToken:(NSData *)deviceToken;

@end
