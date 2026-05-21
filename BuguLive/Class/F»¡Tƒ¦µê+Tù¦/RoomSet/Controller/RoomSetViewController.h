//
//  RoomSetViewController.h
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

@class RoomModel;

NS_ASSUME_NONNULL_BEGIN

@interface RoomSetViewController : BaseViewController
@property(nonatomic, strong) CurrentLiveInfo *model;

//开启直播设置
@property(nonatomic, assign,getter=isOpen) BOOL open;

//不是房主，是管理员
//@property(nonatomic, assign) BOOL is_admin;


@end

NS_ASSUME_NONNULL_END
