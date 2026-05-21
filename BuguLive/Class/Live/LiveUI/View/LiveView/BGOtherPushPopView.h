//
//  BGOtherPushPopView.h
//  BuguLive
//
//  Created by Mac on 2021/8/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "FDUIKitObjC.h"
@class CurrentLiveInfo;

NS_ASSUME_NONNULL_BEGIN

@interface BGOtherPushPopView : FDPopView

@property(nonatomic, strong) CurrentLiveInfo *liveInfo;

@end

NS_ASSUME_NONNULL_END
