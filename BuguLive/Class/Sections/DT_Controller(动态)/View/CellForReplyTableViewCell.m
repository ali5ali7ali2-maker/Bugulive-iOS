//
//  CellForReplyTableViewCell.m
//  MarryU
//
//  Created by 志刚杨 on 2017/6/29.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import "CellForReplyTableViewCell.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"



@implementation CellForReplyTableViewCell

CGFloat maxReplayContentLabelHeight = 0;  //根据具体font而定


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup {
    _avatar = [[UIImageView alloc] init];
    _avatar.layer.cornerRadius = 20;
    _avatar.layer.masksToBounds = YES;
    _avatar.image = [UIImage imageNamed:@"素材1"];
    [self.contentView addSubview:_avatar];
    
    _nicename = [UILabel new];
    _nicename.text = @"loading..";
    _nicename.font = [UIFont systemFontOfSize:13];
//    DEFAULT_FONT(13);
    _nicename.userInteractionEnabled = YES;
    _nicename.textColor = kBlackColor;
    [self.contentView addSubview:_nicename];
    
    
    
    _age = [UILabel new];
    _age.text = @"22";
    [_age setBackgroundColor:kBlackColor];
    [_age setTextColor:[UIColor whiteColor]];
    _age.font = [UIFont systemFontOfSize:12];
    _age.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_age];
    
    _body = [UILabel new];
    _body.text = @"niaho";
    _body.font = [UIFont systemFontOfSize:14];
    _body.numberOfLines = 0;
    _body.preferredMaxLayoutWidth = kScreenW - 30;
    
    [self.contentView addSubview:_body];
    
    _addtime = [UILabel new];
    _addtime.text = @"19970202";
    _addtime.textColor = [UIColor groupTableViewBackgroundColor];
    _addtime.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_addtime];
    
    _city = [UILabel new];;
    _city.text = @"19970202";
    _city.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_city];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTitleColor:RGBCOLOR(61, 95, 155) forState:UIControlStateNormal];
    [_deleteBtn setTitle:ASLocalizedString(@"删除")forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_deleteBtn addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [self.contentView addSubview:self.deleteBtn];
    
    _city.textColor = kBlackColor;
//    RGB16(0x999999);
    _addtime.textColor = kBlackColor;
//    RGB16(0x999999);
    
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = KMGLineColor;
    [self.contentView addSubview:_line];
    
    [self layoutUI];
}



-(void)layoutUI
{
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(@10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];

    [_nicename mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatar.mas_top).offset(5);
        make.left.equalTo(_avatar.mas_right).offset(5);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_nicename.mas_right).offset(10);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(_nicename.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(kRealValue(24));
    }];

    [_age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nicename.mas_right).offset(5);
        make.top.equalTo(_avatar);
        make.width.equalTo(@20);
    }];

    _age.hidden = YES;

    [_city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nicename.mas_bottom).offset(2);
        make.left.equalTo(_avatar.mas_right).offset(5);
    }];

    _city.hidden = YES;

    

    
    [_body mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_city.mas_top).offset(2);
        make.left.equalTo(_avatar.mas_right).offset(5);
        make.right.mas_equalTo(-kRealValue(10));
    }];
    
    [_addtime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_body.mas_bottom).offset(5);
//            make.centerY.mas_equalTo(_nicename.mas_centerY);
            make.left.equalTo(_body.mas_left);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addtime.mas_bottom).offset(10);
        make.left.equalTo(_addtime.mas_left);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    
    self.hyb_lastViewInCell = _line;
    self.hyb_bottomOffsetToCell = 1;
}

-(void)clickDelete:(UIButton *)sender{
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock(YES);
    }
}

-(void)setModel:(MGGroupUserInfo *)model
{
    _model = model;
//    _avatar.imageURL = model.userInfo.head_image;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    _nicename.text = model.nick_name;
//    userInfo.nick_name;
    _body.text = model.content;
    _addtime.text = model.addtime;
//    [self dateToString:model.addtime];
    if ([model.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
//
//    maxReplayContentLabelHeight   = _body.font.pointSize * 6;
//
//    _cstHeightlbContent.constant = maxReplayContentLabelHeight;
    
}



- (NSString *)dateToString:(NSString*)str
{
    NSTimeInterval _interval = [str doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [objDateformat stringFromDate:date];
    
    return timeStr;
}

@end
