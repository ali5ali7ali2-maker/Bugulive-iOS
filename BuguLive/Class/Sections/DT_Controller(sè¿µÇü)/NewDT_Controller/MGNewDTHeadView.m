//
//  MGNewDTHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/11/26.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGNewDTHeadView.h"


@implementation MGNewDTHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
//    self.firstView = [self addViewWithTitleScrollView];
    self.topicView = [self setUpTopicView];
    self.topicView.top = 0;
//    self.firstView.bottom;
    
//    [self addSubview:self.firstView];
    [self addSubview:self.topicView];
    self.backgroundColor = kWhiteColor;
}


-(UIView *)addViewWithTitleScrollView{
   
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(90))];
    CGFloat viewWidth = kRealValue(184);
    
    for (int i = 0 ; i < 2; i ++) {
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(kRealValue(4) + i * viewWidth , kRealValue(4), viewWidth, kRealValue(79))];
        control.tag = 10 + i;
        [control addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:control.bounds];
        
        UILabel *titleL = [UILabel new];
        UILabel *subTitleL = [UILabel new];
        titleL.text = i == 0 ? ASLocalizedString(@"直播"): ASLocalizedString(@"短视频");
        titleL.textColor = [UIColor colorWithHexString:@"#333333"];
        titleL.font = [FontHelper fontWithSize:16];
        titleL.frame = CGRectMake(kRealValue(15), kRealValue(15), viewWidth, kRealValue(22));
        
        subTitleL.text = i == 0 ? ASLocalizedString(@"美女live"): ASLocalizedString(@"美女live");
        subTitleL.textColor = [UIColor colorWithHexString:@"#666666"];
        subTitleL.font = [FontHelper fontWithSize:13];
        subTitleL.frame = CGRectMake(titleL.left, titleL.bottom + kRealValue(5), kRealValue(60), kRealValue(20));
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(control.width / 2 + kRealValue(10), control.height / 2, kRealValue(42), kRealValue(37))];
        if (i == 0) {
            [bgImgView setImage:[UIImage imageNamed:@"dy_head_live_BGImg"]];
            imgView.image = [UIImage imageNamed:@"dy_head_live_img"];
        }else{
            [bgImgView setImage:[UIImage imageNamed:@"dy_head_short_BGImg"]];
            imgView.image = [UIImage imageNamed:@"dy_head_short_img"];
            imgView.width = kRealValue(40);
            imgView.height = kRealValue(40);
        }
        imgView.centerY = control.height / 2;
        
        [control addSubview:bgImgView];
        [control addSubview:titleL];
        [control addSubview:subTitleL];
        [control addSubview:imgView];
        [firstView addSubview:control];
    }
    return firstView;
}

-(UIView *)setUpTopicView{
    
    UIView *topicView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(160))];
    
//    UILabel *topicL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), kRealValue(13), kRealValue(50), kRealValue(20))];
//    topicL.text = ASLocalizedString(@"话题");
//    topicL.font = [UIFont systemFontOfSize:17];
//    topicL.textColor = kBlackColor;
//
//    UIButton *topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    topicBtn.frame = CGRectMake(kScreenW - kRealValue(80) - kRealValue(5), 0, kRealValue(80), kRealValue(20));
//    topicBtn.centerY = topicL.centerY;
//    topicBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    topicBtn.tag = 1000;
//    [topicBtn setTitle:ASLocalizedString(@"全部话题")forState:UIControlStateNormal];
//    [topicBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
//    [topicBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    topicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    CGFloat viewWidth = kRealValue(116);
    CGFloat viewHeight = kRealValue(116);
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(kRealValue(4), kRealValue(10), kScreenW - kRealValue(4 * 2), viewHeight + kRealValue(10));
    scrollView.contentSize = CGSizeMake(viewWidth * 4 + kRealValue(15 * 3), 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    
//    [topicView addSubview:topicL];
//    [topicView addSubview:topicBtn];
    [topicView addSubview:scrollView];
    
    for (int i = 0 ; i < 4; i ++) {
        MGNewDTHeadControl *control = [[MGNewDTHeadControl alloc]initWithFrame:CGRectMake(kRealValue(4) + i * (viewWidth + kRealValue(10)) ,0, viewWidth, viewHeight)];
        control.tag = 100 + i;
        control.layer.masksToBounds = YES;
        control.layer.cornerRadius = 4;
        [scrollView addSubview:control];
    }
    
    return topicView;
}

-(void)clickBtn:(UIButton *)sender{
    if (sender.tag == 10) {//点击直播
        [AppDelegate sharedAppDelegate].topViewController.tabBarController.selectedIndex = 0;
    }else if (sender.tag == 11) {//点击短视频
        [AppDelegate sharedAppDelegate].topViewController.tabBarController.selectedIndex = 2;
    }else if (sender.tag == 1000) {//全部话题
        if (self.MGNewDTHeadViewTopicBlock) {
            self.MGNewDTHeadViewTopicBlock(sender.tag);
        }
    }else if (sender.tag == 10) {
        
    }else if (sender.tag == 10) {
        
    }else{
        
    }
}

-(void)resetTopicModel:(NSArray *)arr{
    self.topicArr = [NSMutableArray arrayWithArray:arr];
    for (int i = 0; i < 4; i ++) {
        if (i > 4) return;
        MGNewDTHeadControl *control = [self.topicView viewWithTag:100 + i];

        if(arr.count > i)
        {
            [control resetControlModel:arr[i]];
            //给有数据的view添加手势
            [control addTarget:self action:@selector(MGNewDTHeadAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)MGNewDTHeadAction:(UIControl *)sender{
    if (self.MGNewDTHeadViewTopicBlock) {
        self.MGNewDTHeadViewTopicBlock(sender.tag-100);
    }
}

-(UIScrollView *)titleScroll{
    if (!_titleScroll) {
        _titleScroll = [UIScrollView new];
        
    }
    return _titleScroll;
}

@end

@implementation MGNewDTHeadControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViewWithFrame:frame];
        _timeL.hidden = YES;
    }
    return self;
}

-(void)resetControlModel:(MGDynamicTopicModel *)model{
    [_topicTitleBtn setTitle:[NSString stringWithFormat:@"  %@  ",model.name] forState:UIControlStateNormal];
    _topicTitleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _timeL.text = [NSString stringWithFormat:ASLocalizedString(@"%@人参与了该话题"),model.num];
    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
}

-(void)setUpViewWithFrame:(CGRect)frame{
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bgImgView.image = [UIImage imageNamed:@"dy_head_topic_BGImg"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgView = bgImgView;
    
    QMUIButton *topicTitleBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    [topicTitleBtn setImage:[UIImage imageNamed:@"dy_head_topic"] forState:UIControlStateNormal];
//    topicTitleBtn.imagePosition = QMUIButtonImagePositionLeft;
//    topicTitleBtn.spacingBetweenImageAndTitle = 2;
    topicTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [topicTitleBtn setTitle:ASLocalizedString(@"#大约在冬季#")forState:UIControlStateNormal];
    topicTitleBtn.userInteractionEnabled = NO;
    [topicTitleBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    topicTitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    topicTitleBtn.backgroundColor = kWhiteColor;
    _topicTitleBtn = topicTitleBtn;
    
    UILabel *timeL = [UILabel new];
    timeL.text = ASLocalizedString(@"今日更新");
    timeL.font = [UIFont systemFontOfSize:12];
    timeL.textColor = kWhiteColor;
    _timeL = timeL;

    topicTitleBtn.frame = CGRectMake(kRealValue(5), self.height - kRealValue(5 + 20),bgImgView.width - kRealValue(10) * 2, kRealValue(20));
    topicTitleBtn.layer.cornerRadius = kRealValue(20 / 2);
    topicTitleBtn.layer.masksToBounds = YES;
    timeL.frame = CGRectMake(topicTitleBtn.left, topicTitleBtn.bottom + kRealValue(5), bgImgView.width - kRealValue(10) * 2, kRealValue(20));
    
    [self addSubview:bgImgView];
    [self addSubview:topicTitleBtn];
    [self addSubview:timeL];

}

@end


