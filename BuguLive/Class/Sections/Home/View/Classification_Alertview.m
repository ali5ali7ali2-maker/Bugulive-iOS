//
//  Classification_Alertview.m
//  iphoneLive
//
//  Created by bugu on 2018/12/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UIView+Additions.h"
#import "Classification_Alertview.h"
#import "Classification_view.h"
#define scrollview_maxH 350
@implementation Classification_Alertview
- (instancetype)init
{
    self =[super init];
    return self;
}
- (void)setClassWithAry:(NSArray *)ary
{
    [self.scrollview removeAllSubViews];
    CGFloat item_h =35,item_w =0,item_y =10,scroll_maxW =kScreenW*0.8,item_wJiange =10;
    for (int i =0; i<ary.count; i++)
    {
        UIButton *item =[[UIButton alloc]init];
        [self.scrollview addSubview:item];
        NSString *title =ary[i];
        UIFont *font =[UIFont systemFontOfSize:13.];
        CGFloat need_w =[Classification_view backWidthWithNeiRong:title andFont:font];
        if ((item_w +need_w +20 +item_wJiange) >scroll_maxW)
        {
            item_w =0;
            item_y +=(item_h +10);
            item_wJiange =10;
        }
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollview).offset(item_w+item_wJiange);
            make.height.equalTo(@(item_h));
            make.top.equalTo(self.scrollview).offset(46/*头部标签高度*/+item_y);
            make.width.equalTo(@(need_w+20));
        }];
        item.tag =1;
        item_w +=need_w +20;
        item_wJiange +=10;
        [item setTitle:title forState:0];
        item.titleLabel.font =font;
        item.layer.cornerRadius =item_h/2;
        [self drawWithBtn:item];
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)itemAction:(UIButton *)btn
{
    for (id obj in self.scrollview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *item_btn =(UIButton *)obj;
            if (item_btn == btn)
            {
                item_btn.tag =0;
                if ([_delegate respondsToSelector:@selector(didSelectWithAlert:)])
                {
                    NSInteger index =[self.scrollview.subviews indexOfObject:obj];
                    [_delegate didSelectWithAlert:@(index)];
                }
            }else
            {
                item_btn.tag =1;
            }
            [self drawWithBtn:item_btn];
        }
    }
}
//button样式
- (void)drawWithBtn:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:0];
        btn.backgroundColor =[UIColor colorWithRed:126.0/255.0 green:55.0/255.0 blue:251.0/255.0 alpha:1];
    }else
    {
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        btn.backgroundColor =UIColorFromRGB(0xf5f5f5);
    }
}
-(void)selectWithIndex:(NSInteger)index
{
    for (id obj in self.scrollview.subviews)
    {
        NSInteger _index =[self.scrollview.subviews indexOfObject:obj];
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *item =(UIButton *)obj;
            if (_index == index)
            {
                item.tag =0;
            }else
            {
                item.tag =1;
            }
            [self drawWithBtn:item];
        }
    }
}
- (UIScrollView *)scrollview
{
    if (!_scrollview)
    {
        _scrollview =[[UIScrollView alloc]init];
        [self addSubview:_scrollview];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.width.equalTo(self).multipliedBy(0.8);
            make.height.equalTo(@(scrollview_maxH));
        }];
        _scrollview.backgroundColor =UIColorFromRGB(0xffffff);
        _scrollview.layer.cornerRadius =8.;
        _scrollview.layer.masksToBounds =YES;
        _scrollview.showsHorizontalScrollIndicator = NO;
        UILabel *titleLabel =[[UILabel alloc]init];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.scrollview);
            make.width.equalTo(self.scrollview);
            make.height.equalTo(@45);
        }];
        titleLabel.textColor =UIColorFromRGB(0x333333);
        titleLabel.font =[UIFont systemFontOfSize:15.];
        titleLabel.textAlignment =1;
        titleLabel.text =ASLocalizedString(@"选择标签");
        UIView *fg =[[UIView alloc]init];
        [self addSubview:fg];
        [fg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollview).offset(45);
            make.width.equalTo(self.scrollview).multipliedBy(0.95);
            make.height.equalTo(@.8);
            make.centerX.equalTo(_scrollview);
        }];
        fg.backgroundColor =UIColorFromRGB(0xe5e5e5);
    }
    return _scrollview;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
