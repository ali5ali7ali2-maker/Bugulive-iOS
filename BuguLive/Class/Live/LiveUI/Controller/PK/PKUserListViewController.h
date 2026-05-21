//
//  PKUserListViewController.h
//  FanweApp
//
//  Created by 志刚杨 on 2018/7/18.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

@protocol PKUserListViewDelegate <NSObject>
-(void)PKUserClickItem:(UserModel *)user pk_id:(NSString *)pk_id;
-(void)closeUserListView;
@optional

@end

@interface PKUserListViewController : BGBaseViewController

@property(nonatomic, assign) id<PKUserListViewDelegate> pDelegate;

-(void)reloadData;

@end
