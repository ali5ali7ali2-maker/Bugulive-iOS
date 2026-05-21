//
//  HMHotBannerModel.h
//  BuguLive
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseModel.h"

@interface HMHotBannerModel : BGBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger show_id;
@property (nonatomic, assign) float image_width;
@property (nonatomic, assign) float image_height;

/**
 计算广告栏的高度
 */
@property (nonatomic, assign) float bannerHeight;

@end
