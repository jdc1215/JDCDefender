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
            /*break 是结束整个循环,而continue是结束本次循环(跳过下一步)
                为了循环的继续，我们就必须选择continue
             */
            continue;
        }
        //每一个value对应一个key ,这个是相互对应的
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
     }
    //返回将nil的key&value清楚以后的dic;
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
        [class gl_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(gl_setObject:forKey:)];
        //为什么要使用下面的这个方法呢？
        [class gl_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(gl_setObject:forKeyedSubscript:)];
    });
}
//为什么在这里不讲顺序呢，这里直接使用teturn不会导致前期遍历到而导致返回，后面的数据
//int i;
- (void)gl_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    //疑问：字典里面就几个数据，但是在这里执行了几百次，我是百思不得姐，希望有朝一日能解开这个千古谜团。
    //    NSLog(@"可变数组到底调用执行了几次呢:%d",i++);
    
    if (!aKey || !anObject) {
        //结束整个函数，这里调用的数据是每次都已调用一次，这里如果改成coutinue呢? やめで ，必须要用到遍历循环中才可以使用。
        //如果这里我不做return处理呢，测试结果是崩溃，由此可以推断，可变数组中的数据是每次一对key/value进行监测的，然后遇到nil的数据就return，这样就不会返回nil的数据，相当于被过滤掉了。
        NSLog(@"遇到为nil的情况，执行一次");
        return;
    }
    [self gl_setObject:anObject forKey:aKey];
}

- (void)gl_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
   
    
    if (!key || !obj) {
        return;
        
    }
    [self gl_setObject:obj forKeyedSubscript:key];
}
@end
