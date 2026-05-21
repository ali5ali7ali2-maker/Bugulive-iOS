//
//  DetailsLineViewController.h
//  MarryU
//
//  Created by 志刚杨 on 2017/6/26.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YHWorkGroup.h"

#import "MGGroupUserInfo.h"

@interface DetailsLineViewController : UIViewController

@property(nonatomic, strong) MGGroupUserInfo *model;
@property(nonatomic, assign) NSInteger topic;
@property(nonatomic, copy) void (^refreshData)(void);


@property(nonatomic, strong) NSString *dynamic_id;

@end
