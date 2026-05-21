//
//  BGRoomSetHeadCell.h
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomSetHeadCell : UITableViewCell

@property(nonatomic, strong) UIButton *iconBtn;
@property(nonatomic, strong) UILabel *iconTipLabel;
@property(nonatomic, strong) QMUITextField *titleTextField;

@property(nonatomic, copy) void (^selectImgBlock)(void);

@end

NS_ASSUME_NONNULL_END
