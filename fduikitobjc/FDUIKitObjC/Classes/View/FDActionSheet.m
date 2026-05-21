//
//  FDActionSheet.m
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/27.
//

#import "FDActionSheet.h"
#import "FDAction.h"
#import "FDUIDefine.h"
#import "FDUIColorDefine.h"
#import "UIView+FD.h"
#import <YYKit/YYKit.h>
#import <FDFoundationObjC/FDFoundationObjC.h>

@interface FDActionSheet ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIView *bottomLineView;
@property(nonatomic, assign) CGFloat bottomY;
@property(nonatomic, strong) NSMutableArray *actionArray;

@end

@implementation FDActionSheet

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    if (self = [super initWithFrame:CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, 1)]) {
        self.backgroundColor = FD_WhiteColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        if (title.length) {
            self.titleLabel.text = title;
            [self addSubview:self.titleLabel];
            self.titleLabel.frame = CGRectMake(10, 0, self.fd_width - 20, [title fd_textSizeIn:CGSizeMake(self.width - 20, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height + 20);
            self.bottomLineView.fd_top = self.titleLabel.fd_bottom - 1;
            self.bottomY = self.titleLabel.fd_bottom;
        }
        if (message.length){
            self.contentLabel.text = message;
            [self addSubview:self.contentLabel];
            self.contentLabel.frame = CGRectMake(10, _titleLabel.fd_bottom, self.fd_width - 20, [message fd_textSizeIn:CGSizeMake(self.fd_width - 20, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height + 20);
            self.bottomLineView.fd_top = self.contentLabel.fd_bottom - 1;
            self.bottomY = self.contentLabel.fd_bottom;
        }
    }
    return self;
}

- (void)addAction:(FDAction *)action{
    [self.actionArray addObject:action];
}

- (void)onClick:(UIButton *)sender{
    NSLog(@"FDActionSheet:点击了%@",sender.titleLabel.text);
    FDAction *action = self.actionArray[sender.tag -100];
    if (action.fd_handleAction) {
        action.fd_handleAction();
    }
    [self hide];
}

- (void)show:(UIView *)superView{
    for (NSInteger i = 0; i < self.actionArray.count; i++) {
        if (i == self.actionArray.count - 1) {
            UIView *spiltView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bottomY, self.fd_width, 3)];
            spiltView.backgroundColor = self.backColor ? self.backColor : [UIColor colorWithHexString:@"#F1F1F1"];
            [self addSubview:spiltView];
            self.bottomY += 1.5;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bottomY, self.fd_width, 50)];
        FDAction *action = self.actionArray[i];
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor ? self.titleColor : [UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setBackgroundColor:self.backColor ? self.backColor : FD_WhiteColor];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [self addSubview:button];
        self.bottomY += 50;
    }
    if (@available(iOS 11.0, *)) {
        self.bounds = CGRectMake(0, 0, self.fd_width, self.bottomY + FD_Bottom_SafeArea_Height);
    } else {
        // Fallback on earlier versions
        self.bounds = CGRectMake(0, 0, self.fd_width, self.bottomY);
    }
    [super show:superView type:FDPopTypeBottom];
}

- (NSMutableArray *)actionArray{
    if (!_actionArray) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.fd_width, 45)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.backgroundColor = FD_WhiteColor;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _titleLabel.fd_bottom, self.fd_width - 20, 20)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _contentLabel.backgroundColor = FD_WhiteColor;
    }
    return _contentLabel;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bottomY, self.fd_width, 0.5)];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#CACACA"];
    }
    return _bottomLineView;
}

@end
