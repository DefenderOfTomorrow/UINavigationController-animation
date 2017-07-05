//
//  UINavigationController+animation.m
//  CATransition
//
//  Created by zzjq_Mac on 17/4/27.
//  Copyright © 2017年 zzjq_Mac. All rights reserved.
//

#import "UINavigationController+animation.h"
#import <objc/runtime.h>
@implementation UINavigationController (animation)

+ (void)load{
    Method M1 = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method M2 = class_getInstanceMethod([self class], @selector(pushToVC:));
    method_exchangeImplementations(M1, M2);
    
    Method M3 = class_getInstanceMethod([self class], @selector(popViewControllerAnimated:));
    Method M4 = class_getInstanceMethod([self class], @selector(pop));
    method_exchangeImplementations(M3, M4);
}

- (void)pushToVC:(UIViewController *)vc{
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.7;
    
    //设置运动type
    animation.type = @"rippleEffect";
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    animation.subtype = kCAGravityCenter;
    
    animation.removedOnCompletion = YES;
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animation"];

    [self pushToVC:vc];
}

- (UIViewController *)pop{
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.5;
    
    //设置运动type
    animation.type = @"suckEffect";
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    animation.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animation"];
    
    [self pop];
    
    return self.childViewControllers.lastObject;
}
@end
