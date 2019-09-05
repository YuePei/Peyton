//
//  CCWebSetting.m
//  PeytonA
//
//  Created by Peyton on 2019/9/4.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "CCWebSetting.h"
#import <WebKit/WebKit.h>

@implementation CCWebSetting

+ (void)deleteStores {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    if (@available(iOS 9.0, *)) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *path = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}
@end
