//
//  STVideoCateCell.h
//  BuguLive
//
//  Created by bugu on 2019/12/3.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class STVideoCateCell;
@protocol STVideoCateCellDelegate <NSObject>

@optional
//
-(void)showSTVideoCateCell:(STVideoCateCell *)cell andChooseCateClick:(QMUIButton *)cateBtn;
@end

@interface STVideoCateCell : UITableViewCell

@property(nonatomic, strong) QMUIButton *leftBtn;

@property(nonatomic, strong) QMUIButton *cateBtn;


@property (weak, nonatomic) id<STVideoCateCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
