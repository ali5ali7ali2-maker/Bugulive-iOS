//
//  GuildRankTopCell.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import <UIKit/UIKit.h>
@class GuildDetailModelFamily_info;
@class GuildDetailModelLists;
@class GuildRankTopCell;
#import "BogoGuildKit.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GuildRankTopCellDelegate <NSObject>

- (void)topCell:(GuildRankTopCell *)topCell didClickViewAction:(UITapGestureRecognizer *)sender;

@end

@interface GuildRankTopCell : UITableViewCell

@property(nonatomic, strong) NSArray <GuildDetailModelFamily_info *>*familyDataArray;
@property(nonatomic, strong) NSArray <GuildDetailModelLists *>*userDataArray;
@property(nonatomic, assign) GuildRankSubViewControllerType type;
@property(nonatomic, weak) id<GuildRankTopCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
