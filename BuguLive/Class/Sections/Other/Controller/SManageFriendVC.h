//
//  SManageFriendVC.h
//  BuguLive
//
//  Created by 丁凯 on 2017/9/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

@interface SManageFriendVC : BGBaseViewController

@property (nonatomic, assign) int        type;//0表示删除人；1表示添加好友
@property (nonatomic, copy) NSString     *liveAVRoomId;
@property (nonatomic, copy) NSString     *chatAVRoomId;

@end
