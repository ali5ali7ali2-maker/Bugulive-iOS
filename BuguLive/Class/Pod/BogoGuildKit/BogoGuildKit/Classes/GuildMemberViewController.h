//
//  GuildMemberViewController.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "BogoGuildKit.h"
@class GuildDetailModelFamily_info;

NS_ASSUME_NONNULL_BEGIN

@interface GuildMemberViewController : BogoGuildKitBaseViewController

@property(nonatomic, copy) NSString *family_id;

@property(nonatomic, assign) NSInteger showIndex;

@property(nonatomic, strong) GuildDetailModelFamily_info *familyModel;

@end

NS_ASSUME_NONNULL_END
