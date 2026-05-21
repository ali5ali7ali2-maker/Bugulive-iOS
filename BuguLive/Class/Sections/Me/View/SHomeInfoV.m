//
//  SHomeInfoV.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SHomeInfoV.h"

@implementation SHomeInfoV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
    }
    return self;
}

- (void)setViewWithArray:(NSArray *)otherArray andMDict:(NSMutableDictionary *)Mdict
{
    
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    @autoreleasepool
    {
        CGFloat viewHeight = 30;
        for (int i = 0; i < otherArray.count; i ++)
        {
            UIView *whiteBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight*i, kScreenW, viewHeight)];
            whiteBottomView.backgroundColor = kWhiteColor;
            [self addSubview:whiteBottomView];
            
            NSDictionary *dict = otherArray[i];
            NSString *keyString = dict.allKeys.firstObject;
            NSString *valueString = dict.allValues.firstObject;
            UILabel *keyKabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW - 10, viewHeight)];
            keyKabel.backgroundColor = [UIColor clearColor];
            keyKabel.text = [NSString stringWithFormat:@"%@:%@",keyString,valueString];
            keyKabel.textColor = [UIColor colorWithHexString:@"#666666"];
            keyKabel.textAlignment = NSTextAlignmentLeft;
            keyKabel.font = [UIFont systemFontOfSize:13];
            [whiteBottomView addSubview:keyKabel];
            
//            UILabel *valueKabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW*0.3+10, 0, kScreenW*0.7-20, 30)];
//            valueKabel.backgroundColor = [UIColor clearColor];
//            valueKabel.text = [NSString stringWithFormat:@"%@",valueString];
//            valueKabel.textColor = kAppGrayColor4;
//            valueKabel.textAlignment = NSTextAlignmentRight;
//            valueKabel.font = [UIFont systemFontOfSize:13];
//            [whiteBottomView addSubview:valueKabel];
            
            if (i < otherArray.count-1)
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, viewHeight, kScreenW-10, 1)];
                lineView.backgroundColor = kAppSpaceColor4;
                [whiteBottomView addSubview:lineView];
            }
        }
    }
}
@end
