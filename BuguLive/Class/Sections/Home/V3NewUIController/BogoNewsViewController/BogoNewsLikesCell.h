//
//  BogoNewsLikesCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/7.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BogoNewsHeadTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoNewsLikesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *rightImgBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentImgView;


@property(nonatomic, strong) BogoNewsHeadTypeModel *model;

-(void)resetContentWithModel:(BogoNewsHeadTypeModel *)model type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
