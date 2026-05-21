//
//  BGRoomSetPwdCell.h
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomPasswordView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomSetPwdCell : UITableViewCell

@property(nonatomic, strong) QMUITextField *titleTextField;
@property(nonatomic, strong) UIButton *openBtn;

@property(nonatomic, copy) void (^pwdStatusBlock)(UIButton * sender);
@property(nonatomic, copy) void (^pwdTextChangeBlock)(NSString * text);
@property(nonatomic, strong) RoomPasswordView *passwordView;
@end

NS_ASSUME_NONNULL_END
