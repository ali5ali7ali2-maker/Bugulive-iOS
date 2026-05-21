//
//  BogoLimitedTimeSpikeCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/8.
//

#import "BogoLimitedTimeSpikeCell.h"
#import "BogoShopKit.h"
#import "BogoTitleGradientLayerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BogoLimitedTimeSpikeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property(nonatomic, strong) BogoTitleGradientLayerView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *percentL;//百分比
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end

@implementation BogoLimitedTimeSpikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 4;
    
    
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.layer.cornerRadius = 4;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    if (model.is_platform.integerValue) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:model.title];
    //    NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
    //    [attr insertAttributedString:spaceAttr atIndex:0];
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        self.layerView.nameLabel.text = @"自营";
        
        
        UIImage *image = [self.layerView convertViewToImage];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, -5, image.size.width, image.size.height);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        [attr insertAttributedString:imageAttr atIndex:0];
        self.nameLabel.attributedText = attr;
    }else{
        self.layerView.nameLabel.text = @"商家";
        self.nameLabel.text = model.title;
    }
    if (model.seckill_status.integerValue == 1) {
        
        CGFloat time = [model.seckill_time doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString * str1 = [dateFormatter stringFromDate: detaildate];
        
        self.conditionLabel.text = [NSString stringWithFormat:@"限量%@件 | %@开始",model.seckill_stock,str1];
         self.buyBtn.hidden = self.percentL.hidden = self.progressView.hidden = YES;
        
    }else{
        self.conditionLabel.text = @"";
        self.buyBtn.hidden = self.percentL.hidden = self.progressView.hidden = NO;
        self.progressView.progress = model.snapped_up.doubleValue / 100;
        //已抢光
        if ([model.snapped_up isEqualToString:@"100"]) {
            [self.buyBtn setTitle:@"已抢光" forState:UIControlStateNormal];
            [self.buyBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#C0C0C0"]];
            [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [self.buyBtn setTitle:@"马上抢" forState:UIControlStateNormal];
            [self.buyBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F42416"]];
            [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        self.percentL.text = [NSString stringWithFormat:@"%@%%",model.snapped_up];
        
        
    }
    
    self.percentLeftConstraint.constant = self.progressConstraintWidth.constant + 10;
    
//    self.percentLeftConstraint.constant = [model.snapped_up floatValue] / 100 * self.progressConstraintWidth.constant + 10;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.seckill_peice.floatValue / 100];
//    self.originPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.original_price.floatValue];
    
    
//    self.progressView.progress = [model.snapped_up floatValue] / 100;
    
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",model.original_price.floatValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"#AAAAAA"], NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:[UIColor qmui_colorWithHexString:@"#AAAAAA"]}];
    self.originPriceLabel.attributedText = attrStr;
    
    
}

- (IBAction)buyBtnAction:(UIButton *)sender {
    
    if (self.clickBuyBtnBlock) {
        self.clickBuyBtnBlock(self.model);
    }
    
}



- (BogoTitleGradientLayerView *)layerView{
    if (!_layerView) {
        _layerView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoTitleGradientLayerView class]) owner:nil options:nil].lastObject;
    }
    return _layerView;
}

@end
