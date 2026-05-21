//
//  BogoVirtualListModel.h
//  BuguLive
//
//  Created by Mac on 2021/1/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoVirtualListModel : NSObject
//"id": 973,
//            "money": 10, 金额
//            "addtime": 1618986806, 时间
//            "content": "兑换桃花" 说明

//id": 973,
//            "coin": 10, 充值金额
//            "addtime": 1618986806, 充值时间
//            "content": "收益兑换桃花" 充值说明
//
//"to_user_id": 200688,
//            "content": "赠送礼物消费--月老我是昵称限制", 消费说明
//            "coin": 9999, 消费金额
//            "addtime": 1618801428  消费时间

@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *coin;
@property(nonatomic, copy) NSString *to_user_id;

@end

NS_ASSUME_NONNULL_END
