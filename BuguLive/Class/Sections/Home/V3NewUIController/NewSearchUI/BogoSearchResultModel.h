//
//  BogoSearchResultModel.h
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SmallVideoListModel;
@class SenderModel;
@class WBModel;


NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchResultModel : NSObject

@property (nonatomic, copy) NSString *act;
@property (nonatomic, copy) NSString *ctl;
@property (nonatomic, strong) NSArray<WBModel *> *dynamic;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray<SenderModel *> *user;
@property (nonatomic, strong) NSArray<SmallVideoListModel *> *weibo;

@end

NS_ASSUME_NONNULL_END
