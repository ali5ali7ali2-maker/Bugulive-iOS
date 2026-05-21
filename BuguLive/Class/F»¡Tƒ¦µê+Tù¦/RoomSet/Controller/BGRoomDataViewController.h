//
//  BGRoomDataViewController.h
//  UniversalApp
//
//  Created by 志刚杨 on 2022/3/21.
//  Copyright © 2022 voidcat. All rights reserved.
//

//#import "RootViewController.h"
#import "RoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomDataViewController : BaseViewController
@property(nonatomic, strong) RoomModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labNickname;
@property (weak, nonatomic) IBOutlet UILabel *labId;

@property (weak, nonatomic) IBOutlet UILabel *labTotal;

@property (weak, nonatomic) IBOutlet UILabel *labToday;

@end

NS_ASSUME_NONNULL_END
