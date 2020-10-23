//
//  NSObject+KVCDefender.m
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/26.
//  Copyright © 2020 江德春. All rights reserved.
//

#import "NSObject+KVCDefender.h"
#import "NSObject+MethodSwizzling.h"
#import "UIViewController+Swizzling.h"
@implementation NSObject (KVCDefender)
// 不建议拦截 `setValue:forKey:` 方法，会影响系统逻辑判断
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // 拦截 `setValue:forKey:` 方法，替换自定义实现
        [NSObject yscDefenderSwizzlingInstanceMethod:@selector(setValue:forKey:) withMethod:@selector(ysc_setValue:forKey:) withClass:[NSObject class]];
    });
}

- (void)ysc_setValue:(id)value forKey:(NSString *)key {
    if (key == nil) {
        NSString *crashMessages = [NSString stringWithFormat:@"*** Crash Message: [<%@ %p> setNilValueForKey]: could not set nil as the value for the key %@. ***",NSStringFromClass([self class]),self,key];
        NSLog(@"%@", crashMessages);
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:crashMessages];
#else
#endif
        return;
    }

    [self ysc_setValue:value forKey:key];
}

- (void)setNilValueForKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"*** Crash Message: [<%@ %p> setNilValueForKey]: could not set nil as the value for the key %@. ***",NSStringFromClass([self class]),self,key];
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:crashMessages];
#else
#endif
    NSLog(@"%@", crashMessages);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"*** Crash Message: [<%@ %p> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key: %@,value:%@'. ***",NSStringFromClass([self class]),self,key,value];
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:crashMessages];
#else
#endif
    NSLog(@"%@", crashMessages);
}

- (nullable id)valueForUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"*** Crash Message: [<%@ %p> valueForUndefinedKey:]: this class is not key value coding-compliant for the key: %@. ***",NSStringFromClass([self class]),self,key];
    NSLog(@"%@", crashMessages);
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:crashMessages];
#else
#endif
    return self;
}
@end
