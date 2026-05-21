//
//  BGReportController.h
//  BuguLive
//
//  Created by fanwe2014 on 2017/3/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGReportController : BGBaseViewController
@property (nonatomic,assign)int           reportType;                 //1举报动态 2举报用户
@property (nonatomic,copy)NSString        *weibo_id;                  //微博id
@property (nonatomic,copy)NSString        *to_user_id;                //被拉黑的会员ID
@property (nonatomic,copy)NSString        *commentID;                //被举报ID

@property (nonatomic,strong)UITableView   *reportTableView;

@end
