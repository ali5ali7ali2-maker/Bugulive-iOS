//
//  BogoOrderManageListModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "BogoOrderManageListModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoOrderManageListRefundModel

@end

@implementation BogoOrderManageListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"refund_data":@"BogoOrderManageListRefundModel"};
}

@end
