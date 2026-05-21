//
//  VideoCateVC.h
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseViewController.h"
@class DTTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface VideoCateVC : BGBaseViewController
@property(nonatomic, copy) void (^releaseTopicBlock)(DTTopicModel * topic);

@end

NS_ASSUME_NONNULL_END
