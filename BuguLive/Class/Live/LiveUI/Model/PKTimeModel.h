//
//  PKTimeModel.h
//  BuguLive
//
//  Created by 范东 on 2019/1/25.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKTimeModel : NSObject

//"id": "9",
//"time": "1",
//"sort": "0",
//"addtime": "1548135370"

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *addtime;

@end

NS_ASSUME_NONNULL_END
