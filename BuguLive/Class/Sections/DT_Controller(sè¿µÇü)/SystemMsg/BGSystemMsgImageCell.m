//
//  BGSystemMsgImageCell.m
//  BuguLive
//
//  Created by bugu on 2019/12/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGSystemMsgImageCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface BGSystemMsgImageCell ()
@property(nonatomic, strong) UILabel *timeLabel;
@property (nonatomic,strong)UIView *bgView;

@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;

@end
static NSString *const image_name_bg = @"dy_msg_bg";

@implementation BGSystemMsgImageCell
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
//        view.backgroundColor = kRedColor;
        //        view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:0.5].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,0);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 6;
        
        view;
    });
    
    _coverImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        //        imageView.image = [UIImage imageNamed:image_name_bg];
        //        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView;
    });
    _titleLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor1;
//        label.backgroundColor = kBlackColor;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.numberOfLines = 0;
        label;
    });
    
    _contentLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor2;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentRight;
        label;
    });
    
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_bgView];
    
    [_bgView addSubview:_titleLabel];
    [_bgView addSubview:_contentLabel];
    
    
    [_bgView addSubview:_coverImageView];
    
    self.hyb_lastViewInCell = _bgView;
    
    self.hyb_bottomOffsetToCell = 10;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealValue(143));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverImageView.mas_bottom).offset(8);
        make.left.mas_equalTo(18);
//        make.centerX.mas_equalTo(0);
    }];
//    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
//        make.left.mas_equalTo(18);
//        make.centerX.mas_equalTo(0);
//        make.bottom.mas_equalTo(-20);
//
//    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.top.equalTo(_titleLabel.mas_top);
           make.right.mas_equalTo(-18);
           make.centerY.mas_equalTo(_titleLabel);
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
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:kDefaultPreloadImgRectangle];
   
}


@end
