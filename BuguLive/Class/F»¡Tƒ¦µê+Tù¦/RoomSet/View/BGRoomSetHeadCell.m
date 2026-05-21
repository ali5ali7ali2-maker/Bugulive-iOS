//
//  BGRoomSetHeadCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomSetHeadCell.h"
#import "UIFont+Ext.h"
@interface BGRoomSetHeadCell ()


@property(nonatomic, strong) UILabel *titleLabel;
//半透明背景
@property(nonatomic, strong) UIImageView *bgImageView;
@end

@implementation BGRoomSetHeadCell

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
    self.bgImageView = ({
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView;
    });
    ViewRadius(self.bgImageView, 10);
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    self.bgImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _iconBtn = ({
        
     UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
        [button setImage:[UIImage imageNamed:@"room_camera"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 8;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        
     button;
     
    });
    
    _titleLabel= ({
            UILabel * label = [[UILabel alloc]init];
            label.textColor = kAppGrayColor1;
            label.font = UIFont.bg_mediumFont16;
            label.text = ASLocalizedString(@"房间名称");
            label.hidden = YES;
//            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    
     _iconTipLabel= ({
                UILabel * label = [[UILabel alloc]init];
                label.textColor = kWhiteColor;
                label.font = [UIFont systemFontOfSize:11];
                label.text = ASLocalizedString(@"设置房间头像");
         label.backgroundColor = [kBlackColor colorWithAlphaComponent:0.38];
                     label.textAlignment = NSTextAlignmentCenter;


//
         
         
         
    //            label.textAlignment = NSTextAlignmentCenter;
                label;
            });
        
    
    _titleTextField = ({
        QMUITextField * TF = [[QMUITextField alloc]init];
        TF.backgroundColor = [UIColor clearColor];
        TF.placeholder = ASLocalizedString(@"给房间取个名~");
        TF.placeholderColor = [UIColor colorWithHexString:@"#FFFFFF"];
        TF.textColor = kWhiteColor;
        TF.font = [UIFont systemFontOfSize:16];
        TF.layer.cornerRadius = 8;
           TF.clipsToBounds = YES;
        TF.textInsets = UIEdgeInsetsMake(0, 16, 0, 16);

        TF;
    });
    
    [self.contentView addSubview:_iconBtn];
    [self.contentView addSubview:_iconTipLabel];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_titleTextField];

    _iconTipLabel.frame = CGRectMake(kScreenW-22-83, 93-17, 100, 17);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_iconTipLabel.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
       CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
       maskLayer.frame = _iconTipLabel.bounds;
       maskLayer.path = maskPath.CGPath;
       _iconTipLabel.layer.mask = maskLayer;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(100);
    }];
    
    
    [_iconTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconBtn);
        make.bottom.equalTo(_iconBtn);
        make.width.mas_equalTo(_iconBtn);
        make.height.mas_equalTo(17);

    }];
//

        
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(16+10);
    }];
    
    
    

    
    
    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBtn.mas_right).offset(9.5);
        make.top.equalTo(self.iconBtn.mas_top).offset(11);
        make.height.mas_equalTo(36);
        make.right.equalTo(self.mas_right).offset(-71);
    }];
}


- (void)BtnAction {
   
    if (self.selectImgBlock) {
        self.selectImgBlock();
    }
}


@end
