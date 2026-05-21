//
//  NewestItemCell.h
//  BuguLive
//
//  Created by 丁凯 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LivingModel;
@class CustomEdgeInsetLabel;

@interface NewestItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet CustomEdgeInsetLabel *addressLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *recordBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *watchingLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveContentExtLabel;

@property (weak, nonatomic) IBOutlet QMUIButton *watchBtn;

@property (weak, nonatomic) IBOutlet UIImageView *isPKIngImg;
@property (weak, nonatomic) IBOutlet UIImageView *img_labels;

@property (nonatomic, strong) HMHotItemModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *imgLabelBtn;//标签
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;

- (void)setCellContent:(LivingModel *)LModel Type:(int)type;
@property (weak, nonatomic) IBOutlet UIView *passwordImg;

@end
