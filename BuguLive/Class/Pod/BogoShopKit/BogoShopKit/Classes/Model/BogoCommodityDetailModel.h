//
//  BogoCommodityDetailModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "FDFoundationObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoCommodityDetailShopModel : FDModel

//    "uid": "100598",
//    "title": "小店有请",//店铺ID
//    "logo"://店铺logo "http://douyin.qiniu.bugukj.com/image/k3tsmh74_3peab7loujne5de9fafa7716d.png"

@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *shop_title;
@property(nonatomic, copy) NSString *gid;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *original_price;
@property(nonatomic, copy) NSString *model_id;
@property(nonatomic, copy) NSString *link_url;

@property(nonatomic, copy) NSString *nick_name;

@property(nonatomic, assign) BOOL isHost;

@end

@interface BogoCommodityDetailAttrModel : FDModel

//"sa_id": 45,//规格ID
//"uid": "100598",
//"gid": "20",//商品ID
//"name": "1束",//规格名称
//"price": 2500,//价格 分
//"stock": 999,//库存
//"sales": 0,//销量
//"status": 1,
//"addtime": 1562124426,
//"edittime": 1562140060,
//"sa_cid": "",
//"sa_order": 50,
//"type": 1

@property(nonatomic, copy) NSString *sa_id;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *gid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *stock;
@property(nonatomic, copy) NSString *sales;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *edittime;
@property(nonatomic, copy) NSString *sa_cid;
@property(nonatomic, copy) NSString *sa_order;
@property(nonatomic, copy) NSString *type;

@end

@interface BogoCommodityDetailModel : FDModel

//"gid": 商品ID,
//"uid": "用户ID",
//"sid": "店铺ID",
//"title": "商品名称",
//"stitle": "商品短标题",
//"cat_id": "行业ID",
//"type": 0,
//"icon":"图片",
//"images":"轮播图 , 隔开",
//"info": "简介",
//"info_images": "详情图, 隔开",
//"detail": "",
//"tag": "",
//"free_shipping": 邮费,
//"addtime": "2019-07-17 16:41:44",
//"edittime": 1563354759,
//"status": 1, 状态 1 审核通过 11上架 22 下架
//"remark": "",
//"sg_cid": "",
//"sg_order": 50,
//"link_url": "",
//"is_distribution": 0,
//"model_id": null,
//"attr": [//商品规格
//    -{
//
//    }
//]
//shop_info": {//店铺信息
//    "uid": "100598",
//    "title": "小店有请",//店铺ID
//    "logo"://店铺logo "http://douyin.qiniu.bugukj.com/image/k3tsmh74_3peab7loujne5de9fafa7716d.png"
//},
@property(nonatomic, copy) NSString *gid;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *stitle;
@property(nonatomic, copy) NSString *cat_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *images;
@property(nonatomic, copy) NSString *info;
@property(nonatomic, copy) NSString *info_images;
@property(nonatomic, copy) NSString *detail;
@property(nonatomic, copy) NSString *tag;
@property(nonatomic, copy) NSString *free_shipping;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *edittime;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *sg_cid;
@property(nonatomic, copy) NSString *sg_order;
@property(nonatomic, copy) NSString *link_url;
@property(nonatomic, copy) NSString *is_distribution;
@property(nonatomic, copy) NSString *model_id;
@property(nonatomic, strong) NSArray <BogoCommodityDetailAttrModel *> *attr;
@property(nonatomic, assign) NSInteger selectAttrIndex;
@property(nonatomic, strong) BogoCommodityDetailShopModel *shop_info;
@property(nonatomic, strong) BogoCommodityDetailShopModel *shop;
//"stock_total": 0,//剩余总库存
//"price":0,//价格
//"total_sales": 0,//总销量
//"month_sales": 0,//月销量

@property(nonatomic, copy) NSString *stock_total;
@property(nonatomic, copy) NSString *total_sales;
@property(nonatomic, copy) NSString *month_sales;
@property(nonatomic, copy) NSString *sales;

@property(nonatomic, assign) BOOL selected;
@property(nonatomic, assign) NSInteger count;

//金选商品
//"price": 696, 价格
//"countall": 99, 库存
//"order_count": 0 销量
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *countall;
@property(nonatomic, copy) NSString *order_count;


@property(nonatomic, strong) NSArray <BogoCommodityDetailModel *>*shop_goods_list;

//commission": 5,
//"deduct": 0,
//"is_platform": 1,//1分销商品

@property(nonatomic, copy) NSString *commission;
@property(nonatomic, copy) NSString *deduct;
@property(nonatomic, copy) NSString *is_platform;

//是否添加到直播间
@property(nonatomic, assign) int is_live_shop;

@property(nonatomic, assign) int is_live;//是否正在讲解

//is_favorite 1收藏
@property(nonatomic, copy) NSString *is_favorite;

//分销id
//distribution_uid
@property(nonatomic, copy) NSString *distribution_uid;

@property(nonatomic, strong) NSMutableArray *viewHeightArr;

//"is_seckill": 1,
//                "seckill_peice": 1000,
//                "seckill_time": 1626163200,
//                "seckill_stock": 800,
//                "seckill_status": 0,
//                "snapped_up": 0,

@property(nonatomic, copy) NSString *is_seckill;
@property(nonatomic, copy) NSString *seckill_peice;
@property(nonatomic, copy) NSString *seckill_time;
@property(nonatomic, copy) NSString *seckill_stock;

/// seckill_status    int    1即将开始 2已开抢 3抢购中 0未设置抢购时间
@property(nonatomic, copy) NSString *seckill_status;

/// snapped_up    int    已购百分比;20%就是20
@property(nonatomic, copy) NSString *snapped_up;


@property(nonatomic, copy) NSString *shop_title;

@property(nonatomic, copy) NSString *original_price;


@end

NS_ASSUME_NONNULL_END
