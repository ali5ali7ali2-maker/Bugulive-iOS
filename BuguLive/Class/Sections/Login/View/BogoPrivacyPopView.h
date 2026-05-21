//
//  BogoPrivacyPopView.h
//  BuguLive
//
//  Created by Mac on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BogoPrivacyPopView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoPrivacyPopViewDelegate <NSObject>

- (void)privacyPopView:(BogoPrivacyPopView *)privacyPopView didClickAgreeBtn:(UIButton *)sender;
- (void)privacyPopView:(BogoPrivacyPopView *)privacyPopView didClickUserAgreement:(UIButton *)sender;
- (void)privacyPopView:(BogoPrivacyPopView *)privacyPopView didClickPrivacyAgreement:(UIButton *)sender;

@end

@interface BogoPrivacyPopView : UIView

@property(nonatomic, weak) id<BogoPrivacyPopViewDelegate>delegate;

@property(nonatomic, copy) NSString *url;

- (void)show:(UIView *)superView;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

NS_ASSUME_NONNULL_END
