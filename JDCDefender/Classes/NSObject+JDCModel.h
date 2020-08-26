//
//  NSObject+JDCModel.h
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/25.
//  Copyright © 2020 江德春. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//JDCModel协议
@protocol JDCModel <NSObject>
//协议方法:返回一个字典,表明特殊字段的处理规则
+(nullable NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass;
@optional

@end
@interface NSObject (JDCModel)
//字段转模型方法
+(instancetype)JDC_modelWithDictionary:(NSDictionary*)dictionary;
//解档
-(instancetype)JDC_modeInitWithCoder:(NSCoder*)aDecoder;
//归档
-(void)JDC_modelEncodeWithCoder:(NSCoder*)aCoder;
@end

NS_ASSUME_NONNULL_END
