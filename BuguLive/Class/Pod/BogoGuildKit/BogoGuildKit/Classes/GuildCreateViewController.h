//
//  GuildCreateViewController.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "BogoGuildKit.h"
@class GuildCreateViewController;
@class GuildDetailModelFamily_info;

NS_ASSUME_NONNULL_BEGIN

@protocol GuildCreateViewControllerDelegate <NSObject>

- (void)createVC:(GuildCreateViewController *)createVC didCreateFinished:(NSString *)family_id;
- (void)createVC:(GuildCreateViewController *)createVC didEditFinished:(NSString *)family_id;

@end

@interface GuildCreateViewController : BogoGuildKitBaseViewController

@property(nonatomic, weak) id<GuildCreateViewControllerDelegate>delegate;

@property(nonatomic, strong) GuildDetailModelFamily_info *model;



@end

NS_ASSUME_NONNULL_END
