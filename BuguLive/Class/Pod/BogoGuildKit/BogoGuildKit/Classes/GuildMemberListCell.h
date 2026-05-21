//
//  GuildMemberListCell.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import <UIKit/UIKit.h>
#import "BogoGuildKit.h"
@class GuildMemberListCell;
@class GuildDetailModelLists;
@class GuildDetailModelFamily_info;

NS_ASSUME_NONNULL_BEGIN

@protocol GuildMemberListCellDelegate <NSObject>

- (void)listCell:(GuildMemberListCell *)listCell didClickDeleteBtn:(UIButton *)sender;
- (void)listCell:(GuildMemberListCell *)listCell didClickAgreeBtn:(UIButton *)sender;
- (void)listCell:(GuildMemberListCell *)listCell didClickRefuseBtn:(UIButton *)sender;

@end

@interface GuildMemberListCell : UITableViewCell

@property(nonatomic, weak) id<GuildMemberListCellDelegate>delegate;

@property(nonatomic, strong) GuildDetailModelLists *model;
@property(nonatomic, assign) GuildMemberSubViewControllerType type;
@property(nonatomic, strong) GuildDetailModelFamily_info *familyModel;

@end

NS_ASSUME_NONNULL_END
