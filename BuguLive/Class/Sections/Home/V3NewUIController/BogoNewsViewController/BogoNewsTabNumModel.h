//
//  BogoNewsTabNumModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/12.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoNewsTabNumModelMessage : NSObject

@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, assign) NSInteger count;

@end

@interface BogoNewsTabNumModel : NSObject

@property(nonatomic, assign) NSInteger bzone_reply;
@property(nonatomic, assign) NSInteger bzone_like;

@property(nonatomic, strong) BogoNewsTabNumModelMessage *msg;

//"msg": {
//      "content": "商家后台地址：,后台账号：166238密码：111111,请及时登录修改密码",
//      "addtime": "1630465950"
//    }

@end

NS_ASSUME_NONNULL_END
