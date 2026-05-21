//
//  BogoAddressModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import <BRPickerView/BRAddressModel.h>
#import "FDFoundationObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoProvinceModel : BRProvinceModel

//"id": 2,
//"pid": 1,
//"name": "北京",
//"type": 1,
//"code": 100000,
//"p": 0

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *pid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *code;

@end

@interface BogoCityModel : BRCityModel

//"id": 2,
//"pid": 1,
//"name": "北京",
//"type": 1,
//"code": 100000,
//"p": 0

//@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *pid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *code;

@end

@interface BogoAreaModel : BRAreaModel

//"id": 2,
//"pid": 1,
//"name": "北京",
//"type": 1,
//"code": 100000,
//"p": 0

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *pid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *code;

@end

@interface BogoAddressModel : NSObject

@property(nonatomic, strong) NSArray *province_list;
@property(nonatomic, strong) NSArray *city_list;
@property(nonatomic, strong) NSArray *county_list;

@end

NS_ASSUME_NONNULL_END
