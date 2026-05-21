//
//  BogoWardModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BogoWardPayTimeModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoWardModel : NSObject

@property(nonatomic, strong)NSArray<BogoWardPayTimeModel *> *guardian_pay;
@property(nonatomic, strong)NSArray<NSString *> *type_name;

@property(nonatomic, assign) BOOL isSelect;

@property(nonatomic, strong) NSString *img_bg;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *privilege;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *img_identification;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSString *name;

//@property(nonatomic, strong) NSString *guardian_pay;

//[0]    (null)    @"img_bg" : @""
//[1]    (null)    @"img" : @"http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/202109/30/14/61555c2012b40.png"
//[2]    (null)    @"privilege" : @"1,2,3"
//[3]    (null)    @"id" : @"1"
//[4]    (null)    @"img_identification" : @""
//[5]    (null)    @"addtime" : @"1632984097"
//[6]    (null)    @"sort" : @"20"
//[7]    (null)    @"type_name" : @"3 elements"
//[8]    (null)    @"guardian_pay" : @"2 elements"
//[9]    (null)    @"name" : @"白银"

@property(nonatomic, strong) NSString *select_icon;
@property(nonatomic, strong) NSString *default_icon;
@property(nonatomic, strong) NSString *centent;
@property(nonatomic, strong) NSString *type;
//id    String    1
//name    String    开通广播
//select_icon    String    http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/202109/24/14/614d7596dac2a.png
//default_icon    String    http://fw25live.oss-cn-beijing.aliyuncs.com/public/attachment/202109/24/16/614d93150b92b.png
//centent    String    开通广播
//sort    String    100
//type    String    1

@end

@interface BogoWardPayTimeModel : NSObject

@property(nonatomic, assign) BOOL isSelect;

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *day;
@property(nonatomic, strong) NSString *coin;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *classification_id;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *discount;


@end


NS_ASSUME_NONNULL_END
