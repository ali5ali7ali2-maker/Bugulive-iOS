//
//  HallTypeModel.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/6.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HallTypeModel : NSObject

//"id":'分类id',
//"name":"分类名称"

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *name;

@property(nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
