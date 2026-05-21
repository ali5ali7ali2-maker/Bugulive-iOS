//
//  VoiceRoomSetInfoModel.h
//  BuguLive
//
//  Created by voidcat on 2024/5/27.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceRoomSetInfoModel : NSObject
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * announcement;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * is_voice;
@property (nonatomic , copy) NSString              *  people_count;
@property (nonatomic , assign) NSInteger              is_room_administrator;
@property (nonatomic , copy) NSString              * live_image;
@property (nonatomic , copy) NSString              *  classified_id;
@property (nonatomic , copy) NSString              *  voice_bg;
@end

NS_ASSUME_NONNULL_END
