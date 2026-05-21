//
//  BogoShopTypeModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import <BRPickerView/BRResultModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoShopTypeModel : BRResultModel

//"sc_id": 16,//ID
//"title": "鲜花花束植物",//名称
//"icon": "",//图标
//"pid": "1",
//"info": "",
//"addtime": 1562119882,
//"edittime": 1562119882,
//"status": 1,

//@property(nonatomic, copy) NSString *sc_id;
//@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *pid;
@property(nonatomic, copy) NSString *info;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *edittime;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *value;


@end

NS_ASSUME_NONNULL_END
