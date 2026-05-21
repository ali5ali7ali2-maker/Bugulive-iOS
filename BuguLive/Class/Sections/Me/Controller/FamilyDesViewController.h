//
//  FamilyDesViewController.h
//  BuguLive
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyListModel;

@interface FamilyDesViewController : BGBaseViewController

@property (nonatomic, assign) int isFamilyHeder;       //是否是公会族长 //1是公会族长，0是公会成员,2是陌生人
@property (nonatomic, copy) NSString * jid;            //公会ID
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * is_apply;       //是否已经提交申请
@property(nonatomic, strong) FamilyListModel * listModel; //公会列表中的公会信息

@end
