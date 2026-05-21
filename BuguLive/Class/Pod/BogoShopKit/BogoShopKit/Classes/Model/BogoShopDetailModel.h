//
//  BogoShopDetailModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/7.
//

#import "FDModel.h"
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoShopDetailInfoModel : FDModel

//    "sid": 2,
//    "uid": "1",
//    "logo": "http://douyin.qiniu.bugukj.com/image/jx2pkwko_3d2ya4575ba95d09b3616c180.jpg",
//    "title": "超级无敌网店",
//    "city": "",
//    "goods_num": 11

@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *goods_num;

@end

@interface BogoShopDetailListModel : FDModel

//    "total": 11,
//    "per_page": 10,
//    "current_page": 1,
//    "last_page": 2,
//    "data": 2,

@property(nonatomic, strong) NSArray<BogoCommodityDetailModel *> *data;

@end

@interface BogoShopDetailModel : FDModel

//"shop_info": {

//},
//"list":{
//    "total": 11,
//    "per_page": 10,
//    "current_page": 1,
//    "last_page": 2,
//    -"data": [
//    -    {
//        "gid": 13,
//        "uid": "1",
//        "sid": "2",
//        "title": "超级赛亚人合辑 悟空悟饭全集8",
//        "stitle": "超级赛亚人",
//        "cat_id": "3",
//        "type": 0,
//        "icon": "http://douyin.qiniu.bugukj.com/shopGoodsIcon/c84b7eff2b42c50d7705c90bb53bf1631560411713189.jpeg",
//        "total_sales": 2,
//        "price": 2000
//        }
//    ]
//}

@property(nonatomic, strong) BogoShopDetailInfoModel *shop_info;
@property(nonatomic, strong) BogoShopDetailListModel *list;

@end

NS_ASSUME_NONNULL_END
