//
//  ReleaseTopicVC.h
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BaseViewController.h"
#import "MGDynamicTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReleaseTopicVC : BaseViewController
@property(nonatomic, copy) void (^releaseTopicBlock)(MGDynamicTopicModel * topic);

@end

NS_ASSUME_NONNULL_END
