//
//  BogoRechargeRecordHeadView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BogoRechargeRecordHeadView;


NS_ASSUME_NONNULL_BEGIN


@protocol BogoRecargeRecordHeadDelegate <NSObject>

-(void)protocolRecordHead:(BogoRechargeRecordHeadView *)view;

@end

@interface BogoRechargeRecordHeadView : UIView

@property(nonatomic, strong) QMUIButton *timeBtn;

@property(nonatomic, weak) id<BogoRecargeRecordHeadDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
