//
//  UIViewController+Swizzling.m
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/24.
//  Copyright © 2020 江德春. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
@implementation UIViewController (Swizzling)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //当前类
        Class class = [self class];
        //原方法名 和 替换方法名
        SEL originalSelector = @selector(originalFunction);
        SEL swizzledSelector = @selector(swizzledFunction);
        //原方法结构体 和 替换方法结构体
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        /*
         如果当前类没有 原方法的IMP,说明在从父类继承过来的方法实现
         需要在当前类中添加一个originalSelector 方法
         但使用 替换方法swizzledMethod 去实现它
         */
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            //原方法的IMP 添加成功后 修改 替换方法的 IMP 为 原始方法的IMP
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            //添加失败(说明已经包含原方法的 IMP)，调用交换两个方法的实现
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
//原始方法
- (void)originalFunction{
    NSLog(@"originalFunction");
}
//替换方法
- (void)swizzledFunction{
    NSLog(@"swizzledFunction");
}
+ (void)showAlertViewWithMessage:(NSString *)message{
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
@end
