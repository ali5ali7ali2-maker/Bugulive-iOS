//
//  RoomPasswordView.h
//  BuguLive
//
//  Created by voidcat on 2024/5/20.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseXibView.h"
@interface RoomPasswordView : BaseXibView
@property (weak, nonatomic) IBOutlet UILabel *labPassword;
@property (weak, nonatomic) IBOutlet QMUITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UISwitch *swcPassword;

@end
