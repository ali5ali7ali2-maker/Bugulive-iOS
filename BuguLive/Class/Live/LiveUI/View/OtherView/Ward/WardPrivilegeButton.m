//
//  WardPrivilegeButton.m
//  BuguLive
//
//  Created by 范东 on 2019/2/1.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardPrivilegeButton.h"

@interface WardPrivilegeButton()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WardPrivilegeButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [self.imageView setImage:image];
            self.imageView.size = CGSizeMake(self.width / 2, self.width / 2);
            self.imageView.centerX = self.width / 2;
            self.imageView.bottom = self.titleLabel.top - 10;
        }
    }];
}

- (void)setTitle:(NSString *)title{
    [self.titleLabel setText:title];
    CGSize titleLabelSize = [title textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
    self.titleLabel.size = titleLabelSize;
    self.titleLabel.centerX = self.width / 2;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _imageView.centerX = self.centerX;
        _imageView.top = 10;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom + 10, 0, 0)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.centerX = self.width / 2;
        _titleLabel.bottom = self.height - 20;
    }
    return _titleLabel;
}

@end
