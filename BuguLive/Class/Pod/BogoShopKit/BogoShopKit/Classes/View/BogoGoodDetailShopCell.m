//
//  BogoGoodDetailShopCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoGoodDetailShopCell.h"
#import "UIImageView+WebCache.h"
#import "BogoCommodityDetailModel.h"
#import "BogoGoodDetailShopGoodCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"

@interface BogoGoodDetailShopCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BogoGoodDetailShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodDetailShopGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoGoodDetailShopGoodCell class])];
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.titleLabel setText:model.shop_info.title];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.shop_info.logo]];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.shop_goods_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoGoodDetailShopGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoGoodDetailShopGoodCell class]) forIndexPath:indexPath];
    [cell setModel:self.model.shop_goods_list[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((FD_ScreenWidth - 40 ) / 3, (FD_ScreenWidth - 40 ) / 3 + 58);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopCell:didClickGood:)]) {
        [self.delegate shopCell:self didClickGood:self.model.shop_goods_list[indexPath.item]];
    }
}

- (IBAction)shopBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopCell:didClickShopBtn:)]) {
        [self.delegate shopCell:self didClickShopBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
