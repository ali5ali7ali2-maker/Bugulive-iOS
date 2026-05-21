//
//  BogoInviteWithDrawResponseModel.h
//
//
//  Created by JSONConverter on 2021/10/09.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BogoInviteWithDrawResponseModelList;
@class BogoInviteWithDrawResponseModelData;

@interface BogoInviteWithDrawResponseModel: NSObject
@property (nonatomic, strong) BogoInviteWithDrawResponseModelData *data;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, strong) NSArray<BogoInviteWithDrawResponseModelList *> *list;
@property (nonatomic, assign) NSInteger status;
@end

@interface BogoInviteWithDrawResponseModelList: NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *invitation_coin;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger is_only;
@property (nonatomic, copy) NSString *sort;
@property(nonatomic, assign) BOOL selected;
@end

@interface BogoInviteWithDrawResponseModelData: NSObject
@property (nonatomic, copy) NSString *alipay_account;
@property (nonatomic, copy) NSString *alipay_name;
@property (nonatomic, copy) NSString *invite_coin;
@end
