//
//  BogoNobleListModel.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNobleListModel.h"

@implementation BogoNobleListModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":@"BogoNobleListTypeModel"};
}

@end

@implementation BogoNobleRechargeModel



@end



@implementation BogoNobleUserInfoModel




@end

@implementation BogoNobleListTypeModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"noble_type":@"BogoNobleListSubTypeModel"};
}



@end

@implementation BogoNobleListSubTypeModel



@end

