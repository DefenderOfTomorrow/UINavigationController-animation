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

static inline void zn_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

static inline BOOL zn_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}


+ (void)load{
    Method pushMethod = class_getInstanceMethod([self class], @selector(pushToVC:));
    if (zn_addMethod([self class], @selector(pushToVC:), pushMethod)) {
        zn_swizzleSelector([self class], @selector(pushViewController:animated:), @selector(pushToVC:));
    }
    
    Method popMethod = class_getInstanceMethod([self class], @selector(pop));
    if (zn_addMethod([self class], @selector(pop), popMethod)) {
        zn_swizzleSelector([self class], @selector(popViewControllerAnimated:), @selector(pop));
    }
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
