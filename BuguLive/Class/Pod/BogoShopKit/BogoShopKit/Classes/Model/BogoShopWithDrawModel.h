#import <Foundation/Foundation.h>

@class BogoShopWithDrawModelAccount;

@interface BogoShopWithDrawModel: NSObject
@property (nonatomic, strong) BogoShopWithDrawModelAccount *account;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *wid_money;
@property (nonatomic, copy) NSString *wid_num;
@end

@interface BogoShopWithDrawModelAccount: NSObject
@property (nonatomic, copy) NSString *account_number;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@end
