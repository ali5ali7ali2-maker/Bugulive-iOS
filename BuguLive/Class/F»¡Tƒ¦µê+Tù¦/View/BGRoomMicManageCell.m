//
//  BGRoomMicManageCell.m
//  UniversalApp
//
//  Created by bugu on 2020/4/8.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomMicManageCell.h"
#import "RoomUserInfo.h"
#import "UIFont+Ext.h"
@interface BGRoomMicManageCell ()

@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) QMUIButton *titleSexBtn;
@property(nonatomic, strong) UIView *sexView;

@property(nonatomic, strong) UIButton *micBtn;
@property(nonatomic, strong) UIButton *manageBtn;
//拒绝上麦按钮 或者抱下麦
@property(nonatomic, strong) UIButton *refuseBtn;

@end

@implementation BGRoomMicManageCell

@synthesize type = _type;
@synthesize model = _model;



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}




- (void)setupViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _iconImageView = ({
        UIImageView * imageView = [[UIImageView alloc]init];
        
        imageView.layer.cornerRadius = 22;
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView;
    });
    
    _titleSexBtn = ({
        
        QMUIButton * button = [[QMUIButton alloc]initWithFrame:CGRectZero];
        //        [button setTitle:@"0" forState:UIControlStateNormal];
        [button.titleLabel setFont:UIFont.bg_mediumFont16];
        [button setTitleColor:kGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
        button.imagePosition = QMUIButtonImagePositionRight;
        button.spacingBetweenImageAndTitle = 5;
        button;
        
    });
    _micBtn = ({
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
        [button setImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"mike_off_v2"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(micBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;

        
        button;
        
    });
  _manageBtn = ({

      UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
      //        [button setTitle:@"0" forState:UIControlStateNormal];
      [button.titleLabel setFont:UIFont.bg_mediumFont14];
      [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
//      [button setImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];
      [button setTitle:@"同意上麦" forState:UIControlStateNormal];
//      [button setImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];
      button.hidden = YES;
      button.clipsToBounds = YES;
      button.layer.cornerRadius = 15;
      [button addTarget:self action:@selector(manageBtnAction:) forControlEvents:UIControlEventTouchUpInside];

      button;

  });
    _manageBtn.frame = CGRectMake(kScreenW-70*2-25, 10, 70, 30);

    
    _refuseBtn = ({

        UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
        //        [button setTitle:@"0" forState:UIControlStateNormal];
        [button.titleLabel setFont:UIFont.bg_mediumFont14];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
  //      [button setImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];
        [button setTitle:@"拒绝上麦" forState:UIControlStateNormal];
  //      [button setImage:[UIImage imageNamed:@"同意按钮"] forState:UIControlStateNormal];

        button.clipsToBounds = YES;
        button.layer.cornerRadius = 15;
        [button addTarget:self action:@selector(manageBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        button;

    });
    _refuseBtn.frame = CGRectMake(kScreenW-70-20, 10, 70, 30);
    
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleSexBtn];
    [self.contentView addSubview:_micBtn];
    
    [self.contentView addSubview:_manageBtn];
    [self.contentView addSubview:_refuseBtn];

    [self.contentView addSubview:self.sexView];

//
//    _addBtn.titleLabel.font = UIFont.bg_mediumFont14;
//
//    [self.contentView addSubview:_addBtn];
//
//    _cancelBtn = [UIButton buttonLayerColor:kAppGrayColor3 Frame:CGRectMake(kScreenW-70-20, 20, 70, 30) Title:@"取消" target:self action:@selector(cancelBtnAction)];
//
//
//    _cancelBtn.titleLabel.font = UIFont.bg_mediumFont14;
//
//    [self.contentView addSubview:_cancelBtn];
//
//
    
    //    _cancelBtn.
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(44);
    }];
    
    [_titleSexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(12);
        make.centerY.equalTo(_iconImageView);
    }];
   
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleSexBtn.mas_right).mas_offset(6);
        make.size.mas_equalTo(CGSizeMake(32, 17));
        make.centerY.mas_equalTo(self.titleSexBtn);
    }];
    
    
    [_micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-116);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(33);
    }];
    
}


-(void)setType:(RoomMicManageCellType)type{
    _type = type;
    if (type == RoomMicManageCellTypeApplyList) {
        self.manageBtn.hidden = NO;
        self.refuseBtn.hidden = NO;
        [self.manageBtn setTitle:@"同意上麦" forState:UIControlStateNormal];
    }
    else if(type == RoomMicManageCellTypeManageView)
    {
        self.refuseBtn.hidden = NO;
        
        
        self.manageBtn.hidden = NO;
        [self.manageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.manageBtn setImage:[UIImage imageNamed:@"开麦"] forState:UIControlStateNormal];
        [self.manageBtn setImage:[UIImage imageNamed:@"闭麦"] forState:UIControlStateSelected];
        [self.manageBtn setBackgroundImage:nil forState:UIControlStateNormal];


        [self.refuseBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.refuseBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [self.refuseBtn setBackgroundColor:RGB(244, 36, 22)];
        [self.refuseBtn setTitle:@"抱下麦" forState:UIControlStateNormal];
    }
}

- (void)setModel:(RoomUserInfo *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
    
    [self.titleSexBtn setTitle:model.nick_name forState:UIControlStateNormal];
    self.micBtn.hidden = YES;
    [self.manageBtn setTitle:@"同意上麦" forState:UIControlStateNormal];
    

    if(self.type == RoomMicManageCellTypeManageView)
    {
        if(model.is_ban_voice == 0)
        {
            self.manageBtn.selected = NO;
        }
        else
        {
            self.manageBtn.selected = YES;
        }
    }
}

- (void)manageBtnAction:(UIButton *)sender {
//    if ([sender.titleLabel.text isEqualToString:ASLocalizedString(@"在麦上")]) {
//        return;
//    }
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageCell:didClickManageBtn:)]) {
        [self.delegate manageCell:self didClickManageBtn:sender];
    }
}

- (void)micBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageCell:didClickMicBtn:)]) {
        [self.delegate manageCell:self didClickMicBtn:sender];
    }
}
- (UIView *)sexView{
    if (!_sexView) {
        _sexView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _sexView;
}
@end
