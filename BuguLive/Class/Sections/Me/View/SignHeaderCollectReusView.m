//
//  SignHeaderCollectReusView.m
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "SignHeaderCollectReusView.h"
@interface SignHeaderCollectReusView ()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLabel;

@property(nonatomic, strong) UIView *bgView;

@property (nonatomic,strong)UILabel *tipLabel;


@end

static NSString *const image_name_bg = @"签到页背景";
static NSString *const image_name = @"插画";
static NSString *const image_name_btn = @"数字显示";

@implementation SignHeaderCollectReusView

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
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_name_bg];
        iv;
    });
    
    _titleLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kWhiteColor;
        label.font = [UIFont systemFontOfSize:13];
        label.text = ASLocalizedString(@"已连续签到");
        label;
    });
    _tipLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kWhiteColor;
        label.font = [UIFont systemFontOfSize:13];
        label.text = ASLocalizedString(@"天");
        
        label;
    });
    
    _iconImageView = ({
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_name];
        iv;
    });
    
    
    [self addSubview:_bgImageView];
    [_bgImageView addSubview:_titleLabel];
    [_bgImageView addSubview:_iconImageView];
    
    
    _bgView=({
        UIView * view = [[UIView alloc]init];
        view;
    });
    
    [_bgImageView addSubview:_bgView];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-6);
        make.right.mas_equalTo(-37);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(40);
        
    }];
    
    
    
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(40);
        //        make.width.mas_equalTo(30*4);
        make.height.mas_equalTo(45);
        
    }];
    
    
}
- (void)setDataWithsignin_continue:(NSString *)signin_continue signin_count:(NSString *)signin_count{
    
    [_bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (signin_continue.intValue == 1) {
        
        
        UIView * lastView ;
        
        int totalCount = 3;
        if (signin_count.intValue > 999) {
            
            totalCount=signin_count.length;
            
        }else{
            signin_count = [NSString stringWithFormat:@"%03d",signin_count.intValue];
        }
        
        for (int i = 0; i < totalCount; i ++) {
            
            NSString *numStr=[signin_count substringWithRange:NSMakeRange(i, 1)];
            
            UIButton * numBtn = ({
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];
                [btn setTitle:numStr forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
                
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
                btn;
            });
            [_bgView addSubview:numBtn];
            [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView).offset((30+7)*i);
                make.centerY.mas_equalTo(_bgView);
                
                
            }];
            
            
            lastView = numBtn;
        }
        [_bgView addSubview:_tipLabel];
        
        
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lastView);
            make.left.mas_equalTo(37*totalCount);
        }];
        
        
    }else{
        
        UIView * lastView ;
        
        int totalCount = 3;
    
        
        for (int i = 0; i < totalCount; i ++) {
            
            
            UIButton * numBtn = ({
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];
                [btn setTitle:@"0" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
                
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
                btn;
            });
            [_bgView addSubview:numBtn];
            [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView).offset((30+7)*i);
                make.centerY.mas_equalTo(_bgView);
                
                
            }];
            
            
            lastView = numBtn;
        }
        [_bgView addSubview:_tipLabel];
        
        
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lastView);
            make.left.mas_equalTo(37*totalCount);
        }];
        

        
        
    }
    
}
@end
