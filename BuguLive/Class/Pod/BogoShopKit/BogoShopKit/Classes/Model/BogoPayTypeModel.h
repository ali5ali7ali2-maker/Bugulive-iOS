//
//  BogoPayTypeModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/25.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoPayTypeModel : FDModel

//"pt_id": 2,
//"name": "支付宝",
//"icon": "http://douyin.qiniu.bugukj.com/image/jto1fm6o_4h2a22a2m6mi5c98850a8fc92.png",
//"class_name": "alipay_app",
//"type": "11"

@property(nonatomic, copy) NSString *pt_id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *class_name;
@property(nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
