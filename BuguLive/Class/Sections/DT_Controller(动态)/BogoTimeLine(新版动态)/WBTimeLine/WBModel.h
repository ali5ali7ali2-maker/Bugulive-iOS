//
//  WBModel.h
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBUserInfoModel;

@interface WBImageModel : NSObject

//    'id'：'图片id',
//    'zone_id'：'动态id',
//    'img'：'图片',
//    'addtime'：'时间',

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *zone_id;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *addtime;

@end

@interface WBLikeListModel : NSObject

//    'id':'喜欢的3个 用户id',
//    'avatar':'用户头像',
//    'user_nickname':'用户昵称',

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *user_nickname;

@end

@interface WBModel : NSObject

//"id":51,
//"is_audio":'是否包含音频 0否 1是',
//'topic':'动态话题',
//"audio_file":"音频路径",
//"publish_time":"发布时间",
//'time_difference':'昨天',
//"msg_content":"文本内容",
//"uid":'动态发布者id',
//"video_url":"视频路径",
//"cover_url":"视频封面",
//"city":"市",
//"lat":"经度",
//"lng":"纬度",
//"comment_count":'评论数量',
//"duration","语音时长",
//"is_online":'是否在线0否1在',
//"room_type":'房间上麦类型 null 没有 1 3人公开 2 3人私密 3 7人交友 4 7人相亲 5 造星场',
//"userInfo":{
//},
//"originalPicUrls":[{
//}],
//"thumbnailPicUrls":[{
//}],
//"is_like":"是否喜欢 0否 1是",
//"like_count":'喜欢总数',
//'like_list':[{
//}]

//@property(nonatomic, copy) NSString *id;
//@property(nonatomic, copy) NSString *is_audio;
//@property(nonatomic, copy) NSString *topic;
//@property(nonatomic, copy) NSString *audio_file;
//@property(nonatomic, copy) NSString *publish_time;
//@property(nonatomic, copy) NSString *time_difference;
//@property(nonatomic, copy) NSString *msg_content;
//@property(nonatomic, copy) NSString *video_url;
//@property(nonatomic, copy) NSString *cover_url;
//@property(nonatomic, copy) NSString *city;
//@property(nonatomic, copy) NSString *lat;
//@property(nonatomic, copy) NSString *lng;
//@property(nonatomic, copy) NSString *comment_count;
//@property(nonatomic, copy) NSString *duration;
//@property(nonatomic, copy) NSString *is_online;
//@property(nonatomic, copy) NSString *room_type;
//@property(nonatomic, strong) WBUserInfoModel *userInfo;
//@property(nonatomic, strong) NSArray *originalPicUrls;
//@property(nonatomic, strong) NSArray *thumbnailPicUrls;
//@property(nonatomic, copy) NSString *is_like;
//@property(nonatomic, copy) NSArray *like_list;
//@property(nonatomic, copy) NSString *like_count;
//@property(nonatomic, copy) NSString *is_focus;




//@property (nonatomic, strong) MGGroupUserInfo *forwardModel;//上一条动态

@property (nonatomic, copy)   NSString  *dynamicId; //动态Id
@property (nonatomic, copy)   NSString  *dynamic_id; //动态Id

@property (nonatomic, assign) NSInteger type;         //动态类型
//@property (nonatomic, assign) VisibleType visible;  //可见性
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *audio;
@property(nonatomic, strong) NSString *video;
@property(nonatomic, strong) NSString *audio_duration;
@property(nonatomic, strong) NSString *cover_url;
//@property(nonatomic, strong) NSString *video;
@property(nonatomic, strong) NSString *praise;
@property(nonatomic, strong) NSString *comments;
@property(nonatomic, strong) NSString *forwarding;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *nick_name;
@property(nonatomic, strong) NSString *head_image;
@property(nonatomic, strong) NSString *is_like;

@property(nonatomic, strong) NSString *industry;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *job;
@property(nonatomic, strong) NSString *publishTime;
@property(nonatomic, strong) NSString *timing;

@property(nonatomic, strong) NSString *sex;

@property(nonatomic, strong) NSString *theme_id;
@property(nonatomic, strong) NSString *theme;


@property (nonatomic, assign) BOOL isRepost;//转发
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@property (nonatomic, assign) BOOL showDeleteButton;
@property (nonatomic, assign) BOOL hiddenBotLine;//隐藏底部高度15的分隔线


@property (nonatomic, strong) NSArray <NSURL *>*picUrls; //原图像Url
@property (nonatomic, strong) NSArray <NSURL *>*thumbnailPicUrls;//缩略图Url

@property(nonatomic, assign) BOOL bottomViewSelect;


@property (nonatomic,copy) NSString *no_name;/**<*/
@property (nonatomic,copy) NSString *rank;/**<*/
@property (nonatomic,copy) NSString *media_attr;/**<*/

@property (nonatomic,copy) NSString *lng;/**<*/

@property (nonatomic,copy) NSString *juli;/**<*/
@property (nonatomic,copy) NSString *is_top;/**<*/
@property (nonatomic,copy) NSString *is_focus;/**<*/
@property (nonatomic,copy) NSString *at_user;/**<*/

@property (nonatomic,copy) NSString *lat;/**<*/
@property (nonatomic,copy) NSString *address;/**<*/



@end
