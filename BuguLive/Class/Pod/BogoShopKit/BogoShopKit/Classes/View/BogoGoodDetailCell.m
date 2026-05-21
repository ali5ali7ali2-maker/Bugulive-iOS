//
//  BogoGoodDetailCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoGoodDetailCell.h"
#import "BogoCommodityDetailModel.h"
#import "FDUIKitObjC.h"
#import "UIImageView+WebCache.h"

@interface BogoGoodDetailCell ()

@property(nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation BogoGoodDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    for (UIView *subView in self.imageViewArray) {
        [subView removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    
    UILabel *infoL = [UILabel new];
    infoL.text = model.info;
    infoL.font = [UIFont systemFontOfSize:14];
    infoL.numberOfLines = 0;
    infoL.frame = CGRectMake(10, 44 + 10, FD_ScreenWidth - 10 * 2, 100);
    [self.contentView addSubview:infoL];
    
    infoL.fd_height = [self getLabelHeightWithText:infoL.text width:infoL.fd_width font:14];
    NSMutableArray *imageUrlArray = [NSMutableArray arrayWithArray:[model.info_images componentsSeparatedByString:@","]];
    while ([imageUrlArray containsObject:@""]) {
        [imageUrlArray removeObject:@""];
    }
    
    if (imageUrlArray.count < 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didFinishLoad:)]) {
            [self.delegate detailCell:self didFinishLoad:infoL.fd_height + 15 + 20];
        }
        return;
    }
    
    for (NSInteger i = 0; i < imageUrlArray.count; i++) {
        NSString *url = imageUrlArray[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, infoL.fd_bottom + 15, FD_ScreenWidth, 1)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                CGSize size = image.size;
                size = CGSizeMake(FD_ScreenWidth, size.height * FD_ScreenWidth / size.width);
                [self.dict setObject:@(size.height) forKey:[NSString stringWithFormat:@"index%ld",i]];
                if (self.dict.allKeys.count == imageUrlArray.count) {
                    CGFloat offsetY = infoL.fd_bottom;
                    for (UIImageView *imageView in self.imageViewArray) {
                        imageView.fd_height = [self.dict[[NSString stringWithFormat:@"index%ld",[self.imageViewArray indexOfObject:imageView]]] floatValue];
                        imageView.fd_top = offsetY;
                        offsetY = imageView.fd_top + imageView.fd_height;
                    }
                    CGFloat height = 0;
                    for (NSNumber *value in self.dict.allValues) {
                        height = height + value.floatValue;
                    }
                    height = infoL.fd_height + height;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didFinishLoad:)]) {
                        [self.delegate detailCell:self didFinishLoad:height];
                    }
                }
            }
        }];
    }
}

- (void)imageViewAction:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    NSInteger index = [self.imageViewArray indexOfObject:imageView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didClickInfoImage:)]) {
        [self.delegate detailCell:self didClickInfoImage:index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}


//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}


@end
