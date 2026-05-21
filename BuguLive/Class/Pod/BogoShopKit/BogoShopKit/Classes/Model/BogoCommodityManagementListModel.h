//
//  BogoCommodityManagementListModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoCommodityManagementListModel : FDModel

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
//"price": 696, 价格
//"countall": 99, 库存
//"order_count": 0 销量

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
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *countall;
@property(nonatomic, copy) NSString *order_count;

@property(nonatomic, copy) NSString *is_platform;
@property(nonatomic, copy) NSString *stock_total;

@end

NS_ASSUME_NONNULL_END
