//
//  music_obj.h
//  BuguLive
//
//  Created by bugu on 2019/5/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface music_obj : NSObject
@property (nonatomic, copy)NSString *id/*音乐id*/,
                                    *music_name/*音乐名称*/,
                                    *music_url/*音乐地址*/,
                                    *cover/*封面*/,
                                    *music_time/*时间*/,
                                    *music_author/*作者*/,
                                    *localPatch,
                                    *video_type;
@property (nonatomic, assign)int is_collection/*是否收藏*/,
                                    has_next,
                                    page;
@property (nonatomic, assign) BOOL isselect;
@end
