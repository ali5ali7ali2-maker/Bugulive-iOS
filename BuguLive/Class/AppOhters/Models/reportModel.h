//
//  reportModel.h
//  BuguLive
//
//  Created by fanwe2014 on 16/6/1.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reportModel : NSObject

@property(nonatomic,assign)int ID;

@property(nonatomic,retain)NSString *name;

//视频评论举报
@property(nonatomic, strong) NSString *to_userID;
@property(nonatomic, strong) NSString *weibo_id;

@end
