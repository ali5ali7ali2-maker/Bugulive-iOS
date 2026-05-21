//
//  MGShopTableCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/17.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGShopListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGShopTableCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *shopImgView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
@property (weak, nonatomic) IBOutlet UILabel *shopNumL;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;

@property(nonatomic, strong) MGShopListModel *model;

-(void)resetViewWithModel:(MGShopListModel *)model;

@end

NS_ASSUME_NONNULL_END
