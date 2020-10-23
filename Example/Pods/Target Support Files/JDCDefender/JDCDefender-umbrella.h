#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+Defender.h"
#import "NSDictionary+Hook.h"
#import "NSObject+JDCModel.h"
#import "NSObject+KVCDefender.h"
#import "NSObject+KVODefender.h"
#import "NSObject+MethodSwizzling.h"
#import "NSObject+SelectorDefender.h"
#import "UIViewController+Swizzling.h"

FOUNDATION_EXPORT double JDCDefenderVersionNumber;
FOUNDATION_EXPORT const unsigned char JDCDefenderVersionString[];

