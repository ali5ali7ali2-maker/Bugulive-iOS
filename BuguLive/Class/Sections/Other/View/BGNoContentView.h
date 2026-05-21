//
//  BGNoContentView.h
//  BuguLive
//
//  Created by xfg on 2017/8/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseView.h"

@interface BGNoContentView : BGBaseView

/**
 无内容提示，开放出来灵活改动
 */
@property (weak, nonatomic) IBOutlet UILabel *noContentTipLabel;

+ (instancetype)noContentWithFrame:(CGRect)frame;

@end
