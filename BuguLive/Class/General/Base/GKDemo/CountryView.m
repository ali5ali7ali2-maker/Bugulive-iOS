#import "CountryView.h"
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import <SDWebImage/SDWebImage.h>

@implementation CountryView

- (instancetype)initWithFrame:(CGRect)frame countries:(NSArray<NSDictionary *> *)countries {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithCountries:countries];
    }
    return self;
}

- (void)setupUIWithCountries:(NSArray<NSDictionary *> *)countries {
    // 推荐国家标签
    UILabel *recommendLabel = [[UILabel alloc] init];
    recommendLabel.text = ASLocalizedString(@"推荐国家");
    recommendLabel.textColor = [UIColor blackColor];
    recommendLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:recommendLabel];
    [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
    }];

    // 国家按钮容器
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10); // 确保 containerView 有底部约束
    }];

    // 添加国家按钮
    CGFloat buttonWidth = (self.frame.size.width - 60) / 5; // 5个按钮，每个按钮之间有10的间距
    CGFloat buttonHeight = 50;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 5; j++) {
            int index = i * 5 + j;
            if (index < countries.count) {
                NSDictionary *country = countries[index];
                QMUIButton *button = [self createCountryButtonWithImage:country[@"img"] title:[NSString stringWithFormat:@"%@", country[@"name"]]];
                [containerView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(containerView).offset(10 + j * (buttonWidth + 10));
                    make.top.equalTo(containerView).offset(10 + i * (buttonHeight + 10));
                    make.width.mas_equalTo(buttonWidth);
                    make.height.mas_equalTo(buttonHeight);
                }];
                [button qmui_bindObject:country forKey:@"country"];
            }
        }
    }
}

- (QMUIButton *)createCountryButtonWithImage:(NSString *)imageName title:(NSString *)title {
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    button.imagePosition = QMUIButtonImagePositionTop;
    [button addTarget:self action:@selector(handleCountryEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.spacingBetweenImageAndTitle = 3;
    
    // 创建一个图像变换器，将图像缩放到固定尺寸 22x15
    SDImageResizingTransformer *transformer = [SDImageResizingTransformer transformerWithSize:CGSizeMake(22, 15) scaleMode:SDImageScaleModeFill];
    if([title isEqualToString:ASLocalizedString(@"更多")])
    {
        [button setImage:[UIImage imageNamed:@"国旗更多"] forState:UIControlStateNormal];
    }
    else
    {
        [button sd_setImageWithURL:[NSURL URLWithString:SafeStr(imageName)] forState:UIControlStateNormal placeholderImage:nil options:0 context:@{SDWebImageContextImageTransformer: transformer}];
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#8E8E8E"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    return button;
}

- (void)handleCountryEvent:(QMUIButton *)sender {
    NSDictionary *country = [sender qmui_getBoundObjectForKey:@"country"];
    if (self.countryBlock) {
        self.countryBlock(country);
        NSLog(@"%@", country);
    }
}

@end
