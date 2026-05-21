//
//  BGRoomSetNoticeCell.h
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomSetNoticeCell : UITableViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) QMUITextView *titleTextView;

//半透明背景
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, copy) void (^textChange)(NSString *text);
@end

NS_ASSUME_NONNULL_END
