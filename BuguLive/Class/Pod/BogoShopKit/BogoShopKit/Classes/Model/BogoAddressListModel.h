//
//  BogoAddressListModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoAddressListModel : FDModel

//"sa_id": 8,
//"uid": "100620",
//"name": "张三",
//"tel": "17501082512",
//"province": "100000",
//"city": "101000",
//"district": "101011",
//"address": "西四北三条",
//"addtime": 1560910599,
//"edittime": 1560910599,
//"status": 1,
//"remark": "",
//"sa_cid": "",
//"sa_order": 50

@property(nonatomic, copy) NSString *sa_id;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *district;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *edittime;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *sa_cid;
@property(nonatomic, copy) NSString *sa_order;
@property(nonatomic, copy) NSString *area_code;

@end

NS_ASSUME_NONNULL_END
