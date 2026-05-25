//
//  MGUserInfo.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/4/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>


//"id": "30",
//"uid": "9",
//"content": "aaaa",
//"audio": "",
//"video": "",
//"audio_duration": "0",
//"cover_url": "",
//"praise": "0",
//"comments": "0",
//"forwarding": "0",
//"addtime": "1555901175",
//"status": "1",
//"nick_name": "\u6258\u7f57\u592b\u65af\u57fa",
//"head_image": "http:\/\/fw25live.oss-cn-beijing.aliyuncs.com\/public\/attachment\/201904\/9\/1555821250969.png",
//"is_like": 0

NS_ASSUME_NONNULL_BEGIN

//动态类型
typedef NS_ENUM(int,DynType){
    DynType_Original = 0, //原创
    DynType_Forward       //转发
};

//可见性
typedef NS_ENUM(int,VisibleType){
    Visible_AllPeople = 0,//所有人可见
    Visible_OnlyFriend    //仅好友可见
};



@interface MGGroupUserInfo : NSObject


@property (nonatomic, strong) MGGroupUserInfo *forwardModel;//上一条动态

@property (nonatomic, copy)   NSString  *dynamicId; //动态Id
@property (nonatomic, copy)   NSString  *dynamic_id; //动态Id

@property (nonatomic, assign) DynType type;         //动态类型
@property (nonatomic, assign) VisibleType visible;  //可见性
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *msg_content;
@property(nonatomic, strong) NSString *audio;
@property(nonatomic, strong) NSString *video;
@property(nonatomic, strong) NSString *audio_duration;
@property(nonatomic, strong) NSString *cover_url;
@property(nonatomic, strong) NSString *video_url;
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
@property (nonatomic,copy) NSNumber *is_focus;/**<*/
@property (nonatomic,copy) NSString *at_user;/**<*/

@property (nonatomic,copy) NSString *lat;/**<*/
@property (nonatomic,copy) NSString *address;/**<*/


//@property(nonatomic, strong) NSString *is_focus;

@end

NS_ASSUME_NONNULL_END
