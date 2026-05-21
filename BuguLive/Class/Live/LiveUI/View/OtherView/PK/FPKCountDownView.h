//
//  FPKCountDownView.h
//  BuguLive
//
//  Created by bogokj on 2019/4/2.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPKCountDownView : BGBaseView{
    __weak id<FWShowLiveRoomAble>       _liveItem;
}

@property(nonatomic, assign) int countDown;
@property (nonatomic, copy) NSString *pkid;
//2020-1-3 修改pk
@property (nonatomic, copy) NSString *pktype;

- (instancetype)initWithFrame:(CGRect)frame liveItem:(id<FWShowLiveRoomAble>)liveItem;

-(void)stopTimer;
- (void)switchToPunish:(int)time;


@end

NS_ASSUME_NONNULL_END
