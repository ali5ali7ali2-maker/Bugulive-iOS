//
//  BGSystemMsgContentCell.m
//  BuguLive
//
//  Created by bugu on 2019/12/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGSystemMsgContentCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface BGSystemMsgContentCell ()
@property(nonatomic, strong) UILabel *timeLabel;
@property (nonatomic,strong)UIView *bgView;

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *contentLabel;

@end
static NSString *const image_name_bg = @"dy_msg_bg";

@implementation BGSystemMsgContentCell
//
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    
    _timeLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor1;
        label.font = [UIFont systemFontOfSize:16];
        label;
    });
    _bgView=({
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=kWhiteColor;
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:0.5].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,0);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 6;
        view;
    });
    _bgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_bg];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView;
    });
    _titleLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor1;
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        
        label;
    });
    _lineView = ({
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        view;
    });
    _contentLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor2;
        label.font = [UIFont systemFontOfSize:16];
        
        label.numberOfLines = 0;
        label;
    });
    
    [self.contentView addSubview:_timeLabel];
    
    [self.contentView addSubview:_bgView];
    
    
    [_bgView addSubview:_titleLabel];
    [_bgView addSubview:_lineView];
    [_bgView addSubview:_contentLabel];
    
    self.hyb_lastViewInCell = _bgView;
    self.hyb_bottomOffsetToCell = 10;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        
        make.left.mas_equalTo(18);
        make.centerX.mas_equalTo(0);
        
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(18);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(_timeLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(11);
        make.centerX.mas_equalTo(0);
        
        
    }];
    
    
}
- (void)setModel:(BGSystemMsgModel *)model{
    
    _timeLabel.text = model.addtime;
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    
}

@end
