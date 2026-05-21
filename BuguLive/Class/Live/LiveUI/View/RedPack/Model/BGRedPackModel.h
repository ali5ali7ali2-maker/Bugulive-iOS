//
//  BGRedPackModel.h
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGRedPackModel :NSObject
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * nick_name;
@property (nonatomic , copy) NSString              * head_image;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * desc_content;
@property (nonatomic , copy) NSString              * start_time;
@property (nonatomic , copy) NSString              * diamonds_quantity;
@property (nonatomic , copy) NSString              * video_id;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * people_quantity;
@property (nonatomic , copy) NSString              * create_time;

@end


NS_ASSUME_NONNULL_END
