//
//  BogoAddressWebModel.h
//  BogoShopKit
//
//  Created by bogokj on 2020/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoAddressWebModel : NSObject

//{
//    address = "\U6cf0\U5c71\U5927\U8857335\U9644\U8fd1";
//    location = "117.089083,36.184881";
//    name = "\U6cf0\U5b89\U4f20\U5a92\U5e7f\U573a\U8425\U9500\U4e2d\U5fc3";
//}

@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
