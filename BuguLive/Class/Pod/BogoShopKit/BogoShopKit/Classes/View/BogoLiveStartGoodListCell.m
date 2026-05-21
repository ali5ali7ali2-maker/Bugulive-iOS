//
//  BogoLiveStartGoodListCell.m
//  BuGuDY
//
//  Created by bogokj on 2020/3/27.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "BogoLiveStartGoodListCell.h"
#import "BogoShopKit.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BogoLiveStartGoodListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *numberImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

//@property (weak, nonatomic) IBOutlet UIButton *inBtn;
//@property (weak, nonatomic) IBOutlet QMUIButton *sayBtn;
@end

@implementation BogoLiveStartGoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //动画图片
    NSMutableArray *arr = [NSMutableArray array];
    
    NSString *imageName1 = @"shop_live_say1";
    NSString *imageName2 = @"shop_live_say1@2x";
    NSString *imageName3 = @"shop_next";
    NSString *imageName4 = @"shop_order_bottom_bg@2x";
    
    
    
    NSLog(@"%@",imageNamed(imageName1));
    NSLog(@"%@",imageNamed(imageName2));
    NSLog(@"%@",imageNamed(imageName3));
    NSLog(@"%@",imageNamed(imageName4));
    
//    for (int i = 1; i < 10; i ++) {
//        NSString *imageName = [NSString stringWithFormat:@"shop_live_say%d",i];
//        [arr addObject:imageNamed(imageName)];
//    }
//    self.inBtn.imageView.image = arr.firstObject;
//    self.inBtn.imageView.animationImages = arr;
    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)
//    self.inBtn.imageView.animationDuration = 2;
//    self.inBtn.imageView.animationRepeatCount = 0;//动画进行几次结束
//    [self.inBtn.imageView startAnimating];//开始动画
}

- (void)setType:(BogoLiveStartGoodListCellType)type{
    _type = type;
    self.numberImageView.hidden = type == BogoLiveStartGoodListCellTypeAdd;
    self.numberLabel.hidden = type == BogoLiveStartGoodListCellTypeAdd;
    
    if (type == BogoLiveStartGoodListCellTypeList) {
        self.sayBtn.hidden = NO;
        self.inBtn.hidden = NO;
    }else{
        self.sayBtn.hidden = YES;
        self.inBtn.hidden = YES;
    }

    self.shopAddBtn.hidden = YES;

    if (type == BogoLiveStartGoodListCellTypeAdd) {
        [self.operateBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.operateBtn setTitle:@"已添加" forState:UIControlStateSelected];
        self.countLabel.hidden = NO;
    }else if (type == BogoLiveStartGoodListCellTypeList){
        self.operateBtn.selected = YES;
        [self.operateBtn setTitle:@"移除" forState:UIControlStateNormal];
        [self.operateBtn setTitle:@"移除" forState:UIControlStateSelected];
//        [self.operateBtn setTitle:@"上架" forState:UIControlStateSelected];
        self.countLabel.hidden = NO;
    }else{
        self.operateBtn.selected = NO;
        [self.operateBtn setTitle:@"去抢购" forState:UIControlStateNormal];
        [self.operateBtn setTitle:@"去抢购" forState:UIControlStateSelected];
        self.countLabel.hidden = YES;
    }
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];
    
    NSString *price = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, @"￥".length)];
    [self.priceLabel setAttributedText:attr];
    
//    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue/100]];
    
    
    
    
    [self.countLabel setText:[NSString stringWithFormat:@"库存 %@",model.stock_total]];
    if (_type == BogoLiveStartGoodListCellTypeAdd) {
        self.operateBtn.selected = model.is_live_shop;
    }
    
    [self.sayBtn setTitle:@"开始讲解" forState:UIControlStateNormal];
    [self.sayBtn setTitle:@"取消讲解" forState:UIControlStateSelected];
    //商品是否讲解中
    if (model.is_live) {
        self.inBtn.hidden = NO;
        
        self.sayBtn.selected = YES;
    }else{
        self.inBtn.hidden = YES;
//        [self.sayBtn setTitle:@"开始讲解" forState:UIControlStateNormal];
        self.sayBtn.selected = NO;
        
    }
    
    if (self.type == BogoLiveStartGoodListCellTypeForUser || self.type == BogoLiveStartGoodListCellTypeList) {
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue/100]];
        
    }
    
}

- (void)setRow:(NSInteger)row{
    _row = row;
    [self.numberLabel setText:[NSString stringWithFormat:@"%02ld",row]];
}

- (IBAction)operateBtnAction:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickOperateBtn:)]){
        [self.delegate listCell:self didClickOperateBtn:sender];
    }
}

- (IBAction)sayBtnAction:(QMUIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickSayBtn:)]) {
        [self.delegate listCell:self didClickSayBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
