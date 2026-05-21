//
//  PublishLiveShareView.h
//  BuguLive
//
//  Created by xgh on 2017/8/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface PublishLiveShareView : UIView
{
    UIButton                    *weiboButton;
    UIButton                    *wechatButton;
    UIButton                    *qqButton;
    UIButton                    *friendButton;
    UIButton                    *qzoreButton;
    CGFloat                      start_x;
}
@property (nonatomic, copy)NSString *shareStr;

@property (nonatomic, strong)GlobalVariables *BuguLive;

@property (nonatomic, strong)NSMutableArray *shareImgViewArray;

@property (nonatomic, strong)UIButton *selectedBtn;
@end
