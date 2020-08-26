//
//  NSObject+SelectorDefender.m
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/26.
//  Copyright © 2020 江德春. All rights reserved.
//

#import "NSObject+SelectorDefender.h"
#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>
@implementation NSObject (SelectorDefender)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //拦截 +forwardingTargetForSelector:方法 替换自定义实现
        [NSObject yscDefenderSwizzlingClassMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(ysc_forwardingTargetForSelector:) withClass:[NSObject class]];
        //拦截 '-forwardingTargetForSelector:方法'替换自定义实现
        [NSObject yscDefenderSwizzlingInstanceMethod:@selector(forwardingTargetForSelector:) withMehtod:@selector(ysc_forwardingTargetForSelector:) withClass:[NSObject class]];
    });
}
//自定义实现+ysc_forwardingTargetForSelector:方法
+ (id)ysc_forWardingTargetForSelector:(SEL)aSelector{
    Class class = [self class];
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    //获取NSObject的消息转发方法
    Method root_forwarding_method = class_getClassMethod([NSObject class], forwarding_sel);
    //获取当前类的消息转发方法
    Method current_forwarding_method = class_getClassMethod(class, forwarding_sel);
    //判断当前类本身是否实现第二步:消息接收者重定向
    BOOL realize = method_getImplementation(current_forwarding_method)!=method_getImplementation(root_forwarding_method);
    //如果没有实现第二步:消息接收者重定向
    if (!realize) {
        //判断有没有实现第三步：消息重定向
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        Method root_methodSignalture_method = class_getClassMethod([NSObject class], methodSignature_sel);
        Method current_methodSignalture_method = class_getClassMethod(class, methodSignature_sel);
        realize = method_getImplementation(current_methodSignalture_method)!=method_getImplementation(root_methodSignalture_method);
        //如果没有实现第三步:消息重定向
        if (!realize) {
            //创建一个类
            NSString *errClassName = NSStringFromClass(class);
            NSString *errSel = NSStringFromSelector(aSelector);
            NSLog(@"*** Crash Message: +[%@ %@]: unrecognized selector sent to class %p ***",errClassName, errSel, self);
            NSString *className = @"CrashClass";
            Class cls = NSClassFromString(className);
            //如果类不存在 动态创建一个类
            if (!cls) {
                Class superClass = [NSObject class];
                cls = objc_allocateClassPair(superClass, className.UTF8String, 0);
                //注册类
                objc_registerClassPair(cls);
            }
            //如果类没有对应的方法，则动态添加一个
            if (!class_getInstanceMethod(NSClassFromString(className), aSelector)) {
                class_addMethod(cls, aSelector, (IMP)Crash, "@@:@");
            }
            //把消息转发到当前动态生成类的实例对象上
            return [[cls alloc]init];
        }
    }
    return [self ysc_forWardingTargetForSelector:aSelector];
    
}
//自定义实现-ysc_forwardingTargetForSelector:方法
- (id)ysc_forwardingTargetForSelector:(SEL)aSelector{
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    Class class = [self class];
    //获取object 的消息转发方法
    Method root_forwarding_method = class_getInstanceMethod([NSObject class], forwarding_sel);
    //获取当前类 的消息转发方法
    Method current_forwarding_method = class_getInstanceMethod(class, forwarding_sel);
    //判断当前类本市是否实现第二步，消息接受者重定向
    BOOL realize = method_getImplementation(current_forwarding_method)!=method_getImplementation(root_forwarding_method);
    if (!realize) {
        //判断也没有实现第三步：消息重定向
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        Method root_methodSignature_method = class_getInstanceMethod([NSObject class], methodSignature_sel);
        Method current_methodSignature_method = class_getInstanceMethod(class, methodSignature_sel);
        realize = method_getImplementation(current_methodSignature_method)!=method_getImplementation(root_methodSignature_method);
        //如果没有实现第三步:消息重定向
        if (realize) {
            //创建一个新类
            NSString *errClassName = NSStringFromClass(class);
            NSString *errSel = NSStringFromSelector(aSelector);
            NSLog(@"*** Crash Message: +[%@ %@]: unrecognized selector sent to class %p ***",errClassName, errSel, self);
            NSString *className = @"CrashClass";
            Class cls = NSClassFromString(className);
            if (!cls) {
                Class superClass = [NSObject class];
                cls = objc_allocateClassPair(superClass, className.UTF8String, 0);
                objc_registerClassPair(cls);
            }
            //如果类没有对应的方法，则动态添加一个
            if (!class_getInstanceMethod(NSClassFromString(className), aSelector)) {
                class_addMethod(cls, aSelector, (IMP)Crash, "@@:@");
            }
            //把消息转发到当前动态生成类的实例对象上
            return [[cls alloc] init];
        }
    }
    return [self ysc_forwardingTargetForSelector:aSelector];
}
//动态添加的方法实现
static int Crash(id slf,SEL selector){
    return 0;
}
@end
