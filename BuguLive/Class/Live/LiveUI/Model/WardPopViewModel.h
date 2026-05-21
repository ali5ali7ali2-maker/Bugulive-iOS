//
//  WardPopViewModel.h
//  BuguLive
//
//  Created by 范东 on 2019/1/31.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WardPopViewModel : NSObject

//"uid": "164735",
//"nick_name": "فارس......",
//"head_image": "http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/201808/164735/1535717138581.png",
//"sex": "1",
//"user_level": "37",
//"type": "1",
//"total_diamonds": "1"

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *user_level;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *total_diamonds;

@property(nonatomic, strong) NSString *endtime;

@end

NS_ASSUME_NONNULL_END
