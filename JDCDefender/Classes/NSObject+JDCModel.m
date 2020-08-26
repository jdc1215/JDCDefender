//
//  NSObject+JDCModel.m
//  ConfigurationDemo
//
//  Created by 江德春 on 2020/8/25.
//  Copyright © 2020 江德春. All rights reserved.
//

#import "NSObject+JDCModel.h"
#import <objc/runtime.h>
@implementation NSObject (JDCModel)
//字段转模型方法
+ (instancetype)JDC_modelWithDictionary:(NSDictionary *)dictionary{
    Class class = [self class];
    //创建当前模型对象
    id object = [[self alloc] init];
    unsigned int count;
    //获取当前对象的属性列表
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    //遍历propertyList 中所有属性，以其属性名为key，在字典中查找 value
    for (unsigned int i=0 ; i<count; i++) {
        //获取属性
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        NSString *propertyNameStr = [NSString stringWithUTF8String:propertyName];
        //获取JSON 中属性值 value
        id value = [dictionary objectForKey:propertyNameStr];
        //获取属性所属类名
        NSString *propertyType;
        unsigned int attrCount;
        objc_property_attribute_t *atts = property_copyAttributeList(property, &attrCount);
        for (unsigned int i=0; i<attrCount; i++) {
            switch (atts[i].name[0]) {
                case 'T':
                    {
                        if (atts[i].value) {
                            propertyType = [NSString stringWithUTF8String:atts[i].value];
                            //去除转义字符:@\"NSString\"->@"NSString"
                            propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            //去除@
                            propertyType = [propertyType stringByReplacingOccurrencesOfString:@"@" withString:@""];
                        }
                    }
                    break;
                    
                default:
                    break;
            }
        }
        //对特殊属性进行处理
        //判断当前类是否实现了协议方法,获取协议方法中规定的特殊属性的处理方式
        NSDictionary *propertyTypeDic;
        if ([self respondsToSelector:@selector(modelContainerPropertyGenericClass)]) {
            propertyTypeDic = [self performSelector:@selector(modelContainerPropertyGenericClass) withObject:nil];
        }
        //处理:字典的key 与模型属性不匹配的问题,如 id->uid
        id anotherName = propertyTypeDic[propertyNameStr];
        if (anotherName && [anotherName isKindOfClass:[NSString class]]) {
            value = dictionary[anotherName];
        }
        //处理：模型嵌套模型的情况
        if ([value isKindOfClass:[NSDictionary class]]&&![propertyType hasPrefix:@"NS"]) {
            Class modelClass = NSClassFromString(propertyType);
            if (modelClass != nil) {
                //将被嵌套字典数据也转化成Model
                value = [modelClass JDC_modelWithDictionary:value];
            }
        }
        //处理：模型嵌套模型数组的情况
        //判断当前 value 是一个数组，而且存在协议方法返回了 propertyTypeDic
        if ([value isKindOfClass:[NSArray class]]&& propertyTypeDic) {
            Class itemModelClass = propertyTypeDic[propertyNameStr];
            //封装数组，将每一个子数据转化为Model
            NSMutableArray *itemArray = @[].mutableCopy;
            for (NSDictionary *itemDic in value) {
                id model = [itemModelClass JDC_modelWithDictionary:itemDic];
                [itemArray addObject:model];
            }
            value = itemArray;
        }
        //使用KVC方法将value更新到object中
        if (value != nil) {
            [object setValue:value forKey:propertyNameStr];
        }
    }
    free(propertyList);
    return object;
}
//解档
-(instancetype)JDC_modeInitWithCoder:(NSCoder *)aDecoder{
    if (!aDecoder) {
        return self;
    }
    if (!self) {
        return self;
    }
    unsigned int count;
    Class class = [self class];
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    for (int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id value = [aDecoder decodeObjectForKey:name];
        [self setValue:value forKey:name];
    }
    free(propertyList);
    return self;
}
//归档
-(void)JDC_modelEncodeWithCoder:(NSCoder *)aCoder{
    if (!aCoder) {
        return;
    }
    if (!self) {
        return;
    }
    unsigned int cout;
    Class class = [self class];
    objc_property_t *propertyLst = class_copyPropertyList(class, &cout);
    for (int i=0; i<cout; i++) {
        const char *propertyName = property_getName(propertyLst[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(propertyLst);
}
@end
