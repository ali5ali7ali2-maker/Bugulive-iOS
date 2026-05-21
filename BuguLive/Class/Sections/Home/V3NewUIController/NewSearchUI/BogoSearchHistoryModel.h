//
//  BogoSearchHistoryModel.h
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchHistoryModel : NSObject

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *addtime;

@end

NS_ASSUME_NONNULL_END
