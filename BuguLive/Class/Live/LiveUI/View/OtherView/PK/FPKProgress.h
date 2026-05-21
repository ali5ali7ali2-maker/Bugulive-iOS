//
//  FPKProgress.h
//  FanweApp
//
//  Created by 志刚杨 on 2018/7/17.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoPkAudienceView.h"

#import "BogoPkProgressModel.h"

@interface FPKProgress : UIView
//左侧pk百分比
@property(nonatomic, assign) float leftValue;
@property(nonatomic, assign) float rightValue;
@property(nonatomic, assign) BOOL  leftIsMe;
//@property(nonatomic, assign) int countDown;

//pk对方id
@property(nonatomic, strong) NSString *otherId;
//对方主播头像地址
@property(nonatomic, strong) NSString *avatar;

@property(nonatomic, strong) BogoPkAudienceView *pkAudienceView;


@property(nonatomic, strong) BogoPkProgressModel *model;


@property(nonatomic, copy) NSString *room_id;


////2020-1-4 PK结束后
//@property (nonatomic,weak) UIView *showView;
//@property(nonatomic,strong) NSString *myavatar;
//@property(nonatomic,strong) NSString *myId;

//-(void)stopTimer;
- (void)switchToPunish:(int)time;

-(void)showPublishView;



@end
