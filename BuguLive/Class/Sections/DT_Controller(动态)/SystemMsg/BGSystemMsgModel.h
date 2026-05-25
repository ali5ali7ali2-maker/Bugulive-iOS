//
//  BGSystemMsgModel.h
//  BuguLive
//
//  Created by bugu on 2019/12/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGSystemMsgModel : NSObject

@property (nonatomic,copy) NSString *content;/**<*/
@property (nonatomic,copy) NSString *link_url;/**<*/
@property (nonatomic,copy) NSString *id;/**<*/
@property (nonatomic,copy) NSString *pub_detail;/**<*/
@property (nonatomic,copy) NSString *title;/**<*/
@property (nonatomic,copy) NSString *addtime;/**<*/
@property (nonatomic,copy) NSString *type;/**<*/
@property (nonatomic,copy) NSString *users;/**<*/
@property (nonatomic,copy) NSString *url;/**<*/

@property (nonatomic, assign) int mMsgType;     //0 时间消息, 1 文字消息, 2,图片消息,3 语音消息,4 礼物

- (NSString *)getTimeStr;

@end

NS_ASSUME_NONNULL_END
