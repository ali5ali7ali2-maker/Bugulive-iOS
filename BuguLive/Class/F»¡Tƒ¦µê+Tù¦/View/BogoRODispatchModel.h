//
//  BogoRODispatchModel.h
//  UniversalApp
//
//  Created by bugu on 2021/12/7.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoRODispatchModel : NSObject

@property(nonatomic, strong) NSString *id;

@property (nonatomic,copy) NSString *user_id;/**<*/
@property (nonatomic,copy) NSString *voice_id;/**<*/
@property (nonatomic,copy) NSString *game_id;/**<*/
@property (nonatomic,copy) NSString *sex;/**<*/
@property (nonatomic,copy) NSString *min_price;/**<*/
@property (nonatomic,copy) NSString *max_price;/**<*/
@property (nonatomic,copy) NSString *create_time;/**<*/
@property (nonatomic,copy) NSString *remark;/**<*/
@property (nonatomic,copy) NSString *game_name;/**<*/
@property (nonatomic,copy) NSString *duration_time;/**<*/
@property (nonatomic,copy) NSString *status;/**<1 添加编辑   2重置*/

@property (nonatomic,copy) NSString *img;/**<*/
@property (nonatomic,copy) NSString *name;/**<*/
//@property (nonatomic,copy) NSString *status;/**<1派单中 2结束*/


@end

NS_ASSUME_NONNULL_END
