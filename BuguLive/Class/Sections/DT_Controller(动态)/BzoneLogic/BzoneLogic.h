//
//  BzoneLogic.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/4/22.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CYDReplyModel.h"
#import "MGDynamicTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CommonVoidBlock)();
typedef void (^CommonVoidDicBlock)(NSDictionary *dic);
typedef void (^CommonCompletionBlock)(id selfPtr, BOOL isFinished);
typedef void (^CommonBoolCompletionBlock)(BOOL isFinished);


typedef enum : NSUInteger {
    MGDTHOMETYPE_CONCERT,//关注
    MGDTHOMETYPE_RECOMMAND,//推荐、热门
    MGDTHOMETYPE_NEARBY,//附近
    MGDTHOMETYPE_MY,//我的
    MGDTHOMETYPE_VIDEO,//短视频
} MGDTHOMETYPE;

@protocol  BzoneLogicDelegate <NSObject>
@optional
//获取动态主页列表
-(void)requestZoneListDataCompleted;

//获取动态评论列表
-(void)requestZoneReplyListDataCompletedWhih:(NSArray<CYDReplyModel *> *)list;

@end

@interface BzoneLogic : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码
@property (nonatomic, strong) NSString *to_uid;
@property (nonatomic)BOOL isGZ;
@property(nonatomic,weak)id<BzoneLogicDelegate> delegagte;
@property(nonatomic, assign) BOOL noHasMore;
@property(nonatomic, strong) NSMutableArray *topicArr;//话题数组array


/**
 拉取数据
 */
-(void)loadListDataWithAct:(MGDTHOMETYPE)act;


/**
  拉取数据-话题动态
*/
-(void)loadListDataWiththeme:(NSString *)theme;

/**
 拉取数据区分
 */
-(void)loadListData2With:(BOOL)isgz;

//获取动态评论列表
-(void)loadReplyListWhidZoneID:(NSString *)zone_id;

//发布动态 content:发布内容 ，不传传nil，videopath，视频路径
-(void)addDynamicContent:(NSString *)content WithImage:(NSArray *)imageArr andVideoPaht:(NSString *)path cover_url:(NSString *)cover_url audio:(NSString *)audio audio_seconds:(NSString *)audio_seconds Success:(CommonBoolCompletionBlock)block;



/// 发布动态
/// @param type 1文本, 2图片 3视频,默认1文本
/// @param content 文本信息
/// @param mediaArr 动态资源地址, 多个用,隔开
/// @param cover_url 封面图, 图片默认为第一张,视频默认为客户端处理的第X帧
/// @param no_name 匿名 1是0否
/// @param themeID 话题id
/// @param address 地址名称,默认空字符串
/// @param media_attr 资源属性 视频为视频长度, 图片为图片个数, 默认为空字符串
/// @param at @用户id, 多个用户id用,隔开
/// @param block 成功回调
-(void)addDynamicType:(NSInteger)type content:(NSString *)content media:(NSArray *)mediaArr cover_url:(NSString *)cover_url no_name:(NSInteger)no_name themeID:(NSString *)themeID address:(NSString *)address media_attr:(NSString *)media_attr at:(NSString *)at  shop_id:(NSString *)shop_id shop_title:(NSString *)shop_title Success:(CommonBoolCompletionBlock)block;



//七牛视频动态路径
-(void)addDynamicContent:(NSString *)content WithVideo:(NSDictionary *)videoDic andaudio:(NSString *)path Success:(CommonVoidBlock)block;
//发布动态评论 rid 动态id，content评论内容
-(void)addDynamicReplyID:(NSString *)rid WihtiContent:(NSString *)content adnAudio:(NSString *)audioPath Success:(CommonVoidBlock)block;

//点赞
-(void)addDolikeID:(NSString *)rid isLike:(BOOL)isLike Success:(CommonCompletionBlock)block;

//删除动态
-(void)delZone:(NSString *)rid Success:(CommonVoidBlock)block;

//关注用户
-(void)addFollowUID:(NSString *)uid Success:(CommonVoidDicBlock)block;

//转发动态
-(void)dynamicForwardWithDynamic_id:(NSString *)dynamic_id Success:(CommonVoidBlock)block;

//获取话题接口
-(void)dynamicGetTopicModelWithUID:(NSString *)uid Success:(CommonVoidDicBlock)block;

//系统消息
-(void)loadMsg_ListData;

//系统消息
-(void)fetchUnRead_MsgSuccess:(CommonVoidDicBlock)block;

@end

NS_ASSUME_NONNULL_END
