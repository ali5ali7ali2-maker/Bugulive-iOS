//
//  BGRoomAnnouncementView.h
//  UniversalApp
//
//  Created by bugu on 2020/3/25.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "RoomPopView.h"

@class BGRoomAnnouncementView;
@class RoomModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BGRoomAnnouncementViewDelegate <NSObject>

- (void)announcementView:(BGRoomAnnouncementView *)announcementView didClickEditBtn:(UIButton *)sender;

@end

@interface BGRoomAnnouncementView : RoomPopView
@property(nonatomic, assign) BOOL is_admin;
@property(nonatomic, assign) BOOL is_host;
@property(nonatomic, strong) RoomModel *model;
@property(nonatomic, weak) id<BGRoomAnnouncementViewDelegate>delegate;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *editBtn;

@end

NS_ASSUME_NONNULL_END
