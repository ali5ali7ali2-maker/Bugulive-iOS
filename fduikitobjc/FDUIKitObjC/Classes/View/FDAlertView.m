//
//  FDAlertView.m
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/27.
//

#import "FDAlertView.h"
#import "FDAction.h"
#import "FDUIDefine.h"
#import "FDUIColorDefine.h"
#import "UIView+FD.h"
#import <YYKit/YYKit.h>
#import <FDFoundationObjC/FDFoundationObjC.h>

@interface FDAlertView ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, assign) CGFloat bottomY;
@property(nonatomic, strong) NSMutableArray *actionArray;

@property(nonatomic, strong) UIView *bottomLineView;
@property(nonatomic, strong) UIView *marginView;

@end

@implementation FDAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    if (self = [super initWithFrame:CGRectMake(40, FD_ScreenHeight, FD_ScreenWidth - 80, 1)]) {
        self.backgroundColor = FD_WhiteColor;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.titleLabel.text = title;
        [self.contentLabel setText:message];
        if (title.length) {
            [self addSubview:self.titleLabel];
        }
        if (message.length) {
            [self addSubview:self.contentLabel];
        }
        
        self.contentLabel.frame = CGRectMake(10, title.length ? _titleLabel.fd_bottom : 35, self.fd_width - 20, [message fd_textSizeIn:CGSizeMake(self.fd_width - 20, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height + 20);
        self.bottomY = self.contentLabel.fd_bottom + 20;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message{
    if (self = [super initWithFrame:CGRectMake(40, FD_ScreenHeight, FD_ScreenWidth - 80, 1)]) {
        self.backgroundColor = FD_WhiteColor;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        [self.imageView setImage:image];
        [self addSubview:self.imageView];
        self.titleLabel.text = title;
        [self.contentLabel setText:message];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        self.contentLabel.frame = CGRectMake(10, _titleLabel.fd_bottom, self.fd_width - 20, [message fd_textSizeIn:CGSizeMake(self.fd_width - 20, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height + 20);
        self.bottomY = self.contentLabel.fd_bottom + 20;
    }
    return self;
}

- (void)addAction:(FDAction *)action{
    [self.actionArray addObject:action];
}

- (void)onClick:(UIButton *)sender{
    NSLog(@"FDAlertView:点击了%@",sender.titleLabel.text);
    FDAction *action = self.actionArray[sender.tag -100];
    if (action.fd_handleAction) {
        action.fd_handleAction();
    }
    [self hide];
}

- (void)show:(UIView *)superView{
    for (NSInteger i = 0; i < self.actionArray.count; i++) {
        CGFloat buttonWidth = self.width / self.actionArray.count;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonWidth * i, self.bottomY, buttonWidth, 40)];
        FDAction *action = self.actionArray[i];
        [button setTitle:action.title forState:UIControlStateNormal];
        if (action.type == FDActionTypeDefault) {
            [button setTitleColor:[UIColor colorWithHexString:@"#9152F8"] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:button];
    }
    self.bounds = CGRectMake(0, 0, self.fd_width, self.bottomY + 40);
    [self addSubview:self.bottomLineView];
    if (self.actionArray.count > 1) {
        [self addSubview:self.marginView];
    }
    [super show:superView type:FDPopTypeCenter];
}

- (NSMutableArray *)actionArray{
    if (!_actionArray) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((FD_ScreenWidth - 80 - 40 ) / 2, 25, 40, 40)];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.image ? self.imageView.bottom + 10 : 20, self.fd_width, 22)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _titleLabel.fd_bottom + 20, self.fd_width - 20, 20)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _contentLabel;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 40, self.width, 0.5)];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return _bottomLineView;
}

- (UIView *)marginView{
    if (!_marginView) {
        _marginView = [[UIView alloc]initWithFrame:CGRectMake(self.width / 2 - 0.5, self.height - 40, 0.5, self.width / 2)];
        _marginView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return _marginView;
}

@end
