//
//  NSDictionary+Hook.m
//  FBSnapshotTestCase
//
//  Created by 江德春 on 2020/8/31.
//

#import "NSDictionary+Hook.h"
#import "NSObject+MethodSwizzling.h"
#import "UIViewController+Swizzling.h"

#pragma mark----设置NSDictionay
@implementation NSDictionary (Hook)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject methodSwizzlingWithClass:self originSelector:@selector(initWithObjects:forKeys:count:) toSwizzledSelector:@selector(hook_initWithObjects:forKeys:count:)];
        [NSObject methodSwizzlingWithClass:self originSelector:@selector(dictionaryWithObjects:forKeys:count:) toSwizzledSelector:@selector(hook_dictionaryWithObjects:forkeys:count:)];
    });
}
//字典,类方法的调用,取出所有的key和value来进行比对，是否有为空
+ (instancetype)hook_dictionaryWithObjects:(const id[])objects forkeys:(const id<NSCopying> [])keys count:(NSUInteger)count{
    id safeObjects[count];
    id safeKeys[count];
    NSUInteger j =0;
    for (NSInteger i=0; i<count; i++) {
        id key = keys[i];
        id obj = objects[i];
        //如果key或value有为空的情况,就跳过去
        if (!key || !obj) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"遇到为nil的情况"];
#else
#endif
            //跳过
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
     }
    return [self hook_dictionaryWithObjects:safeObjects forkeys:safeKeys count:count];
}

//对象方法 在这里对数据进行重组，针对数据为空的情况，处理方式同上
- (instancetype)hook_initWithObjects:(const id [])objects forKeys:(const id<NSCopying>[])keys count:(NSUInteger)count{
    id safeObjects[count];
    id safeKeys[count];
    NSUInteger j =0;
    for (NSInteger i=0; i<count; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"遇到为nil的情况"];
#else
#endif
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self hook_initWithObjects:objects forKeys:keys count:count];
}
@end

#pragma mark----设置NSMutableDic
@implementation NSMutableDictionary (Hook)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取可变字典的类名。调用方法进行交换
        Class class = NSClassFromString(@"__NSDictionaryM");
        [NSObject methodSwizzlingWithClass:class originSelector:@selector(setObject:forKey:) toSwizzledSelector:@selector(hook_setObject:forKey:)];
      
        [NSObject methodSwizzlingWithClass:class originSelector:@selector(setObject:forKeyedSubscript:) toSwizzledSelector:@selector(hook_setObject:forKeyedSubscript:)];
        
    });
}

- (void)hook_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey || !anObject) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"遇到为nil的情况"];
#else
#endif
        NSLog(@"遇到为nil的情况，执行一次");
        return;
    }
    [self hook_setObject:anObject forKey:aKey];
}

- (void)hook_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
   
    if (!key || !obj) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"遇到为nil的情况"];
#else
#endif
        NSLog(@"遇到为nil的情况，执行一次");
        return;
    }
    [self hook_setObject:obj forKeyedSubscript:key];
}
@end
