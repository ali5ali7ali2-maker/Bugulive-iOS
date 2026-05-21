//
//  BGRoomManagerCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomManagerCell.h"
#import "RoomUserInfo.h"
#import "CommonSexView.h"
#import "UIFont+Ext.h"
#import "UIButton+CAGradientLayer.h"
@interface BGRoomManagerCell ()


@property(nonatomic, strong) UILabel *IDLabel;
@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) QMUIButton *titleSexBtn;
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

@property(nonatomic, strong) CommonSexView *sexView;
@property(nonatomic, strong) UIView *line;

@end

@implementation BGRoomManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
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
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button setTitleColor:kGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
        button.imagePosition = QMUIButtonImagePositionRight;
        button.spacingBetweenImageAndTitle = 5;
        button;
        
    });
    
    _IDLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kAppGrayColor1;
        label.font = [UIFont systemFontOfSize:13];
        //        label.text = @"Title";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleSexBtn];
    [self.contentView addSubview:_IDLabel];
    
    [self.contentView addSubview:self.sexView];

    _addBtn = [UIButton buttonGradientFrame:CGRectMake(kScreenW-70-20, 20, 70, 30) Title:ASLocalizedString(@"添加") target:self action:@selector(addBtnAction)];
    
    
    _addBtn.titleLabel.font = UIFont.bg_mediumFont14;
    
    [self.contentView addSubview:_addBtn];
    
    _cancelBtn = [UIButton buttonLayerColor:kAppGrayColor3 Frame:CGRectMake(kScreenW-70-20, 20, 70, 30) Title:ASLocalizedString(@"取消") target:self action:@selector(cancelBtnAction)];
    
    
    _cancelBtn.titleLabel.font = UIFont.bg_mediumFont14;
    
    [self.contentView addSubview:_cancelBtn];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];

    [self.contentView addSubview:_line];

    
    
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
        make.top.equalTo(_iconImageView);
    }];
    [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleSexBtn);
        make.bottom.equalTo(_iconImageView);

    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleSexBtn.mas_right).mas_offset(6);
        make.size.mas_equalTo(CGSizeMake(32, 17));
        make.centerY.mas_equalTo(self.titleSexBtn);
    }];
    
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(41.5);
        make.right.mas_equalTo(-22);

        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);

    }];
}


- (void)addBtnAction {
    if (self.addActionBlock) {
        self.addActionBlock();
    }
}

- (void)cancelBtnAction {
    if (self.cancelActionBlock) {
        self.cancelActionBlock();
    }
}


- (void)setCellType:(RoomManagerCellType)cellType{
    _cellType = cellType;
    if (cellType == RoomManagerCellTypeAdd) {
        _addBtn.hidden = NO;
        _cancelBtn.hidden = YES;
    } else {
        _addBtn.hidden = YES;
        _cancelBtn.hidden = NO;
    }
}


- (void)setInfo:(RoomUserInfo *)info{
    _info = info;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:info.head_image] placeholderImage:nil];
    [self.titleSexBtn setTitle:info.nick_name forState:UIControlStateNormal];
    [self.sexView setSex:info.sex.intValue age:info.age.intValue];

    self.IDLabel.text = [NSString stringWithFormat:@"ID：%@",info.user_id];
}
- (CommonSexView *)sexView{
    if (!_sexView) {
        _sexView = [[CommonSexView alloc]initWithFrame:CGRectZero];
    }
    return _sexView;
}

@end
