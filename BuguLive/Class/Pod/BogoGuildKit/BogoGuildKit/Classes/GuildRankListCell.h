//
//  GuildRankListCell.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import <UIKit/UIKit.h>
@class GuildDetailModelFamily_info;
@class GuildDetailModelLists;

NS_ASSUME_NONNULL_BEGIN

@interface GuildRankListCell : UITableViewCell

@property(nonatomic, strong) GuildDetailModelFamily_info *familyModel;
@property(nonatomic, strong) GuildDetailModelLists *userModel;

@end

NS_ASSUME_NONNULL_END
