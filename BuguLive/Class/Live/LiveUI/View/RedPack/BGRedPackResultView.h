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

@interface BGRedPackResultView : FDPopView
@property(nonatomic, strong) NSString *diamonds;
@property(nonatomic, strong) BGRedPackModel *model;
- (void)requestData;
@end

NS_ASSUME_NONNULL_END
