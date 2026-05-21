//
//  RoomLiveMicView.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomUsers;
@class RoomLiveMicView;
@class RoomModel;
@class RoomUserInfo;
@class RoomUserCell;
@class RoomMasterCell;
@class RoomRankModel;

@class BogoRODispatchModel;

NS_ASSUME_NONNULL_BEGIN

@protocol RoomLiveMicViewDelegate <NSObject>

- (void)micView:(RoomLiveMicView *)micView didClickShareBtn:(QMUIButton *)sender;
- (void)micView:(RoomLiveMicView *)micView didClickTrueLoveBtn:(UIButton *)sender;
- (void)micView:(RoomLiveMicView *)micView didClickLinkBtnIndex:(NSInteger)index;
- (void)micView:(RoomLiveMicView *)micView didClickUser:(Wheat_Type_List *)info;

- (void)micView:(RoomLiveMicView *)micView userCell:(RoomUserCell *)userCell didClickGiftView:(UIView *)giftView;

- (void)micView:(RoomLiveMicView *)micView masterCell:(RoomMasterCell *)masterCell didClickGiftView:(UIView *)giftView;

- (void)micView:(RoomLiveMicView *)micView didClickAnnouncementBtn:(UIButton *)sender;


- (void)micView:(RoomLiveMicView *)micView didClickNumberBtn:(UIButton *)sender;

- (void)micView:(RoomLiveMicView *)micView didClickRoomOrderDispatchInfoBtn:(UIButton *)sender;
//点击真爱榜
- (void)micViewdidClickRoomTrueLove;

@end

@interface RoomLiveMicView : UIView

@property(nonatomic, strong) RoomUsers *users;
@property(nonatomic, weak) id<RoomLiveMicViewDelegate>delegate;
@property(nonatomic, strong) RoomModel *model;


@property(nonatomic, strong) NSString *heat;

- (void)refreshData;
-(void)sendGift:(CustomMessageModel *)model;
@property(nonatomic, strong) RoomRankModel *rankModel;

@property(nonatomic, assign) BOOL is_open_guest;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIButton *numBtn;

@property(nonatomic, strong) BogoRODispatchModel * order;

@end

NS_ASSUME_NONNULL_END
