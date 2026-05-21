//
//  BogoRechargePayCollection.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargePayMoneyCollection.h"
#import "BogoRechargePayMoneyCell.h"

@implementation BogoRechargePayMoneyCollection

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    
    [self addSubview:self.titleL];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.headerReferenceSize=CGSizeMake(kScreenW, kRealValue(166));//头视图的大小

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.titleL.bottom, kScreenW, self.height - self.titleL.bottom) collectionViewLayout:layout];
    _collectionView.tag = 1107;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kWhiteColor;
    [_collectionView registerNib:[UINib nibWithNibName:@"BogoRechargePayMoneyCell" bundle:nil] forCellWithReuseIdentifier:@"BogoRechargePayMoneyCell"];
    _collectionView.scrollEnabled = NO;
    
    [self addSubview:self.collectionView];
}

- (void)setModel:(AccountRechargeModel *)model{
    _model = model;
    self.listArr = [NSMutableArray arrayWithArray:model.rule_list];
    for (int i = 0; i < self.listArr.count; i++) {
        PayMoneyModel *model = self.listArr[i];
        model.isSelect = NO;
        if (i == 0) model.isSelect = YES;
        
        [self.listArr replaceObjectAtIndex:i withObject:model];
        
    }
    self.selectModel = self.listArr.firstObject;
    self.collectionView.height = kRealValue(70) * (self.listArr.count / 3 + 1) + kRealValue(40);
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoRechargePayMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoRechargePayMoneyCell" forIndexPath:indexPath];
    
    cell.model = self.listArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PayMoneyModel *selectModel = self.listArr[indexPath.row];
    selectModel.isSelect = YES;
    
    for (int i = 0; i < self.listArr.count; i++) {
        PayMoneyModel *model = self.listArr[i];

        model.isSelect = NO;
        if (selectModel.payID == model.payID) {
            selectModel.isSelect = YES;
            [self.listArr replaceObjectAtIndex:i withObject:selectModel];
        }
    }
    self.selectModel = selectModel;
    
    [self.collectionView reloadData];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    return CGSizeMake((kScreenW-11 * 2 - 12 * 2)/3, kRealValue(70));
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(15), -8, kScreenW * 0.6, kRealValue(40))];
        _titleL.text = ASLocalizedString(@"请选择支付金额");
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleL;
}

@end
