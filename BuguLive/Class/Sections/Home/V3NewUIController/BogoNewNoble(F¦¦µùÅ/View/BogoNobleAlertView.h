//
//  BogoNobleAlertView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BogoNobleListModel.h"
@protocol BogoNobleAlertDelegate <NSObject>

-(void)protocolNobleAlertClickConfirm:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BogoNobleAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titieL;
@property (weak, nonatomic) IBOutlet UIImageView *iconimgView;

@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;
@property(nonatomic, strong) BogoNobleListSubTypeModel *selectModel;

@property(nonatomic, strong) id<BogoNobleAlertDelegate> delegate;

- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
