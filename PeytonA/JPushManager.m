//
//  JPushManager.m
//  WebViewStructure
//
//  Created by Company on 2018/8/9.
//  Copyright © 2018年 Company. All rights reserved.
//

#import "JPushManager.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface JPushManager()<JPUSHRegisterDelegate, UNUserNotificationCenterDelegate>
@end

@implementation JPushManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JPushManager alloc] init];
    });
    return sharedInstance;
}

+ (void)configJPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    JPushManager *mgr = [JPushManager sharedInstance];
    
    application.applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories, NSSet<UNNotificationCategory *> *categories for iOS10 or later, NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:mgr];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //iOS10必须加下面这段代码。
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=mgr;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      //点击允许
                                      //这里可以添加一些自己的逻辑
                                  } else {
                                      //点击不允许
                                      //这里可以添加一些自己的逻辑
                                  }
                              }];
    }
}

#pragma mark - application - delegate
+ (void)handleRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support;
    // For systems with less than or equal to iOS6 -> no block
    [JPUSHService handleRemoteNotification:userInfo];
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)())completionHandler {
    // Required
    if (@available(iOS 10, *)) {
        NSDictionary * userInfo = response.notification.request.content.userInfo;
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler();  // 系统要求执行这个方法
    }
}

@end
