//
//  BGRoomManagerSearchViewController.h
//  UniversalApp
//
//  Created by bugu on 2020/5/6.
//  Copyright © 2020 voidcat. All rights reserved.
//

//#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RoomModel;

@interface BGRoomManagerSearchViewController : BaseViewController
@property(nonatomic, strong) CurrentLiveInfo *model;
@property(nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
