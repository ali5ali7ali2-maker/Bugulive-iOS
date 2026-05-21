//
//  TipAlert.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/5/30.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseXibView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TipAlert : BaseXibView
@property (weak, nonatomic) IBOutlet UILabel *labTipText;
@property (weak, nonatomic) IBOutlet QMUIFillButton *btnAgree;
@property (weak, nonatomic) IBOutlet QMUIFillButton *btnCancel;
@property(nonatomic, copy) void (^cancel)(void);
@property(nonatomic, copy) void (^agree)(void);

@end

NS_ASSUME_NONNULL_END
