//
//  RoomFaceModel.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/27.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomFaceModel : NSObject

//"id":2,
//"img":"表情包地址",
//"name":"名称",
//"sort":0

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *name;



@end

NS_ASSUME_NONNULL_END
