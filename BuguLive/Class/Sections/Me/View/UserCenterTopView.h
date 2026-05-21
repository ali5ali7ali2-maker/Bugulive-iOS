//
//  UserCenterTopView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/15.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"
@class userPageModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserCenterTopViewBtnType) {
    UserCenterTopViewBtnTypeSet,
    UserCenterTopViewBtnTypeEdit,
    UserCenterTopViewBtnTypeRecord,
    UserCenterTopViewBtnTypeVideo,
    UserCenterTopViewBtnTypeFocus,
    UserCenterTopViewBtnTypeFan,
    UserCenterTopViewBtnTypeIcon,
    UserCenterTopViewBtnTypeSign,
    
    
    
    UserCenterTopViewBtnTypeAccount,
    UserCenterTopViewBtnTypeIncome,
    UserCenterTopViewBtnTypeVIP,
    UserCenterTopViewBtnTypeShop,
    UserCenterTopViewBtnTypeLevel,
    UserCenterTopViewBtnTypeFamily,
};

typedef void(^clickBtnBlock)(UserCenterTopViewBtnType type);

@interface UserCenterTopView : BGBaseView

- (void)setViewWithModel:(userPageModel *)userInfoM;

- (void)setClickBtnBlock:(clickBtnBlock)clickBtnBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankLeftConstraint;
@property (weak, nonatomic) IBOutlet QMUIButton *shopBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *vipBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *levelBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *familyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *accountImgView;
@property (weak, nonatomic) IBOutlet UIImageView *incomeImgView;
@property (weak, nonatomic) IBOutlet UILabel *diamondL;

@property (weak, nonatomic) IBOutlet UILabel *incomeL;

@property (weak, nonatomic) IBOutlet QMUIButton *signButton;

@property (weak, nonatomic) IBOutlet UIImageView *nobleImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nobleLeftImgConstraint;


@end

NS_ASSUME_NONNULL_END
