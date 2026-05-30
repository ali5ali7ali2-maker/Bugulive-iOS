//
//  BogoShowNobleCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/9.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGShowVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoShowNobleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;

@property (weak, nonatomic) IBOutlet UIImageView *nobleImgView;
@property (weak, nonatomic) IBOutlet UIButton *concertBtn;

@property(nonatomic, strong) MGShowVipModel *model;



@property(nonatomic, copy) void (^clickHeadBlock)(MGShowVipModel *model);
@property ( nonatomic,copy) void             (^headViewAttentionBlock) (BOOL isAttention);

-(void)resetModel:(MGShowVipModel *)model;

@end

NS_ASSUME_NONNULL_END
