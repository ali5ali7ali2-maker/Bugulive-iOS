//
//  ReleaseDynamicVC.h
//  BuguLive
//
//  Created by bugu on 2019/11/26.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "XWPublishBaseController.h"
#import "MGDynamicTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseDynamicVC : XWPublishBaseController

@property(nonatomic, copy) void (^postFinishBlock)(BOOL isFinish);

//如果直接从动态点进来，暂时先将动态里面的话题转换成model
@property(nonatomic, strong) MGDynamicTopicModel *topic;/**<话题*/


@end

NS_ASSUME_NONNULL_END
