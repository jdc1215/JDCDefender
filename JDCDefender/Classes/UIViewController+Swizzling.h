//
//  UIViewController+Swizzling.h
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/24.
//  Copyright © 2020 江德春. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Swizzling)
+(void)showAlertViewWithMessage:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
