//
//  MGBaseModel.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/6/17.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "MGBaseModel.h"

@implementation MGBaseModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        [self setAttributesFromDictionary:dic];
    }
    
    return self;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//- (NSString *)description
//{
//    NSMutableString *des = [NSMutableString string];
//    
//    unsigned int allCount;
//    
//    objc_property_t *properties = class_copyPropertyList([self class], &allCount);
//    
//    for (int i = 0; i < allCount; i ++) {
//        @autoreleasepool {
//            objc_property_t property = properties[i];
//            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//            id propertyValue = [self valueForKey:propertyName];
//            
//            if (nil == propertyValue || [NSNull null] == (NSNull *)propertyValue) {
//                propertyValue = @"";
//            }
//            
//            if (i < allCount - 1) {
//                [des appendFormat:@"%@:'%@',",propertyName,propertyValue];
//            }else
//            {
//                [des appendFormat:@"%@:'%@'",propertyName,propertyValue];
//            }
//        }
//    }
//    
//    return des;
//}

@end
