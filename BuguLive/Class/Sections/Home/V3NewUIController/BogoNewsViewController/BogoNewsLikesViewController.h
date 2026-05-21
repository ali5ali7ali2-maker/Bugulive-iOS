//
//  BogoNewsLikesViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/7.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    BOGONEWS_TYPE_LIKES,    //点赞
    BOGONEWS_TYPE_COMMENT,  //评论
} BOGONEWS_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface BogoNewsLikesViewController : BGBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, assign) BOGONEWS_TYPE newType;

-(instancetype)initWithNewsType:(BOGONEWS_TYPE)newType;

@end

NS_ASSUME_NONNULL_END
