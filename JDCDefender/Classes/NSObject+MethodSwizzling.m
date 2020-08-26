//
//  NSObject+MethodSwizzling.m
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/25.
//  Copyright © 2020 江德春. All rights reserved.
//

#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>
@implementation NSObject (MethodSwizzling)
//交换两个类方法的实现
+(void)yscDefenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass{
    swizzlingClassMethod(targetClass, originalSelector, swizzledSelector);
}
//交换两个对象方法的实现
+(void)yscDefenderSwizzlingInstanceMethod:(SEL)originalSelector withMehtod:(SEL)swizzledSelector withClass:(Class)targetClass{
    swizzlingInstanceMethod(targetClass, originalSelector, swizzledSelector);
}
//交换两个类方法的实现C函数
void swizzlingClassMethod(Class class,SEL originalSelector,SEL swizzledSelector){
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else
        method_exchangeImplementations(originalMethod, swizzledMethod);
}
//交换两个对象方法的实现C函数
void swizzlingInstanceMethod(Class class,SEL originalSelector,SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else
        method_exchangeImplementations(originalMethod, swizzledMethod);
}
@end
