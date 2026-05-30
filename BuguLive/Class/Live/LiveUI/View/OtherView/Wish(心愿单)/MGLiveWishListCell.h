//
//  MGLiveWishListCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/6.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLiveWishModel.h"

@class MGLiveWishcontributionView;

NS_ASSUME_NONNULL_BEGIN

@interface MGLiveWishListCell : UITableViewCell

@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UILabel     *titleL;
@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel     *topicL;

@property(nonatomic, strong) UIView *progressBgView;
@property(nonatomic, strong) UIView *progressTitntView;
@property(nonatomic, strong) UILabel     *countL;
@property(nonatomic, strong) UIView *line;


@property(nonatomic, strong) UILabel     *contributionL;
@property(nonatomic, strong) UIView *contributionView;


@property(nonatomic, assign) MGADD_WISH wishType;

-(void)resetCellWithWishType:(MGADD_WISH)wishType WithModel:(MGLiveWishModel *)model;

@end

@interface MGLiveWishcontributionView : UIView

@property(nonatomic, strong) UIImageView *headImgView;
@property(nonatomic, strong) UIImageView *levelImgView;
@property(nonatomic, strong) UILabel *nickNameL;
@property(nonatomic, strong) UILabel *numL;

@end

NS_ASSUME_NONNULL_END
