//
//  AuctionTagCell.h
//  BuguLive
//
//  Created by 布谷 on 2017/9/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsModel.h"
@interface AuctionTagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) TagsModel * model;
@end
