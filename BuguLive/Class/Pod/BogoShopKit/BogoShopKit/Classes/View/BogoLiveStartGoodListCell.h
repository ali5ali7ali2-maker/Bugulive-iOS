//
//  BogoLiveStartGoodListCell.h
//  BuGuDY
//
//  Created by bogokj on 2020/3/27.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "FDUIKitObjC.h"
#import <QMUIKit/QMUIKit.h>
@class BogoLiveStartGoodListCell;
@class BogoCommodityDetailModel;

typedef NS_ENUM(NSInteger, BogoLiveStartGoodListCellType) {
    BogoLiveStartGoodListCellTypeAdd,//主播添加商品
    BogoLiveStartGoodListCellTypeList,//主播商品列表
    BogoLiveStartGoodListCellTypeForUser,//观众
    BogoLiveStartGoodListCellTypeManagement//商品管理添加商品
};

NS_ASSUME_NONNULL_BEGIN

@protocol BogoLiveStartGoodListCellDelegate <NSObject>

- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickOperateBtn:(UIButton *)sender;
- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickSayBtn:(UIButton *)sender;

@end

@interface BogoLiveStartGoodListCell : FDTableViewCell

@property(nonatomic, weak) id<BogoLiveStartGoodListCellDelegate>delegate;

@property(nonatomic, assign) BogoLiveStartGoodListCellType type;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, assign) NSInteger row;

@property (weak, nonatomic) IBOutlet QMUIButton *operateBtn;
@property (weak, nonatomic) IBOutlet UIButton *inBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *sayBtn;

@property (weak, nonatomic) IBOutlet QMUIButton *shopAddBtn;


@end

NS_ASSUME_NONNULL_END
