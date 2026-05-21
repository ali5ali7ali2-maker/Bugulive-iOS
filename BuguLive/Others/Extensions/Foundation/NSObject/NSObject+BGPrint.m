//
//  NSObject+BGPrint.m
//  BuguLive
//
//  Created by bugu on 2019/12/14.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "NSObject+BGPrint.h"



@implementation NSObject (BGPrint)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (void)printfModelWithJSONDict:(NSDictionary *)dict{
    NSString *identifier = NSStringFromClass([self class]);
    [self printfModelWithClass:identifier JSONDict:dict];
}

+ (void)printfModelWithClass:(NSString *)strClass JSONDict:(NSDictionary *)dict{
    
    printf("\n@interface %s :NSObject\n\n",strClass.UTF8String);
    
    //遍历字典
    for (NSString *key in dict) {
        NSString * type;
        if ([dict[key] isKindOfClass:[NSArray class]]) {
            type =@"NSArray";
            printf("@property (nonatomic,strong) %s *%s;/**<*/\n",type.UTF8String,key.UTF8String);
            
        }else if ([dict[key] isKindOfClass:[NSDictionary class]]){
            
            type =@"NSDictionary";
            printf("@property (nonatomic,strong) %s *%s;/**<*/\n",type.UTF8String,key.UTF8String);
            
        }else if ([dict[key] isKindOfClass:[NSNumber class]]){
            
            type =@"NSNumber";
            printf("@property (nonatomic,copy) %s *%s;/**<*/\n",type.UTF8String,key.UTF8String);
            
        }else if ([dict[key] isKindOfClass:[NSString class]]){
            
            type =@"NSString";
            printf("@property (nonatomic,copy) %s *%s;/**<*/\n",type.UTF8String,key.UTF8String);
            
        }
        
    }
    printf("\n@end\n");
    
    printf("@implementation %s\n\n",strClass.UTF8String);
    printf("@end\n");

}

@end
