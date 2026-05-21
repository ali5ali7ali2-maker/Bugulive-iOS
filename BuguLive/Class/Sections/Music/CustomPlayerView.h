//
//  CustomPlayerView.h
//  BuguLive
//
//  Created by voidcat on 2024/5/23.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPlayerView : UIView
@property (nonatomic, strong) UILabel *songTitleLabel;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *songTimeLabel;
@property (nonatomic, strong) UIButton *playPauseButton;
@property(nonatomic, strong)  musiceModel* chosemusic;
@property(nonatomic, copy) void (^play)(musiceModel *chosemusic);
@end

NS_ASSUME_NONNULL_END
