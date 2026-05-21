//
//  FocusHeaderCollectReusView.m
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "FocusHeaderCollectReusView.h"

@interface FocusHeaderCollectReusView ()

@property(nonatomic, strong) UIView *lineView;
@property (nonatomic,strong)UILabel *titleLabel;

@property(nonatomic, strong) QMUIButton *randomBtn;


@end

static NSString *const image_name_btn = @"换一换";

@implementation FocusHeaderCollectReusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    self.backgroundColor = kWhiteColor;
      
      _lineView = ({
          UIView * view = [[UIView alloc] init];
//          view.backgroundColor = [UIColor colorWithHexString:@"#9D64FF"];
          // gradient
        
//          view.layer.cornerRadius = 1.5;
          
          view;
      });


      _titleLabel = ({
          UILabel * label = [[UILabel alloc]init];
          label.textColor = [UIColor colorWithHexString:@"#333333"];;
          label.font = [UIFont systemFontOfSize:16];
          label.text = ASLocalizedString(@"推荐主播");
                label;
            });
    
     
         _randomBtn = ({
             QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
             [btn setImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];
             [btn setTitle:ASLocalizedString(@"换一换")forState:UIControlStateNormal];
             [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
             btn.titleLabel.font = [UIFont systemFontOfSize:14];
             btn.spacingBetweenImageAndTitle = 4;
             btn.imagePosition = QMUIButtonImagePositionLeft;
             [btn addTarget:self action:@selector(randomAction) forControlEvents:UIControlEventTouchUpInside];
             btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
             btn;
         });
   
        
    // [self addSubview:_lineView];
    // [self addSubview:_titleLabel];
    // [self addSubview:_randomBtn];

    CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = _lineView.bounds;
            gl.startPoint = CGPointMake(1, 0.5);
            gl.endPoint = CGPointMake(0, 0.5);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:157/255.0 green:100/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:240/255.0 green:96/255.0 blue:246/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0), @(1.0f)];
      [_lineView.layer addSublayer:gl];
}



- (void)randomAction{
    
    !self.randomBlock ? : self.randomBlock();

}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.top.mas_equalTo(8);
       make.left.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
   }];
    
    
    
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(18);
           make.centerY.mas_equalTo(0);
   }];
    [_randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(80);

    }];
}



- (void)setSection:(NSInteger)section{
    if (section == 0) {
        _randomBtn.hidden = NO;
        _titleLabel.text = ASLocalizedString(@"推荐主播");
    } else {
        _randomBtn.hidden = YES;
        _titleLabel.text = ASLocalizedString(@"已关注主播");
    }
}


@end
