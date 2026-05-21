//
//  BogoLiveGoodThingsCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoLiveGoodThingsCell.h"
#import "BogoLiveGoodThingsGoodCell.h"
#import "BogoShopKit.h"
#import "FDUIKitObjC.h"
#import <NAKPlaybackIndicatorView/NAKPlaybackIndicatorView.h>
#import <YYKit/YYKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BogoLiveGoodThingItemModel.h"

@interface BogoLiveGoodThingsCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NAKPlaybackIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoLiveGoodThingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveGoodThingsGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoLiveGoodThingsGoodCell class])];
    self.seeBtn.layer.borderWidth = 1;
    self.seeBtn.layer.borderColor = [UIColor colorWithHexString:@"#EA2012"].CGColor;
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewAction)]];
}

- (void)iconImageViewAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodThingsCell:didClickUser:)]) {
        [self.delegate goodThingsCell:self didClickUser:self.model.user_id];
    }
}

- (void)setModel:(BogoLiveGoodThingItemModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    self.nameLabel.text = model.nick_name;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人观看",model.max_watch_number];
    [self.dataArray setArray:model.goods];
    [self.collectionView reloadData];
    self.indicatorView.state = NAKPlaybackIndicatorViewStatePlaying;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count > 3 ? 3 : self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveGoodThingsGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoLiveGoodThingsGoodCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor(( FD_ScreenWidth - 60 ) / 3);
    return CGSizeMake(width, width + 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveGoodThingItemModelGoods *model = self.dataArray[indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodThingsCell:didClickGood:)]) {
        [self.delegate goodThingsCell:self didClickGood:model];
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
