//
//  BogoInviteDetailTopView.h
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BogoInviteDetailTopView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoInviteDetailTopViewDelegate <NSObject>

- (void)topView:(BogoInviteDetailTopView *)topView didClickLogBtn:(UIButton *)sender;
- (void)topView:(BogoInviteDetailTopView *)topView didClickWithDrawBtn:(UIButton *)sender;

@end

@interface BogoInviteDetailTopView : UIView

@property(nonatomic, weak) id<BogoInviteDetailTopViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet QMUIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;

@end

NS_ASSUME_NONNULL_END
