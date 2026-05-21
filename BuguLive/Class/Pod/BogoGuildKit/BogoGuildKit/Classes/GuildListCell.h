//
//  GuildListCell.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import <UIKit/UIKit.h>
@class GuildDetailModelFamily_info;

NS_ASSUME_NONNULL_BEGIN

@interface GuildListCell : UICollectionViewCell

@property(nonatomic, strong) GuildDetailModelFamily_info *model;

@end

NS_ASSUME_NONNULL_END
