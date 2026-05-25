//
//  MGNewDTNearPeopleCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/18.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGNewDTNearPeopleCell.h"

@implementation MGNewDTNearPeopleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    UIImageView *headImgView = [[UIImageView alloc]init];
    _headImgView = headImgView;
    
    UIImageView *sexImgView = [[UIImageView alloc]init];
    _sexImgView = sexImgView;
    QMUIButton *certImgView = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [certImgView setImage:[UIImage imageNamed:@"mg_dt_near_cert"] forState:UIControlStateNormal];
    certImgView.backgroundColor = [UIColor colorWithHexString:@"#EAF9FF"];
//    [certImgView setBackgroundImage:[UIImage imageNamed:@"mg_dt_near_cert_bg"]];

    [certImgView setTitle:ASLocalizedString(@"支付宝认证")forState:UIControlStateNormal];
    certImgView.titleLabel.font = [UIFont systemFontOfSize:8];
    [certImgView setTitleColor:[UIColor colorWithHexString:@"#04AEFB"] forState:UIControlStateNormal];
    certImgView.imagePosition = QMUIButtonImagePositionLeft;
    certImgView.spacingBetweenImageAndTitle = 2;
    _certImgView = certImgView;
    
    UILabel *nickNameL = [UILabel new];
    nickNameL.font = [UIFont systemFontOfSize:14];
    nickNameL.text = ASLocalizedString(@"昵称");
    _nickNameL = nickNameL;
    
    UILabel *contentL = [UILabel new];
    contentL.font = [UIFont systemFontOfSize:14];
    contentL.text = ASLocalizedString(@"讨论");
    contentL.textColor = [UIColor colorWithHexString:@"#666666"];
    _contentL = contentL;
    
    
    UILabel *timeL = [UILabel new];
    timeL.textAlignment = NSTextAlignmentRight;
    timeL.font = [UIFont systemFontOfSize:11];
    timeL.text = ASLocalizedString(@"时间");
    timeL.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeL = timeL;
    
    UILabel *distanceL = [UILabel new];
    distanceL.font = [UIFont systemFontOfSize:11];
    distanceL.textAlignment = NSTextAlignmentRight;
    distanceL.text = ASLocalizedString(@"距离");
    distanceL.textColor = [UIColor colorWithHexString:@"#999999"];
    _distanceL = distanceL;
    
    _line = [UIView new];
    _line.backgroundColor = KMGLineColor;
    
    [self.contentView addSubview:headImgView];
    [self.contentView addSubview:sexImgView];
    [self.contentView addSubview:certImgView];
    [self.contentView addSubview:contentL];
    [self.contentView addSubview:nickNameL];
    [self.contentView addSubview:timeL];
    [self.contentView addSubview:distanceL];
    [self.contentView addSubview:self.line];
    
    
    _contentL.hidden = _sexImgView.hidden = _certImgView.hidden = YES;
    _timeL.hidden = _distanceL.hidden = YES;
    
}

-(void)resetModelWithModel:(id)model type:(MGNEWDT_TYPE)dtType{
    self.dtType = dtType;
    
    MGDynamicTopicModel *topicModel = model;
    if (dtType == MGNEWDTTYPE_TOPIC) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:topicModel.img] placeholderImage:nil];
        self.headImgView.layer.masksToBounds = YES;
        self.headImgView.layer.cornerRadius = 4;
        self.nickNameL.text = topicModel.name;
        self.contentL.text = [NSString stringWithFormat:ASLocalizedString(@"%@ 人讨论"),topicModel.num];
        
        _contentL.hidden  = NO;
        _sexImgView.hidden = _certImgView.hidden = _timeL.hidden = _distanceL.hidden = YES;
    }else{
        _contentL.hidden = YES;
        _sexImgView.hidden = _certImgView.hidden = _timeL.hidden = _distanceL.hidden = NO;
        MGNewDTNearlistModel *nearModel = model;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:nearModel.head_image] placeholderImage:nil];
        self.headImgView.layer.masksToBounds = YES;
        self.headImgView.layer.cornerRadius = kRealValue(40 / 2);
        self.nickNameL.text = nearModel.nick_name;
        self.timeL.text = nearModel.logout_time;
        self.distanceL.text = nearModel.juli;
        [self.sexImgView setImage:[UIImage imageNamed:[nearModel.sex isEqualToString:@"1"] ? @"dy_sex_male" :@"dy_sex_female"]];
        self.certImgView.hidden = ![nearModel.v_type isEqualToString:@"1"];
//        self.certImgView
    }
    
    self.contentL.hidden = self.dtType == MGNEWDTTYPE_NEAR_PEOPLE;//如果是附近就隐藏掉
    
    self.headImgView.frame = CGRectMake(kRealValue(10), kRealValue(10), kRealValue(40), kRealValue(40));
    self.nickNameL.frame = CGRectMake(self.headImgView.right + kRealValue(10), self.headImgView.top + kRealValue(3), kScreenW / 2, kRealValue(18));
    self.contentL.frame = CGRectMake(self.nickNameL.left, self.nickNameL.bottom + kRealValue(5), kScreenW * 0.6, kRealValue(15));
    
    self.sexImgView.frame = CGRectMake(self.nickNameL.left, self.nickNameL.bottom + kRealValue(5), kRealValue(10), kRealValue(10));
    self.certImgView.frame = CGRectMake(self.sexImgView.right + kRealValue(5), 0, kRealValue(66), kRealValue(13));
    self.certImgView.layer.masksToBounds = YES;
    self.certImgView.layer.cornerRadius = kRealValue(13 / 2);
    
    self.certImgView.centerY = self.sexImgView.centerY;
    
    self.timeL.frame = CGRectMake(self.nickNameL.right + kRealValue(2), self.nickNameL.top, kScreenW - self.nickNameL.right - kRealValue(10), kRealValue(15));
    
    self.distanceL.frame = CGRectMake(self.timeL.left, self.timeL.bottom + kRealValue(5), self.timeL.width, kRealValue(15));
    self.line.frame  = CGRectMake(0, self.headImgView.bottom + kRealValue(10) - 1, kScreenW, 1);
}

@end
