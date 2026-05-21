//
//  MGNewDTNavView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/11/26.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGNewDTNavView.h"

@implementation MGNewDTNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}



-(void)setUpView{
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(175))];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.image = [UIImage imageNamed:@"mg_hm_topBgImgView"];
    [self addSubview:bgImgView];
    
    _chatBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    _chatBtn.frame = CGRectMake(kRealValue(10), MG_TOP_MARGIN + kRealValue(10), kRealValue(22), kRealValue(22));
    [_chatBtn setImage:[UIImage imageNamed:@"dy_msg"] forState:UIControlStateNormal];
    [_chatBtn addTarget:self action:@selector(handleMsgEvent) forControlEvents:UIControlEventTouchUpInside];
    
    self.jsbadge = [[JSBadgeView alloc]initWithParentView:_chatBtn alignment:JSBadgeViewAlignmentTopRight];

    
    //没有反光面
    self.jsbadge.badgeOverlayColor = [UIColor clearColor];
    //5、外圈的颜色，默认是白色
   self.jsbadge.badgeStrokeColor = [UIColor redColor];
    
    self.jsbadge.badgeShadowColor = [UIColor clearColor];

    
//    _searchBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    _searchBtn.frame = CGRectMake(_chatBtn.right + kRealValue(15), 0, kRealValue(220), kRealValue(32));
//    _searchBtn.centerY = _chatBtn.centerY;
//    _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [_searchBtn setTitle:ASLocalizedString(@"搜索")forState:UIControlStateNormal];
//    _searchBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
//    [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    [_searchBtn setImage:[UIImage imageNamed:@"fw_me_search"] forState:UIControlStateNormal];
//    _searchBtn.layer.cornerRadius = kRealValue(32 / 2);
//    [_searchBtn addTarget:self action:@selector(handleTouchSearch) forControlEvents:UIControlEventTouchUpInside];
//    _searchBtn.layer.masksToBounds = YES;
//    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    QMUIButton *searchBTN = [QMUIButton buttonWithType:UIButtonTypeCustom];
    searchBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBTN setImage:[UIImage imageNamed:@"hm_search_btn"] forState:UIControlStateNormal];
    searchBTN.frame = CGRectMake(_chatBtn.right + kRealValue(20),MG_TOP_MARGIN,kScreenW - kRealValue(88) - kRealValue(55),kRealValue(30));
    [searchBTN addTarget:self action:@selector(handleTouchSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBTN.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [searchBTN setTitle:ASLocalizedString(@"搜索")forState:UIControlStateNormal];
    searchBTN.titleLabel.font = [UIFont systemFontOfSize:15];
    searchBTN.backgroundColor = kClearColor;
    [searchBTN setBackgroundImage:[UIImage imageNamed:@"hm_search_btn_bgimgView"]];
//    [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
    searchBTN.layer.cornerRadius = kRealValue(30 / 2);
    searchBTN.layer.masksToBounds = YES;
    searchBTN.spacingBetweenImageAndTitle = 5;
    searchBTN.imagePosition = QMUIButtonImagePositionLeft;
    [searchBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self addSubview:searchBTN];
    
    _postBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    _postBtn.frame = CGRectMake(kScreenW - kRealValue(58) - kRealValue(10), MG_TOP_MARGIN, kRealValue(58), kRealValue(30));
    _postBtn.centerY = _chatBtn.centerY;
    [_postBtn setTitle:ASLocalizedString(@"发帖")forState:UIControlStateNormal];
    [_postBtn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
    _postBtn.layer.cornerRadius = kRealValue(32 / 2);
    _postBtn.layer.masksToBounds = YES;
    _postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_postBtn setBackgroundColor:kWhiteColor];
    [_postBtn addTarget:self action:@selector(handlePostEvent) forControlEvents:UIControlEventTouchUpInside];
    
    _postBtn.centerY = searchBTN.centerY = _chatBtn.centerY;
    
    [self addSubview:_chatBtn];
    [self addSubview:_searchBtn];
    [self addSubview:_postBtn];
    
}
-(void)handleMsgEvent{
    if (self.clickPostBlock) {
        self.clickPostBlock(2);
    }
}
//跳转发帖
-(void)handlePostEvent{
    if (self.clickPostBlock) {
        self.clickPostBlock(1);
    }
}
//跳转话题搜索
-(void)handleTouchSearch{
    if (self.clickPostBlock) {
        self.clickPostBlock(0);
    }
}

@end
