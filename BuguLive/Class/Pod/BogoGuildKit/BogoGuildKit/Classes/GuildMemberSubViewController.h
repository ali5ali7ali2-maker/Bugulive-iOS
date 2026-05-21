//
//  GuildMemberSubViewController.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "BogoGuildKit.h"
@class GuildDetailModelFamily_info;

NS_ASSUME_NONNULL_BEGIN

@interface GuildMemberSubViewController : BogoGuildKitBaseViewController

@property(nonatomic, assign) GuildMemberSubViewControllerType type;
@property(nonatomic, copy) NSString *family_id;
@property(nonatomic, strong) GuildDetailModelFamily_info *familyModel;

- (void)headerRefresh;

@end

NS_ASSUME_NONNULL_END
