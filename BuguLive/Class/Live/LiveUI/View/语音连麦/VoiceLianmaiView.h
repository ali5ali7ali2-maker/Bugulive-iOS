//
//  VoiceLianmaiView.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/10/13.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseXibView.h"
@interface VoiceLianmaiView : BaseXibView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *micbutton;
@property(nonatomic, strong) YYAnimatedImageView *yyimg;
@property(nonatomic, assign) NSInteger totalVolume;
@end
