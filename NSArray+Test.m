//
//  NSArray+Test.m
//  FBSnapshotTestCase
//
//  Created by 江德春 on 2020/8/28.
//

#import "NSArray+Test.h"
#import <objc/runtime.h>
@implementation NSArray (Test)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         //获取要替换的系统方法
           Method sysMethod1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
           Method sysMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:));
           //添加自己的方法
           Method selfMethod1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(ly_objectAtIndex:));
           Method selfMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(ly_objectAtIndexedSubscript:));
           
           //实现方法交换
           method_exchangeImplementations(sysMethod1, selfMethod1);
           method_exchangeImplementations(sysMethod2, selfMethod2);
    });
}
#pragma mark - Action && Notification
-(id)ly_objectAtIndex:(NSInteger)index{
    
    if (self.count - 1 < index) {
        
        @try {
            return [self ly_objectAtIndex:index];
        } @catch (NSException *exception) {
            
            NSLog(@"---------- %s Crash Because Method %s ----------\n",class_getName(self.class),__func__);
            NSLog(@"---------- %@",[exception callStackSymbols]);
            return nil;
            
        } @finally {
            NSLog(@"nothing to do");
        }
        
    }else{
        return [self ly_objectAtIndex:index];
    }
    
}

-(id)ly_objectAtIndexedSubscript:(NSInteger)index{
    
    if (self.count - 1 < index) {
        
        @try {
            return [self ly_objectAtIndex:index];
        } @catch (NSException *exception) {
            
            NSLog(@"---------- %s Crash Because Method %s ----------\n",class_getName(self.class),__func__);
            NSLog(@"---------- %@",[exception callStackSymbols]);
            return nil;
            
        } @finally {
            NSLog(@"nothing to do");
        }
        
    }else{
        return [self ly_objectAtIndex:index];
    }
    
}

@end
