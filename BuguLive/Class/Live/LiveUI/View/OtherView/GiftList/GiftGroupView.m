//
//  GiftGroupView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "GiftGroupView.h"

#define kGiftGroupViewButtonBaseTag 100

@interface GiftGroupView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) clickGiftGroupBtnBlock clickGiftGroupBtnBlock;

@end

@implementation GiftGroupView

- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kClearColor;
//        [RGB(21, 6, 36) colorWithAlphaComponent:0.1];
        self.titleArray = titleArray;
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    [self addSubview:self.scrollView];
    //    CGSize titleSize = [ASLocalizedString(@"测试")textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
    
    int buttonWidth = kScreenW - 80;

    
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        //礼物分组
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * buttonWidth / self.titleArray.count, 0, buttonWidth / self.titleArray.count, kRealValue(53))];
        button.tag = kGiftGroupViewButtonBaseTag + i;
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:RGBA(255, 255, 255, 0.8) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#C28CF8"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    for (NSInteger i =1 ; i < self.titleArray.count; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i*(buttonWidth) - 0.5, 0, 0.5, self.height)];
        lineView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.1];
        lineView.hidden = YES;
        [self.scrollView addSubview:lineView];
    }
    self.scrollView.contentSize = CGSizeMake(self.titleArray.count * self.width / 2, 0);
    
    UIButton *selectedBtn = (UIButton *)[self viewWithTag:kGiftGroupViewButtonBaseTag];
    selectedBtn.selected = YES;
}



- (void)onClick:(UIButton *)sender{
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isMemberOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            button.selected = (button == sender);
        }
    }
    if (self.clickGiftGroupBtnBlock) {
        self.clickGiftGroupBtnBlock(sender.tag - kGiftGroupViewButtonBaseTag);
    }
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(void)resetIndexs:(NSInteger)index{
    UIButton *sender = [self.scrollView viewWithTag:kGiftGroupViewButtonBaseTag + index];
   for (UIView *subView in self.scrollView.subviews) {
       if ([subView isMemberOfClass:[UIButton class]]) {
           UIButton *button = (UIButton *)subView;
           button.selected = (button == sender);
       }
   }
    
}

//- (void)setIndex:(NSInteger)index{
//
//}

- (void)setClickGiftGroupBtnBlock:(clickGiftGroupBtnBlock)clickGiftGroupBtnBlock{
    _clickGiftGroupBtnBlock = clickGiftGroupBtnBlock;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
