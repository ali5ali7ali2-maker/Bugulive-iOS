//
//  RoomBGImageModel.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/14.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomBGImageModel : NSObject

//id':'背景图id',
//'image':'图片地址',
//'preview':'预览图片',
//'sort':'排序',
//'status':'状态',

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *preview;
@property(nonatomic, copy) NSString *sort;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
