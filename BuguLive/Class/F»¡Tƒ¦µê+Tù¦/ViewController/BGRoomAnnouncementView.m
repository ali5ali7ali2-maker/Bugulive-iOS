//
//  BGRoomAnnouncementView.m
//  UniversalApp
//
//  Created by bugu on 2020/3/25.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomAnnouncementView.h"
#import "RoomModel.h"
#import "UIView+Voice.h"
@interface BGRoomAnnouncementView ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *titleLabel;

//@property(nonatomic, strong) UILabel *textLabel;

@end
@implementation BGRoomAnnouncementView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        [self addAppTopCornerRadius];

        [self.bgImageView addAppTopCornerRadius];

        [self initSubview];
    }
    return self;
}

- (void)initSubview {
    
    self.backgroundColor = [UIColor clearColor];

    
    _bgImageView = ({
        UIImageView * imageView = [[UIImageView alloc]init];
        
        imageView.image = [UIImage imageNamed:@"gonggao_bac"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView;
    });
    
    
    _editBtn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"edit1"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        button.hidden = YES;
        button;
    });
    
    _titleLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor1;
        label.font = [UIFont boldSystemFontOfSize:19];
        label.text = ASLocalizedString(@"房间公告");
        //            label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
//    _textLabel= ({
//        UILabel * label = [[UILabel alloc]init];
//        label.textColor = [UIColor colorWithHexString:@"#646464"];
//        label.font = UIFont.bg_mediumFont15;
//        label.numberOfLines = 0;
//        //            label.textAlignment = NSTextAlignmentCenter;
//        label;
//    });
    
    _textView = ({
        QMUITextView * textView = [[QMUITextView alloc]init];
        
        textView.font = [UIFont systemFontOfSize:15];
        
        textView.textColor = [UIColor colorWithHexString:@"#646464"];
        textView.editable = NO;
        textView;
        
    });
    
    [self addSubview:_bgImageView];
    [self addSubview:_editBtn];

    [self addSubview:_titleLabel];
    
//    [self addSubview:_textLabel];
    [self addSubview:_textView];
//    self.editBtn.hidden=YES;
}

- (void)BtnAction:(UIButton *)sender {
    
       
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(announcementView:didClickEditBtn:)]) {
        [self.delegate announcementView:self didClickEditBtn:sender];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.mas_equalTo(0);
      }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(27);
    }];
    
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(30);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.equalTo(_titleLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(180);
        make.centerX.mas_equalTo(0);
    }];
    
}

- (void)setModel:(RoomModel *)model{
    _model = model;
//    self.editBtn.hidden = ![model.voice.user_id isEqualToString:[IMAPlatform sharedInstance].host.userId];
    [self.textView setText:model.voice.announcement];
}

- (void)show:(UIView *)superView{
    
//    if (![self.model.voice.user_id isEqualToString:[IMAPlatform sharedInstance].host.userId]) {
//        self.editBtn.hidden = (self.is_host == 0 && self.is_admin == 0);
//    }
    [super show:superView];
}

@end
