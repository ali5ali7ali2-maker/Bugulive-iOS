//
//  BogoVideoPlayCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/20.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BogoVideoPlayCell;
@protocol BogoVideoTableViewCellDataSource, BogoVideoTableViewCellDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BogoVideoPlayCell : UITableViewCell
+ (void)registerWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak, nullable) id<BogoVideoTableViewCellDataSource> dataSource;
@property (nonatomic, weak, nullable) id<BogoVideoTableViewCellDelegate> delegate;




@end

@protocol BogoVideoTableViewCellDataSource
@property (nonatomic, copy, readonly, nullable) NSString *cover;
@property (nonatomic, copy, readonly, nullable) NSAttributedString *mediaTitle;
@property (nonatomic, copy, readonly, nullable) NSString *avatar;
@property (nonatomic, copy, readonly, nullable) NSAttributedString *username;
@end

@protocol BogoVideoTableViewCellDelegate
- (void)coverItemWasTapped:(BogoVideoPlayCell *)cell;

@end

NS_ASSUME_NONNULL_END


