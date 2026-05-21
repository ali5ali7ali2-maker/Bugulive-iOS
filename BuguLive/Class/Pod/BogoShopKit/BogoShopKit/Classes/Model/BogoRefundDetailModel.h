//
//  BogoRefundDetailModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoRefundDetailModel : FDModel

//"id": 1,
//"uid": 100620,
//"so_id": 11,
//"content": "q",
//"reason": "不想要了",
//"reason_id": 1,
//"refund_img": "",
//"refund_status": 0,
//"refund_number": "",
//"refund_name": "",
//"create_time": 1584601782,
//"edit_time": 0,
//"time_format": "",
//"goods_title": "超级赛亚人合辑 悟空悟饭全集8",
//"goods_icon": "http://douyin.qiniu.bugukj.com/shopGoodsIcon/c84b7eff2b42c50d7705c90bb53bf1631560411713189.jpeg",
//"attr_name": "悟饭",
//"price": 5000,
//"number": 2,
//"money": 12200,
//"gid": "13",
//"sid": "2",
//"from_uid": "1"

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *so_id;
@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *reason;
@property(nonatomic, copy) NSString *reason_id;
@property(nonatomic, copy) NSString *refund_img;
@property(nonatomic, copy) NSString *refund_status;
@property(nonatomic, copy) NSString *refund_number;
@property(nonatomic, copy) NSString *refund_name;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *edit_time;
@property(nonatomic, copy) NSString *time_format;
@property(nonatomic, copy) NSString *goods_title;
@property(nonatomic, copy) NSString *goods_icon;
@property(nonatomic, copy) NSString *attr_name;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *gid;
@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *from_uid;
@property(nonatomic, copy) NSString *tel;

@end

NS_ASSUME_NONNULL_END
