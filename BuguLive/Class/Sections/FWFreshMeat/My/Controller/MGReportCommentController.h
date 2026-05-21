//
//  MGReportCommentController.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/1/15.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BGBaseViewController.h"
#import "reportModel.h"
#import "XWPublishBaseController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MGReportCommentController : XWPublishBaseController

-(instancetype)initWithReportModel:(reportModel *)reportModel;

@property(nonatomic, strong) reportModel *model;

@end

NS_ASSUME_NONNULL_END
