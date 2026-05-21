//
//  BogoShopFillInfoCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

@class BogoShopFillInfoCell;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoShopFillInfoCellType) {
    BogoShopFillInfoCellTypeType,
    BogoShopFillInfoCellTypeAddress,
    BogoShopFillInfoCellTypeAuth,
    BogoShopFillInfoCellTypeAvatar,
    BogoShopFillInfoCellTypeShopAvatar,
    BogoShopFillInfoCellTypeShopTitle,
    BogoShopFillInfoCellTypeShopTransfer,
    BogoShopFillInfoCellTypeShopAddress,
    BogoShopFillInfoCellTypeShopRefund,
    BogoShopFillInfoCellTypeSelectTransfer,
    BogoShopFillInfoCellTypeOrderTransfer,
    BogoShopFillInfoCellTypeOrderNo,
    BogoShopFillInfoCellTypeOrderTime,
    BogoShopFillInfoCellTypeOrderID,
    BogoShopFillInfoCellTypeOrderPayType,
    BogoShopFillInfoCellTypeOrderRemark,
    BogoShopFillInfoCellTypeOrderDeliver,
    BogoShopFillInfoCellTypeOrderMessage,
    BogoShopFillInfoCellTypeOrderRefundReason,
    BogoShopFillInfoCellTypeOrderRefundAccount,
    BogoShopFillInfoCellTypeOrderRefundPhone,
    BogoShopFillInfoCellTypeOrderRefundApplyTime,
    BogoShopFillInfoCellTypeOrderRefundNo,
    BogoShopFillInfoCellTypeOrderRefundTransfer,
    BogoShopFillInfoCellTypeOrderRefundVoucher,
    BogoShopFillInfoCellTypeOrderRefundInfo,
    BogoShopFillInfoCellTypeAddressArea,
    BogoShopFillInfoCellTypeGoodDetailAttr,
    BogoShopFillInfoCellTypeOrderSubmitTransfer,
    BogoShopFillInfoCellTypeName,
    BogoShopFillInfoCellTypeIDNumber,
    BogoShopFillInfoCellTypeMobile,
};


@protocol BogoShopFillInfoCellDelegate <NSObject>

-(void)shopFillInfoCellTextChange:(BogoShopFillInfoCell *)cell textField:(UITextField *)textField;

@end

@interface BogoShopFillInfoCell : UITableViewCell

@property(nonatomic, assign) BogoShopFillInfoCellType type;

@property (nonatomic, copy) NSString *rightTitle;

@property(nonatomic, strong) UIImage *rightImage;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *rightTextField;

@property(nonatomic, strong) id<BogoShopFillInfoCellDelegate> delegate;

@property(nonatomic, assign) BOOL isSee;

@end

NS_ASSUME_NONNULL_END
