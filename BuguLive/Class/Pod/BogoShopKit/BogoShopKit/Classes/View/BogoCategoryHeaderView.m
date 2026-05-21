//
//  BogoCategoryHeaderView.m
//  AFNetworking
//
//  Created by bogokj on 2020/8/11.
//

#import "BogoCategoryHeaderView.h"
#import <Masonry/Masonry.h>

@interface BogoCategoryHeaderView ()

@end

@implementation BogoCategoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(15);
            make.right.bottom.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
