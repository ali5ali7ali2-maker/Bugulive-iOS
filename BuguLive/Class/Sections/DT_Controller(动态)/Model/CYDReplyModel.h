//
//  CYDReplyModel.h
//  MarryU
//
//  Created by 志刚杨 on 2017/6/29.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserPageInfoModel.h"

#import "MGGroupUserInfo.h"

@interface CYDReplyModel : NSObject

@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *audio;
@property(nonatomic, strong) NSString *body;
@property(nonatomic, strong) NSString *audio_duration;
@property(nonatomic, strong) NSString *comments;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *cover_url;
@property(nonatomic, strong) NSString *forwarding;
@property(nonatomic, strong) NSString *head_image;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) MGGroupUserInfo *userInfo;

@end
