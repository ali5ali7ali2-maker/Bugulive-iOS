//
//  BogoNobleBottomView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BogoNobleListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BogoNobleBottomDelegate <NSObject>

-(void)protocolClickOpenBtn;

@end

@interface BogoNobleBottomView : UIView

@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UIButton *openBtn;

@property(nonatomic, strong) BogoNobleRechargeModel *model;

@property(nonatomic, strong) id<BogoNobleBottomDelegate> delegate;

@property(nonatomic, assign) BOOL isOpen;

@end

NS_ASSUME_NONNULL_END
