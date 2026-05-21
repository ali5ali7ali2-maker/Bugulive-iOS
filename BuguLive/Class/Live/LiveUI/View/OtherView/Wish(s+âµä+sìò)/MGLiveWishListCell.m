//
//  MGLiveWishListCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/6.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGLiveWishListCell.h"

@implementation MGLiveWishListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
        [self resetView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setUpView{
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(11), 0, kScreenW - kRealValue(11 * 2), kRealValue(185))];
    [bgImgView setImage:[UIImage imageNamed:@"live_wish_bgView"]];
    self.bgImgView = bgImgView;
    [self.contentView addSubview:bgImgView];
    
    UILabel *titleL = [UILabel new];
    titleL.text = ASLocalizedString(@"心愿一");
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleL = titleL;
    
    UIImageView *iconImgView = [UIImageView new];
    [iconImgView setImage:[UIImage imageNamed:@"live_wish_gift_addBGView"]];
    _iconImgView = iconImgView;
    
    UILabel *topicL = [UILabel new];
    topicL.text = ASLocalizedString(@"奇才火箭");
    topicL.font = [UIFont systemFontOfSize:14];
    topicL.textColor = [UIColor colorWithHexString:@"#333333"];
    _topicL = topicL;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    _line = line;
    
    UILabel *contributionL = [UILabel new];
    contributionL.text = ASLocalizedString(@"贡献榜");
    contributionL.textColor = kBlackColor;
    contributionL.font = [UIFont systemFontOfSize:14];
    _contributionL = contributionL;
    
    UILabel *countL = [UILabel new];
    countL.text = @"520/990";
    countL.font = [UIFont systemFontOfSize:12];
    countL.textAlignment = NSTextAlignmentRight;
    countL.textColor = [UIColor colorWithHexString:@"#999999"];
    _countL = countL;
    
    
    [bgImgView addSubview:self.titleL];
    [bgImgView addSubview:self.iconImgView];
    [bgImgView addSubview:self.titleL];
    [bgImgView addSubview:self.progressBgView];
    [bgImgView addSubview:countL];
    [self.progressBgView addSubview:self.progressTitntView];
    [bgImgView addSubview:self.line];
    [bgImgView addSubview:self.contributionView];
    [bgImgView addSubview:self.contributionL];
}



-(void)resetCellWithWishType:(MGADD_WISH)wishType WithModel:(MGLiveWishModel *)model{
    
    _titleL.text = ASLocalizedString(@"心愿一");
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.g_icon] placeholderImage:nil];
    _topicL.text = [NSString stringWithFormat:@"%@",model.g_name];
    
    _progressTitntView.width = [model.g_now_num floatValue] / [model.g_num floatValue] * self.progressBgView.width;
    
    if ([model.g_now_num floatValue] > [model.g_num floatValue]) {
        _progressTitntView.width = self.progressBgView.width;
    }
    
    [_progressTitntView.layer addSublayer:[self gradientLayerWithColor1:[UIColor colorWithHexString:@"#9D64FF"] AtColor2:[UIColor colorWithHexString:@"#F060F6"] view:_progressTitntView]];
    
    _countL.text = [NSString stringWithFormat:@"%@/%@",model.g_now_num,model.g_num];
    
    for (int i = 0; i < 3; i ++) {
        
        MGLiveWishcontributionView *view = [self.contributionView viewWithTag:100 + i];
        
        NSInteger topUserCount = model.top_user.count;
        if (i > topUserCount - 1) {
            view.hidden = YES;
        }
        
        for (int j = 0; j < model.top_user.count; j++) {
            MGLiveWishUserModel *userModel = [MGLiveWishUserModel mj_objectWithKeyValues:model.top_user[j]];
            [view.headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head_image]];
            view.nickNameL.text = [NSString stringWithFormat:@"%@",userModel.nick_name];
            view.numL.text = [NSString stringWithFormat:ASLocalizedString(@"%@个"),userModel.gift_num];
        }
    }
    [self resetView];
}

-(void)resetView{
    
    _titleL.frame = CGRectMake(kRealValue(15), kRealValue(15), kScreenW * 0.4, 20);
    _iconImgView.frame = CGRectMake(_titleL.left, _titleL.bottom + kRealValue(21), kRealValue(30), kRealValue(30));
    _topicL.frame = CGRectMake(_iconImgView.right + kRealValue(5), _iconImgView.top + kRealValue(5), self.bgImgView.width - _iconImgView.width - kRealValue(10 * 3), kRealValue(20));
    _progressBgView.frame = CGRectMake(_topicL.left, _topicL.bottom + kRealValue(2), kRealValue(281), kRealValue(4));
    _progressTitntView.frame = CGRectMake(0, 0, _progressBgView.width / 2, _progressBgView.height);
    _countL.frame = CGRectMake(0, _progressBgView.bottom + kRealValue(2), kScreenW / 2, kRealValue(18));
    _countL.right = _progressBgView.right;
    _line.frame = CGRectMake(kRealValue(8), _iconImgView.bottom + kRealValue(31), kScreenW - kRealValue(19 * 2), kRealValue(1));
    _contributionL.frame = CGRectMake(kRealValue(12), _line.bottom + kRealValue(22) , kRealValue(50), kRealValue(20));
    _contributionView.frame = CGRectMake(_contributionL.right + kRealValue(5), 0, kScreenW - kRealValue(85), kRealValue(45));
    _contributionView.centerY = _contributionL.centerY;
    
}



-(void)clickDelete:(UIButton *)sender{
    
}

-(UIView *)progressTitntView{
    if (!_progressTitntView) {
        _progressTitntView = [UIView new];
        
    }
    return _progressTitntView;
}

-(UIView *)progressBgView{
    if (!_progressBgView) {
        _progressBgView = [UIView new];
        _progressBgView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _progressBgView;
}

-(UIView *)contributionView{
    if (!_contributionView) {
        _contributionView = [UIView new];
        
        NSArray *levelImgArr = [NSArray arrayWithObjects:@"live_wish_contributeion_first",@"live_wish_contributeion_second",@"live_wish_contributeion_third", nil];
        CGFloat viewWidth = kRealValue(108);
        for (int i = 0 ; i < 3 ; i ++) {
            MGLiveWishcontributionView *view = [[MGLiveWishcontributionView alloc]initWithFrame:CGRectMake(viewWidth * i, 0, viewWidth, kRealValue(45))];
            view.tag = 100 + i;
            view.levelImgView.image = [UIImage imageNamed:levelImgArr[i]];
            view.nickNameL.text = levelImgArr[i];
            [_contributionView addSubview:view];
        }
    }
    return _contributionView;
}



- (CAGradientLayer*)gradientLayerWithColor1:(UIColor*)color1 AtColor2:(UIColor*)color2 view:(UIView *)view
{
    CAGradientLayer* layer = [CAGradientLayer new];
    layer.colors = @[ (__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
    layer.startPoint = CGPointMake(0.5f, -0.5);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = view.bounds;
    return layer;
}



@end


@implementation MGLiveWishcontributionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    UIImageView *imgView = [UIImageView new];
    imgView.backgroundColor = kGrayColor;
    imgView.frame = CGRectMake(0, 0, kRealValue(28), kRealValue(28));
    imgView.centerY = self.bounds.size.height / 2;
    imgView.layer.cornerRadius = kRealValue(28 / 2);
    imgView.layer.masksToBounds = YES;
    _headImgView = imgView;
    
    UIImageView *levelImg = [UIImageView new];
    _levelImgView = levelImg;
    _levelImgView.frame = CGRectMake(0, 0, kRealValue(10), kRealValue(13));
    _levelImgView.top = imgView.bottom - kRealValue(4);
    _levelImgView.centerX = imgView.centerX;
    
    UILabel *nickNameL = [UILabel new];
    nickNameL.text = ASLocalizedString(@"昵称");
    nickNameL.font = [UIFont systemFontOfSize:12];
    nickNameL.textColor = kBlackColor;
    nickNameL.frame = CGRectMake(imgView.right + kRealValue(2), _headImgView.top + kRealValue(2), kRealValue(65), kRealValue(16));
    _nickNameL = nickNameL;
    
    UILabel *numL = [UILabel new];
    numL.text = ASLocalizedString(@"200个");
    numL.font = [UIFont systemFontOfSize:12];
    numL.textColor = [UIColor colorWithHexString:@"#CD49FF"];
    numL.frame = CGRectMake(nickNameL.left , _nickNameL.bottom + kRealValue(2) , kRealValue(65), kRealValue(16));
    _numL = numL;
    
    
    [self addSubview:imgView];
    [self addSubview:levelImg];
    [self addSubview:nickNameL];
    [self addSubview:numL];
    
}


@end
