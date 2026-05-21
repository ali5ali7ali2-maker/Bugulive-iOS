//
//  BogoShopFillInfoTextCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import <UIKit/UIKit.h>
@class BogoShopFillInfoTextCell;
@class QMUITextField;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoShopFillInfoTextCellType) {
    BogoShopFillInfoTextCellTypeIDName,
    BogoShopFillInfoTextCellTypeIDNumber,
    BogoShopFillInfoTextCellTypeName,
    BogoShopFillInfoTextCellTypeDetailAddress,
    BogoShopFillInfoTextCellTypeAddressArea1,//所在地区
    BogoShopFillInfoTextCellTypeEditTransferNo,
    BogoShopFillInfoTextCellTypeAddressName,
    BogoShopFillInfoTextCellTypeAddressTel,
    BogoShopFillInfoTextCellTypeOrderSubmitRemark,
    BogoShopFillInfoTextCellTypeRefundAddress,
    BogoShopFillInfoTextCellTypeSendAddress,
    BogoShopFillInfoTextCellTypeShopTitle,
};

@protocol BogoShopFillInfoTextCellDelegate <NSObject>

- (void)textCell:(BogoShopFillInfoTextCell *)textCell didChangeText:(UITextField *)textField;

@end

@interface BogoShopFillInfoTextCell : UITableViewCell

@property(nonatomic, assign) BogoShopFillInfoTextCellType type;

@property(nonatomic, weak) id<BogoShopFillInfoTextCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic, assign) BOOL isSee;

@end

NS_ASSUME_NONNULL_END
