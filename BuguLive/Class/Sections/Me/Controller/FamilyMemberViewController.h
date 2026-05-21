//
//  FamilyMemberViewController.h
//  BuguLive
//
//  Created by 王珂 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyMemberViewController : BGBaseViewController

@property (nonatomic, assign) int isFamilyHeder;       //是否是公会族长 1为公会族长,0为公会成员
@property (nonatomic, copy) NSString * jid;            //公会ID

@end
