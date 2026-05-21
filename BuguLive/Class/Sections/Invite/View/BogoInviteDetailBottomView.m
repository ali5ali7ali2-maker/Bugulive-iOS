//
//  BogoInviteDetailBottomView.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteDetailBottomView.h"
#import "BogoInviteWithDrawResponseModel.h"
#import "BogoInviteWithDrawItemCell.h"

@interface BogoInviteDetailBottomView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation BogoInviteDetailBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 98 + 15, kScreenW, 328);
    [self.collectionView registerNib:[UINib nibWithNibName:@"BogoInviteWithDrawItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BogoInviteWithDrawItemCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setModel:(BogoInviteWithDrawResponseModel *)model{
    _model = model;
    [self.collectionView reloadData];
    self.authLabel.text = model.data.alipay_name.length ?ASLocalizedString( @"已绑定") :ASLocalizedString( @"未绑定");
    self.authLabel.textColor = [UIColor colorWithHexString:model.data.alipay_name.length ? @"#57A8FF" : @"#F52F03"];
}

- (IBAction)authBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickAuthBtn:)]) {
        [self.delegate bottomView:self didClickAuthBtn:sender];
    }
}

- (IBAction)withDrawBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickWithDrawBtn:)]) {
        [self.delegate bottomView:self didClickWithDrawBtn:sender];
    }
}

- (IBAction)agreementBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickAgreementBtn:)]) {
        [self.delegate bottomView:self didClickAgreementBtn:sender];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoInviteWithDrawItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoInviteWithDrawItemCell" forIndexPath:indexPath];
    if (indexPath.item < self.model.list.count) {
        cell.model = self.model.list[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(floor((kScreenW - 50) / 3), 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoInviteWithDrawResponseModelList *model = self.model.list[indexPath.item];
    for (BogoInviteWithDrawResponseModelList *subModel in self.model.list) {
        subModel.selected = model == subModel;
    }
    self.selectModel = model;
    [collectionView reloadData];
}

@end
