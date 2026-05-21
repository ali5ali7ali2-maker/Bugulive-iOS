//
//  GameRechargeView.h
//  BuguLive
//
//  Created by 布谷 on 2017/5/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
@interface GameRechargeView : UIView<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *diamondsImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rechargeImageView;
@end
