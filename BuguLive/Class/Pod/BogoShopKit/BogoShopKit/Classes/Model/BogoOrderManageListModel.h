//
//  BogoOrderManageListModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderManageListRefundModel : FDModel

//    "content": "q",
//    "reason": "不想要了",
//    "refund_img": "",
//    "refund_number": "",
//    "refund_name": "",
//    "time_format": ""

@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *reason;
@property(nonatomic, copy) NSString *refund_img;
@property(nonatomic, copy) NSString *refund_number;
@property(nonatomic, copy) NSString *refund_name;
@property(nonatomic, copy) NSString *time_format;

@end

@interface BogoOrderManageListModel : FDModel

//"so_id": 19,//订单ID
//"uid": "100620",//购买用户ID
//"from_uid": "1",//商户ID
//"sid": "2",//店铺ID
//"gid": "11",//商品ID
//"sa_id": "30",//规格ID
//"pt_id": "2",
//"a_id": "8",
//"name": "张三",//收货人姓名
//"tel": "17501082512",//电话
//"address": "北京 北京 西城区 西四北三条",//收货地址
//"price": 500,//单价
//"number": 10,//数量
//"free_shipping": 0,
//"money": 5000,//总价
//"order_id": "100620_20190619212536_296317",//订单号
//"pay_order_id": "",
//"add_time": 1560950736,//提交时间
//"pay_time": 1560950736,//支付时间
//"edit_time": 1560950736,//最后修改时间
//"pay_type": 1,//支付类型
//"status":
//"user_remark": "asdf",//用户备注
//"shop_remark": "我的我的",//商家备注
//"remark": "欢迎下次选购",//平台备注
//"express_number": "",//快递单号
//"express_name": "",//快递名称
//"shop_order_cid": "",
//"order": 50,
//"coupon_id": 0,//优惠券ID
//"goods_title": "",//商品名称
//"goods_icon":"",//商品图
//"attr_name": "悟饭"//规格名称

//refund_data": {
//    "content": "q",
//    "reason": "不想要了",
//    "refund_img": "",
//    "refund_number": "",
//    "refund_name": "",
//    "time_format": ""
//}

@property(nonatomic, copy) NSString *so_id;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *from_uid;
@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *gid;
@property(nonatomic, copy) NSString *sa_id;
@property(nonatomic, copy) NSString *pt_id;
@property(nonatomic, copy) NSString *a_id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *free_shipping;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *pay_order_id;
@property(nonatomic, copy) NSString *add_time;
@property(nonatomic, copy) NSString *pay_time;
@property(nonatomic, copy) NSString *edit_time;
@property(nonatomic, copy) NSString *pay_type;
@property(nonatomic, copy) NSString *pay_type_name;

//22 全部；0代付款；1代发货；2待收货；3 已完成；11退货/款
@property(nonatomic, copy) NSString *status;
//11是申请中 12 是退款中 13已完成  14拒绝 18取消  
@property(nonatomic, copy) NSString *refund_status;

@property(nonatomic, copy) NSString *user_remark;
@property(nonatomic, copy) NSString *shop_remark;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *express_number;
@property(nonatomic, copy) NSString *express_name;
@property(nonatomic, copy) NSString *shop_order_cid;
@property(nonatomic, copy) NSString *order;
@property(nonatomic, copy) NSString *coupon_id;
@property(nonatomic, copy) NSString *goods_title;
@property(nonatomic, copy) NSString *goods_icon;
@property(nonatomic, copy) NSString *attr_name;

@property(nonatomic, copy) BogoOrderManageListRefundModel *refund_data;

// 0:下单未支付,
//            // 1:已经支付(用户)--未发货(商家),
//            // 2:未收货(用户)--已经发货(商家),
//            // 3:已收货,
//            // 4:取消订单,
//            // 5:删除订单（用户）,
//            // 6:删除订单（商家）,
//            // 7:删除订单（用户和商家）,
//            // 11:申请退款(用户)--未退款(商家),
//            // 12:未确认退款(用户)--已退款(商家),
//            // 13:确认已退款 （退款备用）,
//            // 14:拒绝退款（商家）,
//            // 15:未确认退款(用户)--已退款(平台),
//            // 16:拒绝退款(平台),

@end

NS_ASSUME_NONNULL_END
