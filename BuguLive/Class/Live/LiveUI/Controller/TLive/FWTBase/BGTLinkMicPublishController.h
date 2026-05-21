//
//  BGTLinkMicPublishController.h
//  BuguLive
//
//  Created by xfg on 2017/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGTPublishController.h"
#import "BGTLinkMicPlayItem.h"
#import "TLiveMickListModel.h"
/////////////////// TiFaceSDK 添加 开始 ///////////////////
#import "TiSDKInterface.h"

//#import <TiUIManager.h>
#import "TiUIManager.h"

/////////////////// TiFaceSDK 添加 结束 ///////////////////

@protocol ITCLivePlayListener <NSObject>

@optional
- (void)onLivePlayEvent:(NSString*)playUrl withEvtID:(int)evtID andParam:(NSDictionary*)param;

@optional
- (void)onLivePlayNetStatus:(NSString*)playUrl withParam:(NSDictionary*)param;

@end


@interface TCLivePlayListenerImpl: NSObject<TXLivePlayListener>

@property (nonatomic, strong) NSString                  *playUrl;
@property (nonatomic, weak) id<ITCLivePlayListener>     delegate;

@end


@protocol FWTLinkMicPublishControllerDelegate <NSObject>
@required

/*
 *  主播端连麦结果
 *  isSucc：是否拉取观众连麦加速流成功
 *  userID：拉取的连麦观众对应的ID
 */
- (void)playMickResult:(BOOL)isSucc userID:(NSString *)userID;
- (void)clickCloseBtn:(UserView *)view;
@end

@interface BGTLinkMicPublishController : BGTPublishController
//<TiUIViewDelegate>

///////////// TiSDK 添加 开始 /////////////
@property(nonatomic, strong) TiSDKManager *tiSDKManager;
//@property(nonatomic, strong) TiUIView *tiUIView;
///////////// TiSDK 添加 结束 /////////////

@property (nonatomic, weak) id<FWTLinkMicPublishControllerDelegate> linkMicPublishDelegate;
@property (nonatomic, strong) TLiveMickListModel    *mickListModel;
@property (nonatomic, strong) NSMutableArray        *playItemArray;     // 连麦窗口视图列表



// 通过用户ID来获取连麦视图
- (BGTLinkMicPlayItem *)getPlayItemByUserID:(NSString*)userID;
// 同意连麦
- (void)agreeLinkMick:(NSString *)streamPlayUrl applicant:(NSString *)userID;
// 断开连麦
- (void)breakLinkMick:(NSString *)userID;
// 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel;
- (void)adjustPlayItemVoiceUserList:(NSArray *)userlist;
@end
