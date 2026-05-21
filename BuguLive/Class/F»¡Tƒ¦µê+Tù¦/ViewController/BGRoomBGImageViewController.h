//
//  BGRoomBGImageViewController.h
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//


@class RoomModel;
@class RoomBGImageModel;

typedef void(^editRoomBGChangedCallBack)(RoomBGImageModel *selectModel);

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomBGImageViewController : UIViewController
@property(nonatomic, strong) RoomModel *model;
//开启直播设置
@property(nonatomic, assign,getter=isOpen) BOOL open;
@property(nonatomic, strong) RoomBGImageModel *selectModel;
@property(nonatomic, copy) editRoomBGChangedCallBack editRoomBGChangedCallBack;
@property(nonatomic, strong) NSString *room_id;
@end

NS_ASSUME_NONNULL_END
