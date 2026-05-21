//
//  GuildRankSubViewController.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import "BogoGuildKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildRankSubViewController : BogoGuildKitBaseViewController

@property(nonatomic, assign) GuildRankSubViewControllerType type;
@property(nonatomic, copy) NSString *family_id;
@property(nonatomic, assign) BOOL isFromDetailVC;

@end

NS_ASSUME_NONNULL_END
