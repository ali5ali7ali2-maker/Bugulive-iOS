//
//  BogoNewsHeadTypeModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGroupUserInfo.h"

@class BogoNewsHeadTypeInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoNewsHeadTypeModel : NSObject

@property(nonatomic, strong) NSString *nick_name;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *head_image;
@property(nonatomic, strong) NSString *msg_content;
@property(nonatomic, strong) NSString *cover_url;
@property(nonatomic, strong) NSString *video_url;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *dynamic_id;
@property(nonatomic, strong) NSString *create_time;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *content;

@property (nonatomic, assign) DynType type;         //动态类型
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) BogoNewsHeadTypeInfoModel *info;








//@property (nonatomic, assign) DynType type;         //动态类型
//@property (nonatomic, assign) VisibleType visible;  //可见性


@property(nonatomic, strong) NSString *audio;
@property(nonatomic, strong) NSString *video;
@property(nonatomic, strong) NSString *audio_duration;

@property(nonatomic, strong) NSString *praise;
@property(nonatomic, strong) NSString *comments;
@property(nonatomic, strong) NSString *forwarding;

@property(nonatomic, strong) NSString *status;


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
@property (nonatomic,copy) NSNumber *is_focus;/**<*/
@property (nonatomic,copy) NSString *at_user;/**<*/

@property (nonatomic,copy) NSString *lat;/**<*/
@property (nonatomic,copy) NSString *address;/**<*/




@end


@interface BogoNewsHeadTypeInfoModel : NSObject

//"weibo_id": "499",
//        "photo_image": "http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/202109/166238/202109011130092191.png",
//        "content": "coco",
//        "video_url": "http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/202109/166238/202109011130105809.mp4",
//        "head_img": "http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/202105/165999/202105071753215009.png",
//        "nick_name": "腊月"
@property(nonatomic, copy) NSString *weibo_id;
@property(nonatomic, copy) NSString *photo_image;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *video_url;
@property(nonatomic, copy) NSString *head_img;
@property(nonatomic, copy) NSString *nick_name;

@end

NS_ASSUME_NONNULL_END
