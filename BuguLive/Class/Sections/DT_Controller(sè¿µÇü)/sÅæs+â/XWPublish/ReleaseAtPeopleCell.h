//
//  ReleaseAtPeopleCell.h
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCenterUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseAtPeopleCell : UITableViewCell
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nickNameLabel;

@property(nonatomic, strong) PersonCenterUserModel *user;
@end

NS_ASSUME_NONNULL_END
