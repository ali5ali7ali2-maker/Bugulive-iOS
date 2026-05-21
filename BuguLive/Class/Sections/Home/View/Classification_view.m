//
//  Classification_view.m
//  iphoneLive
//
//  Created by bugu on 2018/12/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "Classification_view.h"
#import "UIView+Additions.h"

@implementation Classification_view

- (instancetype)init
{
    self =[super init];
    self.backgroundColor =UIColorFromRGB(0xffffff);
    return self;
}
- (UIScrollView *)scrollview
{
    if (!_scrollview)
    {
        _scrollview =[[UIScrollView alloc]init];
        [self addSubview:_scrollview];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.right.equalTo(self);
//            make.width.equalTo(self).offset(-44);
        }];
        _scrollview.showsHorizontalScrollIndicator = NO;
//        UIButton *allBtn =[[UIButton alloc]init];
//        [self addSubview:allBtn];
//        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.top.height.equalTo(self);
//            make.width.equalTo(@44);
//        }];
//        [allBtn setImage:[UIImage imageNamed:@"hm_img_hot_class"] forState:0];
//        [allBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
//        allBtn.hidden = YES;
//        UIView *fg =[[UIView alloc]init];
//        fg.backgroundColor =UIColorFromRGB(0xf5f5f5);
//        [self addSubview:fg];
//        [fg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(allBtn.mas_left);
//            make.width.equalTo(@1);
//            make.height.equalTo(@25);
//            make.centerY.equalTo(self);
//        }];
    }
    return _scrollview;
}
- (void)allAction
{
    if ([_delegate respondsToSelector:@selector(showAllClass)])
    {
        [_delegate showAllClass];
    }
}
- (void)setClassWithAry:(NSArray *)ary
{
    [self.scrollview removeAllSubViews];
    _data_ary =[ary copy];
    CGFloat item_w =10,item_h =25;
    for (int i=0; i<ary.count; i++)
    {
        UIButton *item =[[UIButton alloc]init];
        [self.scrollview addSubview:item];
        NSString *title =ary[i];
        UIFont *font =[UIFont systemFontOfSize:13.];
        CGFloat need_w =[Classification_view backWidthWithNeiRong:title andFont:font];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollview).offset(item_w);
            make.height.equalTo(@(item_h));
            make.centerY.equalTo(self.scrollview);
            make.width.equalTo(@(need_w+20));
        }];
        item_w +=need_w +20;
        [item setTitle:title forState:0];
        item.titleLabel.font =font;
        if (i == 0)
        {
            item.tag =i;
        }else
        {
            item.tag =1;
        }
        item.layer.cornerRadius =item_h/2;
        [self drawWithBtn:item];
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self layoutIfNeeded];
    self.scrollview.contentSize =CGSizeMake(item_w,self.scrollview.bounds.size.height);
}
- (void)selectWithIndex:(NSInteger)index
{
    for (id obj in self.scrollview.subviews)
    {
        NSInteger _index =[self.scrollview.subviews indexOfObject:obj];
        if ([obj isKindOfClass:[UIButton class]]&&index == _index)
        {
            UIButton *item_btn =(UIButton *)obj;
            [self itemAction:item_btn];
            [self.scrollview scrollRectToVisible:item_btn.frame animated:YES];
        }
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
                if ([_delegate respondsToSelector:@selector(didSelectWith:andxiabiao:)])
                {
                    NSInteger index =[self.scrollview.subviews indexOfObject:obj];
                    [_delegate didSelectWith:_data_ary[index] andxiabiao:index];
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
        [btn setTitleColor:Main_textColor forState:0];
//        btn.backgroundColor =[UIColor colorWithRed:126.0/255.0 green:55.0/255.0 blue:251.0/255.0 alpha:.1];
//         btn.backgroundColor =UIColorFromRGB(0xffffff);
    }else
    {
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:0];
//        btn.backgroundColor =UIColorFromRGB(0xffffff);
    }
}
+ (CGFloat)backWidthWithNeiRong:(NSString *)msg andFont:(UIFont *)font
{
    NSDictionary *dic = @{NSFontAttributeName:font};//指定字号
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
