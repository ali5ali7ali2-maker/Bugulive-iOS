//
//  BogoCartModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoCartModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoCartListModel

@end

@implementation BogoCartModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"cart_list":@"BogoCartListModel"};
}

@end
