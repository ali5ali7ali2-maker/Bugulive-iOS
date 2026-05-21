//
//  BGSoundEffectsView.h
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
//2020-1-2 点击播放某个音效
#import "UIView+addVideoToView.h"
#import "BGSoundEffectModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BGSoundEffectsView : UIView

@property (nonatomic, copy) dispatch_block_t uploadBlock;
@property (nonatomic, weak)AVPlayer *player;

-(void)requestData;

- (void)show:(UIView *)superView;

- (void)hide;

@property(nonatomic, copy) void (^playUrl)(BGSoundEffectModel *model);

@end

NS_ASSUME_NONNULL_END
