//
//  BGSignModel.h
//  BuguLive
//
//  Created by bugu on 2019/12/9.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGSignRewardModel;
NS_ASSUME_NONNULL_BEGIN

@interface BGSignModel : NSObject

@property(nonatomic, copy) NSString *signin_count;
@property(nonatomic, strong) NSArray <BGSignRewardModel *>*list;
@end

@interface BGSignRewardModel : NSObject

@property(nonatomic, copy) NSString *day;
@property(nonatomic, copy) NSString *num;
@property(nonatomic, copy) NSString *is_sign;

@end


NS_ASSUME_NONNULL_END
