//
//  BogoShopInfoModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoShopInfoModel : FDModel

//uid": "1",
//"title": "超级无敌网店",
//"logo": "http://douyin.qiniu.bugukj.com/image/jx2pkwko_3d2ya4575ba95d09b3616c180.jpg",
//"status": 1,
//"remark": "",
//"province": "",
//"city": "",
//"county": "",
//"income": 0,
//"income_total": 0,
//"model_id": 0,
//"express_id": 1,
//"express_name": "申通快递"

@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *status;//状态 0申请中，1成功，2失败,
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *county;
@property(nonatomic, copy) NSString *income;
@property(nonatomic, copy) NSString *income_total;
@property(nonatomic, copy) NSString *model_id;
@property(nonatomic, copy) NSString *express_id;
@property(nonatomic, copy) NSString *express_name;
@property(nonatomic, copy) NSString *address_info;

//"cat_id": "2",
//"cat_name": "家居家装",
@property(nonatomic, copy) NSString *cat_id;
@property(nonatomic, copy) NSString *cat_name;

//"id_card1": "http:\/\/douyin.qiniu.bugukj.com\/fe-37HEsiNTNA-6qSIB57ZTPBuy-FNdrUEpe8SZM:hfwDqssIn9SJHSAaDpH5QlJPDYg=:eyJzY29wZSI6ImRvdXlpbiIsImRlYWRsaW5lIjoxNTg3NDQ1MzQ2LCJ1cEhvc3RzIjpbImh0dHA6XC9cL3VwLnFpbml1LmNvbSI",
//"id_card2": "http:\/\/douyin.qiniu.bugukj.com\/fe-37HEsiNTNA-6qSIB57ZTPBuy-FNdrUEpe8SZM:EyVAu2bhNXl8mR5DnRND5-_xt-w=:eyJzY29wZSI6ImRvdXlpbiIsImRlYWRsaW5lIjoxNTg3NDQ1MzQ5LCJ1cEhvc3RzIjpbImh0dHA6XC9cL3VwLnFpbml1LmNvbSI",
//"id_card_number": "你在哪里",
//"name": "你在",
//        "banner": "http:\/\/douyin.qiniu.bugukj.com\/fe-37HEsiNTNA-6qSIB57ZTPBuy-FNdrUEpe8SZM:UwI7CV1YMdLjHIMaZGTbO9emqO4=:eyJzY29wZSI6ImRvdXlpbiIsImRlYWRsaW5lIjoxNTg3NDQ1MzYxLCJ1cEhvc3RzIjpbImh0dHA6XC9cL3VwLnFpbml1LmNvbSIsImh0dHA6XC9cL3VwbG9hZC5xaW5pdS5jb20iLCItSCB1cC5xaW5pdS5jb20gaHR0cDpcL1wvMTgzLjEzMS43LjMiXX0=1587441761.png,,,,",

@property(nonatomic, copy) NSString *id_card1;
@property(nonatomic, copy) NSString *id_card2;
@property(nonatomic, copy) NSString *id_card_number;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *banner;

//"refund_province":"" 退货省份ID
//"refund_city":"" 退货城市ID
//"refund_county":"" 退货县/区ID
//"refund_address_info":"" 退货详细地址

@property(nonatomic, copy) NSString *refund_province;
@property(nonatomic, copy) NSString *refund_city;
@property(nonatomic, copy) NSString *refund_county;
@property(nonatomic, copy) NSString *refund_address_info;

@end

NS_ASSUME_NONNULL_END
