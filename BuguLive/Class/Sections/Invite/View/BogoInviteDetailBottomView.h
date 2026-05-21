//
//  BogoInviteDetailBottomView.h
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BogoInviteDetailBottomView;
@class BogoInviteWithDrawResponseModel;
@class BogoInviteWithDrawResponseModelList;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoInviteDetailBottomViewDelegate <NSObject>

- (void)bottomView:(BogoInviteDetailBottomView *)bottomView didClickAuthBtn:(UIButton *)sender;
- (void)bottomView:(BogoInviteDetailBottomView *)bottomView didClickWithDrawBtn:(UIButton *)sender;
- (void)bottomView:(BogoInviteDetailBottomView *)bottomView didClickAgreementBtn:(UIButton *)sender;

@end

@interface BogoInviteDetailBottomView : UIView

@property(nonatomic, weak) id<BogoInviteDetailBottomViewDelegate>delegate;
@property(nonatomic, strong) BogoInviteWithDrawResponseModel *model;
@property(nonatomic, strong) BogoInviteWithDrawResponseModelList *selectModel;

@end

NS_ASSUME_NONNULL_END
