//
//  MGShowVIPCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/19.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGShowVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGShowVIPCell : UITableViewCell

@property(nonatomic, strong) UIImageView *headImgView;
@property(nonatomic, strong) UILabel     *nickNameL;
@property(nonatomic, strong) UIImageView *sexImgView;
@property(nonatomic, strong) UIImageView *levelImgView;

-(void)resetModel:(MGShowVipModel *)model;

@end

NS_ASSUME_NONNULL_END
