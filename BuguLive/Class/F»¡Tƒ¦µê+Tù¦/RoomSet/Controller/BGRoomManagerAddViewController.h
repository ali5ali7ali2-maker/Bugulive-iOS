//
//  BGRoomManagerAddViewController.h
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

//#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RoomModel;

@interface BGRoomManagerAddViewController : BaseViewController
@property(nonatomic, strong) CurrentLiveInfo *model;
@property(nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
