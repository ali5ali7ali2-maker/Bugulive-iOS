//
//  STVideoCateCell.m
//  BuguLive
//
//  Created by bugu on 2019/12/3.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "STVideoCateCell.h"

@implementation STVideoCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    
    QMUIButton *leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
           leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

           [leftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
           leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
           [leftBtn setTitle:ASLocalizedString(@"短视频分类")forState:UIControlStateNormal];
           leftBtn.imagePosition = QMUIButtonImagePositionLeft;
           [leftBtn setImage:[UIImage imageNamed:@"短视频分类"] forState:UIControlStateNormal];
           leftBtn.spacingBetweenImageAndTitle = 15;
           leftBtn.userInteractionEnabled = NO;
    self.leftBtn = leftBtn;
    
    //添加一个隐藏的 topicBtn
               
               QMUIButton *topicBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
               topicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    topicBtn.userInteractionEnabled = NO;
//               topicBtn.imagePosition = QMUIButtonImagePositionRight;
//               topicBtn.spacingBetweenImageAndTitle = 15;
               topicBtn.frame = CGRectMake(kScreenW-90, 12, 60, 30);
//               topicBtn.layer.cornerRadius = 15;
//               topicBtn.clipsToBounds = YES;
    [topicBtn setTitle:@"选择分类" forState:UIControlStateNormal];
//               topicBtn.backgroundColor = [UIColor colorWithHexString:@"#FBF2FF"];
               [topicBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
//               topicBtn.hidden = YES;
//               [topicBtn addTarget:self action:@selector(deleteTopicButtonClick) forControlEvents:UIControlEventTouchUpInside];
               [self addSubview:topicBtn];
               self.cateBtn = topicBtn;
    
    [self addSubview:self.leftBtn];

    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.equalTo(@10);
                  make.centerY.equalTo(@0);
                  make.width.equalTo(@110);
              }];
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.image = [UIImage imageNamed:@"进入"];
    [self addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
}






@end
