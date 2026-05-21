//
//  BogoGoodDetailTopCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoGoodDetailTopCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "BogoCommodityDetailModel.h"
#import "FDUIKitObjC.h"
#import "FDFoundationObjC.h"

#import <QMUIKit/QMUIKit.h>

@interface BogoGoodDetailTopCell ()<SDCycleScrollViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *transferLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@end

@implementation BogoGoodDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cycleScrollView.delegate = self;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSArray *imageUrlArray = [_model.images componentsSeparatedByString:@","];
    if (self.delegate && [self.delegate respondsToSelector:@selector(topCell:didClickImage:)]) {
        [self.delegate topCell:self didClickImage:imageUrlArray[index]];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSArray *imageUrlArray = [_model.images componentsSeparatedByString:@","];
    [self.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld",index + 1,imageUrlArray.count]];
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    NSArray *imageUrlArray ;
    if (model.images.length < 1) {
        imageUrlArray = [model.icon componentsSeparatedByString:@","];
    }else{
        imageUrlArray = [model.images componentsSeparatedByString:@","];
    }
    [self.cycleScrollView setImageURLStringsGroup:imageUrlArray];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    [self.indexLabel setText:[NSString stringWithFormat:@"1/%ld",imageUrlArray.count]];
    NSString *price = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, @"￥".length)];
    [self.priceLabel setAttributedText:attr];
    [self.saleCountLabel setText:[NSString stringWithFormat:@"月售:%@",model.sales]];
    [self.titleLabel setText:model.title];
    if (model.free_shipping.floatValue > 0) {

        [self.transferLabel setText:[NSString stringWithFormat:@"运费:%.2f元",model.free_shipping.floatValue / 100]];

    }else{
        [self.transferLabel setText:@"免运费"];
    }
        
    if (model.original_price.floatValue) {
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价￥%.2f",model.original_price.floatValue / 100] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"#AAAAAA"], NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:[UIColor qmui_colorWithHexString:@"#AAAAAA"]}];
        self.originPriceLabel.attributedText = attrStr;
    }
    
    
    
    
    [self.countLabel setText:[NSString stringWithFormat:@"库存:%@",model.stock_total]];
    [self.saleLabel setText:[NSString stringWithFormat:@"%@人已买",model.total_sales]];
}

+ (CGFloat)cellHeightWithModel:(BogoCommodityDetailModel *)model{
    if (model) {
        CGFloat height = 300 + 109 + [model.title fd_textSizeIn:CGSizeMake(FD_ScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]].height;
        return height;
    }
    return 300 + 109 + 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
