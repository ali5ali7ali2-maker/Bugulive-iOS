//
//  PKBattleListCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/31.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKBattleListModel.h"



@protocol PKBattleDelegate <NSObject>

-(void)clickBattleModel:(PKBattleListModel *)model LeftOrRight:(BOOL)isLeft;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PKBattleListCell : UITableViewCell

@property(nonatomic, strong) PKBattleListModel *model;

@property(nonatomic, strong) id<PKBattleDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet QMUIButton *leftAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftNameL;
@property (weak, nonatomic) IBOutlet QMUIButton *rightAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightNameL;

@property (weak, nonatomic) IBOutlet UIView *leftPKView;
@property (weak, nonatomic) IBOutlet UIView *rightPKView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPKWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightPKWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkLineHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *leftTicketL;
@property (weak, nonatomic) IBOutlet UILabel *rightTicketL;

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UIView *pkLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidthConstraint;


@end

NS_ASSUME_NONNULL_END
