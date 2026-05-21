//
//  LLFans.h
//  BuguLive
//
//  Created by 志刚杨 on 2019/11/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define hasToDo (![LLFans isLikeMe])
@interface LLFans : NSObject
+(BOOL)isLikeMe;
@end

NS_ASSUME_NONNULL_END
