//
//  WebViewController.m
//  WebViewStructure
//
//  Created by Company on 2018/8/9.
//  Copyright © 2018年 Company. All rights reserved.
//

#import "WebViewController.h"
#import "Reachability.h"
#import <WebKit/WebKit.h>
#import "WDTabButton.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "WDObserverMgr.h"
#import "WDHeader.h"

typedef NS_ENUM(NSInteger, ConnectTimes) {
    FirstTime,
    NotFirstTIme
};

@interface WebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) NSString *webViewURL;
@property (nonatomic, weak) WKBackForwardListItem *currentItem;
@property (assign, nonatomic) NetworkStatus netStatus;

@property (nonatomic) Reachability *hostReachability;//域名检查

@property (assign, nonatomic) BOOL isLoadFinish;//是否加载完成
@property (assign, nonatomic) BOOL isLandscape;//是否横屏

@property (strong, nonatomic) WKWebView *webView;//主体网页
@property (strong, nonatomic) UIView *noNetView;//无网络提示 视图

@property (strong, nonatomic) UIAlertView *alertView;//退出 确认 警告框
@property (strong, nonatomic) UIView *bottomBarView;//底部导航栏视图
@property (assign, nonatomic) BOOL resFlag;
//是否是首次测试网络连接
@property (nonatomic , assign) ConnectTimes connectTimes;
@end

@implementation WebViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _connectTimes = FirstTime;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.webViewURL = webViewURL;
    [self createStructureView];
    [self createWebView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
    
    [self observer];

}

#pragma mark -

- (void)observer {
    [self monitorNetStatus];
    WEAKSELF
    [[WDObserverMgr mgr] addObj:self.webView keyPath:@"estimatedProgress" block:^(NSDictionary *change) {
        STRONGSELF
        if (self.resFlag) {
            if ([change[NSKeyValueChangeNewKey] floatValue] >= 1) [SVProgressHUD dismiss];
        }
    }];
    
    [[WDObserverMgr mgr] addObj:self keyPath:@"netStatus" block:^(NSDictionary *change) {
        STRONGSELF
        if ([change[NSKeyValueChangeNewKey] integerValue] == NotReachable) {
            [SVProgressHUD showErrorWithStatus:@"网络开小差了..."];
            if (!self.isLoadFinish) self.noNetView.hidden = NO;
        }
        if ([change[NSKeyValueChangeOldKey] integerValue] == NotReachable
            && [change[NSKeyValueChangeNewKey] integerValue] != NotReachable) {
            [self reConnect];
        }
    }];
}

#pragma mark - ------ UI ------
- (void)createStructureView {
    [self createBottomBarView];
    [self createNoNetView];
}

- (void)createBottomBarView {
    self.bottomBarView = [UIView new];
    [self.view addSubview:self.bottomBarView];
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    
    UIView *blankView = [UIView new];
    [self.bottomBarView addSubview:blankView];
    [blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bottomBarView);
        make.height.mas_equalTo(kBottomSafeHeight);
    }];

    NSArray *btnIcons = @[@"cc",@"aa",@"bb",@"ee",@"dd"];
    NSArray *btnNames = @[@"首页",@"后退",@"前进",@"刷新",@"退出"];
    UIButton *lastBtn = nil;
    for (int i = 0, l = (int)btnIcons.count; i < l; ++i) {
        WDTabButton *btn = [WDTabButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(goingBT:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        btn.tag = 200 + i;
        [btn setImage:[UIImage imageNamed:btnIcons[i]] forState:UIControlStateNormal];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@49);
            make.bottom.equalTo(blankView.mas_top);
            make.top.equalTo(self.bottomBarView.mas_top);
            
            if (lastBtn) {
                make.left.equalTo(lastBtn.mas_right);
                make.width.equalTo(lastBtn);
            } else {
                make.left.equalTo(self.bottomBarView.mas_left);
            }
            if (i == btnIcons.count - 1) {
                make.right.equalTo(self.bottomBarView.mas_right);
            }
        }];
        lastBtn = btn;
    }
}

- (void)createNoNetView {
    self.noNetView = [UIView new];
    self.noNetView.backgroundColor = WDRGB(234, 234, 234, 1);
    [self.view addSubview:self.noNetView];
    [self.noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomBarView.mas_top);
        make.top.equalTo(self.view);
    }];
    
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"NoNet"];
    [self.noNetView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.noNetView);
        make.width.height.equalTo(@222);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(againBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击重试" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:WDRGB(235, 32, 32, 1) forState:UIControlStateNormal];
    [self.noNetView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom);
        make.width.equalTo(@158);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.noNetView);
    }];
    self.noNetView.hidden = YES;
}

- (void)createWebView {
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc]init];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    webViewConfig.preferences = preferences;
    
    webViewConfig.allowsInlineMediaPlayback = YES;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:webViewConfig];
    [self.view insertSubview:self.webView belowSubview:self.noNetView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomBarView.mas_top);
    }];
}

#pragma mark - ------ 底部 导航栏 ------
- (void)goingBT:(UIButton *)sender {
    if (sender.tag ==200) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
    }else if (sender.tag ==201) {
        if ([self.webView canGoBack]) {
            NSMutableArray *arr = [self.webView.backForwardList.backList mutableCopy];
            WKBackForwardListItem *lastOne = self.webView.backForwardList.backList.lastObject;
            if ([lastOne.URL.absoluteString containsString:@"companystyle="]
                && [lastOne.URL.absoluteString containsString:@"uid="]) {
                [arr removeLastObject];
                [self.webView goToBackForwardListItem:[arr lastObject]];
                return;
            }
            [self.webView goBack];
        }
    }else if (sender.tag ==202) {
        if ([self.webView canGoForward]) [self.webView goForward];
    }else if (sender.tag ==203) {
        [self.webView reload];
    }else if (sender.tag ==204) {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"是否退出？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [self.alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        [WDUtil_Web cleanCacheAndCookie];
        exit(0);
    }
}

#pragma mark - ------ 网络监听 ------
- (void)againBTAction:(UIButton *)sender {
    if ([self.hostReachability currentReachabilityStatus] == NotReachable) {
        //无网络连接
    }else {
        [self reConnect];
    }
}

- (void)reConnect {
    self.noNetView.hidden = YES;
    self.isLoadFinish = NO;
    
    if (self.currentItem) {
        [self.webView goToBackForwardListItem:self.currentItem];
    }
}

-(void)monitorNetStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    self.netStatus = netStatus;
    if (self.netStatus == NotReachable) {
        //如果没网络，显示当前页面，不显示重连页面
        if (self.connectTimes == FirstTime) {
            self.noNetView.hidden  = NO;
        }else {
            self.noNetView.hidden = YES;
        }
    }else {
        //如果有网
        self.webView.hidden = NO;
        self.noNetView.hidden = YES;
        if (self.connectTimes == FirstTime) {
//            [self reConnect];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
            self.connectTimes =  NotFirstTIme;
        }
        
    }
}

#pragma mark - ------ 横竖屏相关 ------
-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)doRotateAction:(NSNotification *)notification {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait: {
            self.bottomBarView.hidden = NO;
            
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(kStatusBarHeight);
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.bottomBarView.mas_top);
            }];
            
            self.isLandscape = NO;
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight: {
            self.bottomBarView.hidden = YES;
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self.view);
            }];
            
            self.isLandscape = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark -
- (void)cleanCacheAndCookie {
    
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
    
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >8) {
        if (@available(iOS 9.0, *)) {
            NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
            NSSet *websiteDataTypes = [NSSet setWithArray:types];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                
            }];
        }
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

#pragma mark -
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
  forNavigationAction:(WKNavigationAction *)navigationAction
       windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame || !navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
#if(0)
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
#endif
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)handleAlipayScheme:(NSURLRequest *)request {
    NSString *urlStr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlStr containsString:@"alipays://"]) {
        NSRange range = [urlStr rangeOfString:@"alipays://"];
        NSString * subString = [urlStr substringFromIndex:range.location];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:subString]];
    } else if ([urlStr containsString:@"scheme="]) {
        NSRange range = [urlStr rangeOfString:@"scheme="];
        NSString * subString = [urlStr substringFromIndex:range.location+range.length];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:subString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.resFlag = YES;
    self.isLoadFinish = NO;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self openOtherAppWithUIWebView:webView];
}

- (void)openOtherAppWithUIWebView:(WKWebView *)webView {
    
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple"]
        ||[webView.URL.absoluteString hasPrefix:@"https://apps.apple"]) {
        [[UIApplication sharedApplication] openURL:webView.URL];
    } else {
        if (![webView.URL.absoluteString hasPrefix:@"http"]) {
            NSArray *whitelist = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"LSApplicationQueriesSchemes"];
            for (NSString * whiteName in whitelist) {
                NSString *rulesString = [NSString stringWithFormat:@"%@://",whiteName];
                if ([webView.URL.absoluteString hasPrefix:rulesString]){
                    [[UIApplication sharedApplication] openURL:webView.URL];
                }
            }
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.isLoadFinish = YES;
    self.currentItem = webView.backForwardList.currentItem;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.resFlag = NO;
    [SVProgressHUD showErrorWithStatus:@"加载失败..." duration:4];
    
    if (!self.noNetView.hidden || error.code == -1002) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark -
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
