//
//  BGReadPackListView.h
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPopView.h"
#import "BGRedPackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BGOpenRedPackView : FDPopView
@property(nonatomic, strong) NSString *video_id;
@property(nonatomic, strong) BGRedPackModel *userModel;
- (void)requestData;
@end

NS_ASSUME_NONNULL_END
