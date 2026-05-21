//
//  AudienceEnteringTipView.h
//  BuguLive
//
//  Created by xfg on 16/6/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef NS_ENUM(NSInteger, AudienceEnteringTipViewType) {
    AudienceEnteringTipViewTypeHighLevel,//高等级会员进入
    AudienceEnteringTipViewTypeGuard,//守护进入
};

@interface AudienceEnteringTipView : UIView

@property (weak, nonatomic) IBOutlet UIImageView    *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel        *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *guardianImageView;
@property (weak, nonatomic) IBOutlet UILabel *joinText;

@property (weak, nonatomic) IBOutlet UIImageView *nobleImgView;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipLeftConstraint;
@property (nonatomic, assign) AudienceEnteringTipViewType type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nobleLeftConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guardWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nobleWidthConstraint;


- (id)initWithMyFrame:(CGRect)frame;

- (void)setContent:(UserModel *) userModel;

@end
