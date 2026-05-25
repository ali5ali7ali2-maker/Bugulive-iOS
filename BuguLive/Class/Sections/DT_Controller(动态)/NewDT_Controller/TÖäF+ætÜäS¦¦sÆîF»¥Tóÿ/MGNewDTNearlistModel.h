//
//  MGNewDTNearlistModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/18.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MGNEWDTTYPE_NEAR_PEOPLE,//附近的人
    MGNEWDTTYPE_TOPIC,//全部话题
} MGNEWDT_TYPE;

@interface MGNewDTNearlistModel : NSObject
//"id": "164743",
//"nick_name": "\u6765\u770b\u770b\u6211\u5417",
//"sex": "2",
//"head_image": "http:\/\/fw25live.oss-cn-beijing.aliyuncs.com\/public\/attachment\/201903\/07\/11\/5c808ec6dd451.png?x-oss-process=image\/resize,m_mfit,h_50,w_50",
//"v_type": "0",
//"logout_time": "2019-12-18 17:12:27",
//"juli": "0"
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *nick_name;
@property(nonatomic, strong) NSString *sex;
@property(nonatomic, strong) NSString *head_image;
@property(nonatomic, strong) NSString *v_type;
@property(nonatomic, strong) NSString *logout_time;
@property(nonatomic, strong) NSString *juli;


@end

NS_ASSUME_NONNULL_END
