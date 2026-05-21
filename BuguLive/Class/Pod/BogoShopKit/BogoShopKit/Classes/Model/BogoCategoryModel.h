//
//  BogoCategoryModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/15.
//

#import <BRPickerView/BRResultModel.h>
@class BogoCategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoCategoryModel : BRResultModel

//-{
//"sc_id": 16,
//"title": "鲜花花束植物",
//"icon": "",
//"pid": "1",
//"info": "",
//"addtime": 1562119882,
//"edittime": 1562119882,
//"status": 1,
//"sc_cid": "",
//"sc_order": 50,
//"banner": 50,
//"children": [
//    -{
//        "sc_id": 17,
//        "title": "玫瑰花",
//        "icon": "http://douyin.qiniu.bugukj.com/image/k90p2yzk_5hdx59ngudlw5e966c64b0322.png",
//        "pid": "16",
//        "info": "",
//        "addtime": 1586916429,
//        "edittime": 1586916429,
//        "status": 1,
//        "sc_cid": "",
//        "sc_order": 50
//    },

@property(nonatomic, copy) NSString *sc_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *banner;
@property(nonatomic, copy) NSString *pid;
@property(nonatomic, copy) NSString *info;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *edittime;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *sc_cid;
@property(nonatomic, copy) NSString *sc_order;
@property(nonatomic, strong) NSArray <BogoCategoryModel *>*children;
@property(nonatomic, assign) NSInteger selected;

@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *value;

@property (nullable, nonatomic, copy) NSString *parentKey;
/** 父级value */
@property (nullable, nonatomic, copy) NSString *parentValue;

@end

NS_ASSUME_NONNULL_END
