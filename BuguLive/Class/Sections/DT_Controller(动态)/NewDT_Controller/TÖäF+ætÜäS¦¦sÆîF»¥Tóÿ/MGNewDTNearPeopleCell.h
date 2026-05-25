//
//  MGNewDTNearPeopleCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/18.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGNewDTNearlistModel.h"//附近的人model
#import "MGDynamicTopicModel.h"//动态model

NS_ASSUME_NONNULL_BEGIN

@interface MGNewDTNearPeopleCell : UITableViewCell

@property(nonatomic, assign) MGNEWDT_TYPE dtType;//类型

@property(nonatomic, strong) UIImageView *headImgView;
@property(nonatomic, strong) UILabel *nickNameL;
@property(nonatomic, strong) UIView *line;
//话题
@property(nonatomic, strong) UILabel *contentL;
@property(nonatomic, strong) UIImageView *rightImgView;
//附近的人
@property(nonatomic, strong) UILabel *timeL;
@property(nonatomic, strong) UILabel *distanceL;
@property(nonatomic, strong) UIImageView *sexImgView;
@property(nonatomic, strong) QMUIButton *certImgView;



-(void)resetModelWithModel:(id)model type:(MGNEWDT_TYPE)dtType;

@end

NS_ASSUME_NONNULL_END
