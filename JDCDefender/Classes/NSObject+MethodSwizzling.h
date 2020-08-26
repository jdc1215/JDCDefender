//
//  NSObject+MethodSwizzling.h
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/25.
//  Copyright © 2020 江德春. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MethodSwizzling)
/*交换两个类方法的实现
 @param originalSelector 原始方法的SEL
 @param swizzledSelector 交换方法的SEL
 @param targetClass 类
 */
+(void)yscDefenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

/*交换两个对象方法的实现
@param originalSelector 原始方法的SEL
@param swizzledSelector 交换方法的SEL
@param targetClass 类
*/
+(void)yscDefenderSwizzlingInstanceMethod:(SEL)originalSelector withMehtod:(SEL)swizzledSelector withClass:(Class)targeClass;
@end

// 判断是否是系统类
static inline BOOL isSystemClass(Class cls) {
    BOOL isSystem = NO;
    NSString *className = NSStringFromClass(cls);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"__NS"] || [className hasPrefix:@"OS_xpc"]) {
        isSystem = YES;
        return isSystem;
    }
    NSBundle *mainBundle = [NSBundle bundleForClass:cls];
    if (mainBundle == [NSBundle mainBundle]) {
        isSystem = NO;
    }else{
        isSystem = YES;
    }
    return isSystem;
}
NS_ASSUME_NONNULL_END
