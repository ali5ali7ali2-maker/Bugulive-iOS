//
//  MGGlobalVipView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/18.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGGlobalVipView : UIView

@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *contentL;

@property(nonatomic, strong) CustomMessageModel *model;

@end

NS_ASSUME_NONNULL_END
