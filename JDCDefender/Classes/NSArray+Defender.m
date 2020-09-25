//
//  NSArray+Defender.m
//  FBSnapshotTestCase
//
//  Created by 江德春 on 2020/8/28.
//

#import "NSArray+Defender.h"
#import "NSObject+MethodSwizzling.h"
#import "UIViewController+Swizzling.h"
@implementation NSArray (Defender)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArray0") originSelector:@selector(objectAtIndex:) toSwizzledSelector:@selector(jdcObjectAtIndex0:)];
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArray0") originSelector:@selector(objectAtIndexedSubscript:) toSwizzledSelector:@selector(jdcObjectAtIndexSubscript0:)];
        
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSSingleObjectArrayI") originSelector:@selector(objectAtIndex:) toSwizzledSelector:@selector(jdcObjectAtIndex:)];
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSSingleObjectArrayI") originSelector:@selector(objectAtIndexedSubscript:) toSwizzledSelector:@selector(jdcObjectAtIndexSubscript:)];
        
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArray1") originSelector:@selector(objectAtIndex:) toSwizzledSelector:@selector(jdcObjectAtIndexI:)];
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArray1") originSelector:@selector(objectAtIndexedSubscript:) toSwizzledSelector:@selector(jdcObjectAtIndexSubscriptI:)];
    });
}
//alloc初始化
- (id)jdcObjectAtIndex:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndex:index];
    }
}
- (id)jdcObjectAtIndexSubscript:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndexSubscript:index];
    }
}
- (id)jdcObjectAtIndexI:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndexSubscript:index];
    }
}
- (id)jdcObjectAtIndexSubscriptI:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndexSubscript:index];
    }
}
- (id)jdcObjectAtIndex0:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndexSubscript:index];
    }
}
- (id)jdcObjectAtIndexSubscript0:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndexSubscript:index];
    }
}


@end

@implementation NSMutableArray (Defender)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) toSwizzledSelector:@selector(jdcObjectAtIndex:)];
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndexedSubscript:) toSwizzledSelector:@selector(jdcObjectAtIndexSubscript:)];
        
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArrayM") originSelector:@selector(addObject:) toSwizzledSelector:@selector(jdcAddObject:)];
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArrayM") originSelector:@selector(removeObject:) toSwizzledSelector:@selector(jdcRemoveObject:)];
        
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArrayM") originSelector:@selector(insertObject:atIndex:) toSwizzledSelector:@selector(jdcInsertObject:atIndex:)];
        [NSObject methodSwizzlingWithClass:NSClassFromString(@"__NSArrayM") originSelector:@selector(removeObjectAtIndex:) toSwizzledSelector:@selector(jdcRemoveObjectAtIndex:)];
    });
}
- (void)jdcAddObject:(id)obj{
    if (obj==nil) {
        return;
    }
    [self jdcAddObject:obj];
}
- (void)jdcRemoveObject:(id)obj{
    if (obj==nil) {
        return;
    }
    [self jdcRemoveObject:obj];
}
-(void)jdcInsertObject:(id)obj atIndex:(NSUInteger)index{
    if (obj==nil) {
        
    }else if (self.count<index){
        
    }else
        [self jdcInsertObject:obj atIndex:index];
}
-(void)jdcRemoveObjectAtIndex:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        
    }else{
        return [self jdcRemoveObjectAtIndex:index];
    }
}
//alloc初始化
- (id)jdcObjectAtIndex:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndex:index];
    }
}
- (id)jdcObjectAtIndexSubscript:(NSUInteger)index{
    if (self.count<=0) {
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"空数组"];
#else
#endif
        return nil;
    }
    if (index > self.count-1) {
        NSLog(@"index beyond the boundary");
#ifdef DEBUG
        [UIViewController showAlertViewWithMessage:@"index beyond the boundary"];
#else
#endif
        return nil;
    }else{
        return [self jdcObjectAtIndexSubscript:index];
    }
}
@end
