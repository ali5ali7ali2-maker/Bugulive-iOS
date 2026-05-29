//
//  RoomFaceCell.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/27.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomFaceCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "RoomFaceModel.h"

@interface RoomFaceCell ()

@property(nonatomic, strong) FLAnimatedImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation RoomFaceCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(RoomFaceModel *)model{
    _model = model;
    

    [self.imageView setImageURL:[NSURL URLWithString:model.img]];
    
    [self.titleLabel setText:model.name];
}

- (FLAnimatedImageView *)imageView{
    if (!_imageView) {
//        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"]]];
        _imageView = [[FLAnimatedImageView alloc] init];
//        imageView.animatedImage = image;
        _imageView.frame = CGRectMake(self.width / 4, 15, self.width / 2, self.width / 2);
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom + 5, self.width, 15)];
        _titleLabel.textColor = [UIColor qmui_colorWithHexString:@"#CCCCCC"];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
