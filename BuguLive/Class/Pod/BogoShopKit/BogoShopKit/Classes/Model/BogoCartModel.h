//
//  BogoCartModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoCartListModel : FDModel

//        "id": 2,
//        "uid": 101492,
//        "sid": 34,
//        "gid": 92,
//        "num": 2,
//        "sa_id": 130,
//        "price": 33,
//        "addtime": 1584762826,
//        "title": "QQ",
//        "goods_icon": "http://douyin.qiniu.bugukj.com//photo/1584500909360_headImage.jpg",
//        "name": "巴黎"

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *gid;
@property(nonatomic, assign) NSInteger num;
@property(nonatomic, copy) NSString *sa_id;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *goods_icon;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *stock;
@property(nonatomic, copy) NSString *free_shipping;
@property(nonatomic, assign) BOOL selected;
//"distribution_uid": 0,
//"share_uid": 0,
@property(nonatomic, copy) NSString *distribution_uid;
@property(nonatomic, copy) NSString *share_uid;
@property(nonatomic, copy) NSString *model_id;
@property(nonatomic, copy) NSString *link_url;
@end

//sid": 34,
//"title": "快乐大本营",
//-"cart_list": [
//        -{
//
//        }
//    ]
//}

@interface BogoCartModel : FDModel

@property(nonatomic, copy) NSString *sid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSMutableArray<BogoCartListModel *> *cart_list;
@property(nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
