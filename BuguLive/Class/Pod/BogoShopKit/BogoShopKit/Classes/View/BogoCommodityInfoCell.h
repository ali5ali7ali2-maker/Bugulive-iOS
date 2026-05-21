//
//  BogoCommodityInfoCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "FDTableViewCell.h"
@class BogoCommodityInfoCell;
@class BogoCommodityDetailModel;
@class QMUITextField;
@class QMUITextView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoCommodityInfoCellType) {
    BogoCommodityInfoCellTypeTitle,
    BogoCommodityInfoCellTypeSet,
    BogoCommodityInfoCellTypeModelName,
    BogoCommodityInfoCellTypeModelPrice,
    BogoCommodityInfoCellTypeModelCount,
    BogoCommodityInfoCellTypeTransferFee,
    BogoCommodityInfoCellTypeRefundDesc,
    BogoCommodityInfoCellTypeRefundPhone
};

@protocol BogoCommodityInfoCellDelegate <NSObject>

-(void)infoCell:(BogoCommodityInfoCell *)infoCell didTextFieldChange:(UITextField *)textField;
-(void)infoCell:(BogoCommodityInfoCell *)infoCell didTextViewChange:(QMUITextView *)textField;

@end

@interface BogoCommodityInfoCell : FDTableViewCell

@property(nonatomic, assign) BogoCommodityInfoCellType type;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoCommodityInfoCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet QMUITextField *textField;

@property(nonatomic, assign) BOOL isSee;

@end

NS_ASSUME_NONNULL_END
