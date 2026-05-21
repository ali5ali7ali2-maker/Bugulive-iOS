//
//  BogoRefundReasonModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import <BRPickerView/BRResultModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoRefundReasonModel : BRResultModel

//"id": 1,
//"reason_name": "不想要了"

@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *value;

@property(nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
