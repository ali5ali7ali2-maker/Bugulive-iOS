//
//  ReleaseAtPeopleVC.h
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class PersonCenterUserModel;
@interface ReleaseAtPeopleVC : BaseViewController


@property(nonatomic, copy) void (^releaseAtPeopleBlock)(PersonCenterUserModel * user);


@end

NS_ASSUME_NONNULL_END
