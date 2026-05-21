//
//  BogoGoodDetailAttrPopView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoGoodDetailAttrPopView.h"
#import "UIImageView+WebCache.h"
#import "FDUIKitObjC.h"
#import "BogoCommodityDetailModel.h"
#import "BogoGoodDetailAttrCell.h"
#import "BogoShopKit.h"
#import "FDFoundationObjC.h"

@interface BogoGoodDetailAttrPopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *attrCollectionView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *attrLabel;

@end

@implementation BogoGoodDetailAttrPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    if (@available(iOS 11.0, *)) {
        self.frame = CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, 370 + FD_Bottom_SafeArea_Height);
    } else {
        // Fallback on earlier versions
        self.frame = CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, 370);
    }
    self.attrCollectionView.delegate = self;
    self.attrCollectionView.dataSource = self;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    
//    [self collectionView:self.attrCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (model.attr.count) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        
        NSString *price = [NSString stringWithFormat:@"￥%.2f",model.attr[0].price.floatValue / 100];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
        [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, @"￥".length)];
        [self.priceLabel setAttributedText:attr];
        
//        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.attr[0].price.floatValue/100]];
        
        [self.countLabel setText:[NSString stringWithFormat:@"库存:%@",model.attr[0].stock]];
        [self.attrCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodDetailAttrCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoGoodDetailAttrCell class])];
        [self.attrCollectionView reloadData];
        if (self.model.selectAttrIndex != -1) {
            
            NSString *price = [NSString stringWithFormat:@"￥%.2f",self.model.attr[self.model.selectAttrIndex].price.floatValue/100];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
            [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, @"￥".length)];
            
//            [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",self.model.attr[self.model.selectAttrIndex].price.floatValue/100]];
            [self.countLabel setText:[NSString stringWithFormat:@"库存:%@",self.model.attr[self.model.selectAttrIndex].stock]];
            [self.attrLabel setText:self.model.attr[self.model.selectAttrIndex].name];
            [self.attrCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.model.selectAttrIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }else{
        [[FDHUDManager defaultManager] show:@"未添加规格" ToView:[UIApplication sharedApplication].keyWindow];
    }
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self hide];
}

- (IBAction)minusBtnAction:(id)sender {
    if (_model.selectAttrIndex == -1) {
        [[FDHUDManager defaultManager] show:@"未选择规格" ToView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    NSInteger value = self.numberLabel.text.integerValue - 1;
    if (value == 0) {
        return;
    }
    _model.count = value;
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld",value]];
}

- (IBAction)plusBtnAction:(id)sender {
    if (_model.selectAttrIndex == -1) {
        [[FDHUDManager defaultManager] show:@"未选择规格" ToView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    NSInteger value = self.numberLabel.text.integerValue + 1;
    if (value > _model.attr[_model.selectAttrIndex].stock.integerValue) {
        return;
    }
    _model.count = value;
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld",value]];
}

- (IBAction)addCartBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickAddCartBtn:)]) {
        [self.delegate popView:self didClickAddCartBtn:sender];
    }
}

- (IBAction)buyBtnAction:(id)sender {
    if (self.model.selectAttrIndex < 0) {
        return;
    }
    if (!self.model.attr[self.model.selectAttrIndex].stock.integerValue) {
        [[FDHUDManager defaultManager] show:@"库存不足" ToView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickBuyBtn:)]) {
        [self.delegate popView:self didClickBuyBtn:sender];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.attr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoGoodDetailAttrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoGoodDetailAttrCell class]) forIndexPath:indexPath];
    [cell setModel:_model.attr[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoCommodityDetailAttrModel *model = _model.attr[indexPath.item];
    return CGSizeMake([model.name fd_textSizeIn:CGSizeMake(FD_ScreenWidth - 30, 30) font:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]].width + 20, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.selectAttrIndex == indexPath.item) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        self.model.selectAttrIndex = -1;
        [self.attrLabel setText:@""];
    }else{
        self.model.selectAttrIndex = indexPath.item;
        if (self.model.attr.count > 0) {
            [self.attrLabel setText:self.model.attr[indexPath.item].name];
        }
    }
    
    if (self.model.attr.count > 0) {
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",self.model.attr[indexPath.item].price.floatValue/100]];
        [self.countLabel setText:[NSString stringWithFormat:@"库存:%@",self.model.attr[indexPath.item].stock]];
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
