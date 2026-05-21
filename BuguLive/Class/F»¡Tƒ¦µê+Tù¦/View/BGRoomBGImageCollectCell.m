//
//  BGRoomBGImageCollectCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomBGImageCollectCell.h"
#import "RoomBGImageModel.h"

@interface BGRoomBGImageCollectCell ()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIButton *selectedBtn;
@property(nonatomic, strong) UILabel *titleLabel;

@end


@implementation BGRoomBGImageCollectCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    
    _bgImageView = ({
           UIImageView * imageView = [[UIImageView alloc]init];
           
           imageView.layer.cornerRadius = 8;
           
           imageView.clipsToBounds = YES;
           imageView.contentMode = UIViewContentModeScaleAspectFill;
           imageView;
       });
    
    
    _titleLabel= ({
                   UILabel * label = [[UILabel alloc]init];
                   label.textColor = kAppGrayColor1;
                   label.font = [UIFont systemFontOfSize:16];
//                   label.text = @"TITLE";
                   label.textAlignment = NSTextAlignmentCenter;
                   label;
               });
    
    _selectedBtn = ({
              UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
              [button setImage:[UIImage imageNamed:@"room_select"] forState:UIControlStateNormal];
              [button addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];

              button;
          });
    
    [self addSubview:_bgImageView];

    [self addSubview:_titleLabel];
    [self addSubview:_selectedBtn];

    
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.centerX.mas_equalTo(0);
        make.height.mas_equalTo(kRealValue(260));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_bgImageView.mas_bottom).offset(10);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.equalTo(_bgImageView.mas_bottom).offset(-10);
        make.size.mas_equalTo(30);
    }];
    
}

- (void)BtnAction {
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
//    self.selectedBtn.hidden = !selected;
}

-(void)setModel:(RoomBGImageModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [self.titleLabel setText:SafeStr(model.name)];
    self.selectedBtn.hidden = !model.selected;
//    [self setSelected:model.selected];
}



@end
