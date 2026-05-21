//
//  MGBaseModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/6/17.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGBaseModel : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *id;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
