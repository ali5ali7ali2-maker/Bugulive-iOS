//
//  BogoCommodityDetailModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "BogoCommodityDetailModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoCommodityDetailModel

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super init]) {
//        if (aDecoder) {
//            _uid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"uid"];
//            _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
//            _gid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"gid"];
//            _sid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sid"];
//            _stitle = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"stitle"];
//            _cat_id = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"cat_id"];
//            _type = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"type"];
//            _icon = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"icon"];
//            _images = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"images"];
//            _info = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"info"];
//            _info_images = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"info_images"];
//            _detail = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"detail"];
//            _tag = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"tag"];
//            _free_shipping = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"free_shipping"];
//            _addtime = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"addtime"];
//            _edittime = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"edittime"];
//            _status = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"status"];
//            _remark = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"remark"];
//            _sg_cid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sg_cid"];
//            _sg_order = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sg_order"];
//            _link_url = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"link_url"];
//            _is_distribution = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"is_distribution"];
//            _model_id = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"model_id"];
//            _attr = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"attr"];
//        }
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:_uid forKey:@"uid"];
//    [aCoder encodeObject:_title forKey:@"title"];
//    [aCoder encodeObject:_gid forKey:@"gid"];
//    [aCoder encodeObject:_sid forKey:@"sid"];
//    [aCoder encodeObject:_stitle forKey:@"stitle"];
//    [aCoder encodeObject:_cat_id forKey:@"cat_id"];
//    [aCoder encodeObject:_type forKey:@"type"];
//    [aCoder encodeObject:_icon forKey:@"icon"];
//    [aCoder encodeObject:_images forKey:@"images"];
//    [aCoder encodeObject:_info forKey:@"info"];
//    [aCoder encodeObject:_info_images forKey:@"info_images"];
//    [aCoder encodeObject:_detail forKey:@"detail"];
//    [aCoder encodeObject:_tag forKey:@"tag"];
//    [aCoder encodeObject:_free_shipping forKey:@"free_shipping"];
//    [aCoder encodeObject:_addtime forKey:@"addtime"];
//    [aCoder encodeObject:_edittime forKey:@"edittime"];
//    [aCoder encodeObject:_status forKey:@"status"];
//    [aCoder encodeObject:_remark forKey:@"remark"];
//    [aCoder encodeObject:_sg_cid forKey:@"sg_cid"];
//    [aCoder encodeObject:_sg_order forKey:@"sg_order"];
//    [aCoder encodeObject:_link_url forKey:@"link_url"];
//    [aCoder encodeObject:_is_distribution forKey:@"is_distribution"];
//    [aCoder encodeObject:_model_id forKey:@"model_id"];
//    [aCoder encodeObject:_attr forKey:@"attr"];
//}
//
//+ (BOOL)supportsSecureCoding {
//    return YES; //支持加密编码
//}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"attr":@"BogoCommodityDetailAttrModel",@"shop_goods_list":@"BogoCommodityDetailModel"};
}

@end

@implementation BogoCommodityDetailAttrModel

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super init]) {
//        if (aDecoder) {
//            _sa_id = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sa_id"];
//            _uid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"uid"];
//            _gid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"gid"];
//            _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
//            _price = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"price"];
//            _stock = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"stock"];
//            _sales = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sales"];
//            _status = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"status"];
//            _addtime = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"addtime"];
//            _edittime = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"edittime"];
//            _sa_cid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sa_cid"];
//            _sa_order = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"sa_order"];
//            _type = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"type"];
//        }
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:_sa_id forKey:@"sa_id"];
//    [aCoder encodeObject:_uid forKey:@"uid"];
//    [aCoder encodeObject:_gid forKey:@"gid"];
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeObject:_price forKey:@"price"];
//    [aCoder encodeObject:_stock forKey:@"stock"];
//    [aCoder encodeObject:_sales forKey:@"sales"];
//    [aCoder encodeObject:_status forKey:@"status"];
//    [aCoder encodeObject:_addtime forKey:@"addtime"];
//    [aCoder encodeObject:_edittime forKey:@"edittime"];
//    [aCoder encodeObject:_sa_cid forKey:@"sa_cid"];
//    [aCoder encodeObject:_sa_order forKey:@"sa_order"];
//    [aCoder encodeObject:_type forKey:@"type"];
//}
//
//+ (BOOL)supportsSecureCoding {
//    return YES; //支持加密编码
//}

@end

@implementation BogoCommodityDetailShopModel

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super init]) {
//        if (aDecoder) {
//            _uid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"uid"];
//            _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
//            _logo = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"logo"];
//        }
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:_uid forKey:@"uid"];
//    [aCoder encodeObject:_title forKey:@"title"];
//    [aCoder encodeObject:_logo forKey:@"logo"];
//}
//
//+ (BOOL)supportsSecureCoding {
//    return YES; //支持加密编码
//}

@end
