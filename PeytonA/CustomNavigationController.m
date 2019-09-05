

//
//  CustomNavigationController.m
//  CustomNavigationController
//
//  Created by Peyton on 2018/3/19.
//  Copyright © 2018年 Peyton. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize {
    // 设置导航items数据主题
    [self setupNavigationItemsTheme];
    
    // 设置导航栏主题
    [self setupNavigationBarTheme];
}


#pragma mark -  设置导航items数据主题
+ (void)setupNavigationItemsTheme {
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    // 设置字体颜色
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} forState:UIControlStateHighlighted];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    
}

#pragma mark -  设置导航栏主题
+ (void)setupNavigationBarTheme {
    UINavigationBar * navBar = [UINavigationBar appearance];
    
    // 设置导航栏title属性
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // 设置导航栏颜色
    [navBar setBarTintColor:[UIColor brownColor]];
    
    UIImage *image = [UIImage imageNamed:@"nav_64"];
    
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


#pragma mark -  拦截所有push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        // 如果navigationController的字控制器个数大于两个就隐藏
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        //1.解决了自定义的返回按钮导致屏幕左侧的右滑手势失效的bug,但是首页右滑会导致crash
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = nil;
        }
        viewController.navigationItem.leftBarButtonItem =leftItem;
        
        //2.解决首页右滑会导致crash的bug
        UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeftGesture)];
        leftEdgeGesture.edges = UIRectEdgeLeft;
        [self.viewControllers[0].view addGestureRecognizer:leftEdgeGesture];
    }
    
    
    [super pushViewController:viewController animated:YES];
}

#pragma mark -  拦截所有pop方法
- (void)back {
    [super popViewControllerAnimated:YES];
    //这里就可以自行修改返回按钮的各种属性等
}

- (void)setLeftBarButtonItemWithImage:(UIImage *)image {
    
}

- (void)handleLeftGesture {
    
}
@end
