//
//  TransitionAnimation.m
//  PeytonA
//
//  Created by Company on 2019/8/26.
//  Copyright © 2019 乐培培. All rights reserved.
//

#import "TransitionAnimation.h"


@implementation TransitionAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
    CGRect toViewRect = toView.frame;
    toView.frame = CGRectOffset(toViewRect, 0, CGRectGetHeight([UIScreen mainScreen].bounds));
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toView.frame = toViewRect;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}



@end
