//
//  BogoGuildKit.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BogoGuildViewController.h"
#import "BogoGuildKitBaseViewController.h"

//#define kBogoGuildKitBundle [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"BogoGuildKit")] pathForResource:@"BogoGuildKit" ofType:@"bundle"]]
//
//#define kBogoGuildKitBundleImageNamed(name) [UIImage imageNamed:name inBundle:kBogoGuildKitBundle compatibleWithTraitCollection:nil]

#define kBogoGuildKitBundle [NSBundle mainBundle]

#define kBogoGuildKitBundleImageNamed(name) [UIImage imageNamed:name inBundle:kBogoGuildKitBundle compatibleWithTraitCollection:nil]

#define kNotificationGuildChangeKey @"kNotificationGuildChangeKey"

#define kNotificationGuildToUserPageKey @"kNotificationGuildToUserPageKey"
#define kNotificationGuildToAuthKey @"kNotificationGuildToAuthKey"

#define kNotificationGuildRankUpdateKey @"kNotificationGuildRankUpdateKey"

typedef NS_ENUM(NSInteger, GuildMemberSubViewControllerType) {
    GuildMemberSubViewControllerTypeApply = 0,
    GuildMemberSubViewControllerTypeMember = 1
};

typedef NS_ENUM(NSInteger, GuildRankSubViewControllerType) {
    GuildRankSubViewControllerTypeAll,
    GuildRankSubViewControllerTypeWeek,
    GuildRankSubViewControllerTypeDay,
    GuildRankSubViewControllerTypeMemberAll,
    GuildRankSubViewControllerTypeMemberDay
};

NS_ASSUME_NONNULL_BEGIN

@interface BogoGuildKit : NSObject

@end

NS_ASSUME_NONNULL_END
