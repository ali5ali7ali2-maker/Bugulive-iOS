//
//  NSObject+BGPrint.h
//  BuguLive
//
//  Created by bugu on 2019/12/14.
//  Copyright © 2019 xfg. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BGPrint)
+ (void)printfModelWithJSONDict:(NSDictionary *)dict;

+ (void)printfModelWithClass:(NSString *)strClass JSONDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
