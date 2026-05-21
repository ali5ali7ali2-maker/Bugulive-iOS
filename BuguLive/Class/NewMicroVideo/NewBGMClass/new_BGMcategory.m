//
//  new_BGMcategory.m
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "new_BGMcategory.h"
@implementation new_BGMcategory
- (instancetype)init
{
    self =[super init];
    return self;
}
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource =dataSource;
    self.collectionview.frame =self.bounds;
    [self.collectionview reloadData];
}
#pragma 代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    new_bgmcategoryCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model =[new_bgmcategoryModel mj_objectWithKeyValues:_dataSource[indexPath.item]];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     new_bgmcategoryModel * model =[new_bgmcategoryModel mj_objectWithKeyValues:_dataSource[indexPath.item]];
    if ([_delegate respondsToSelector:@selector(itemSelect:)])
    {
        [_delegate itemSelect:model];
    }
}
#pragma 懒加载
- (UICollectionView *)collectionview
{
    if (!_collectionview)
    {
        CGFloat item_w  =(kScreenW-4) /4;
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing =0;
        layout.minimumInteritemSpacing =0;
        layout.itemSize =CGSizeMake(item_w, item_w);
//        layout.headerReferenceSize =CGSizeMake(kScreenW, 470);
        _collectionview =[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionview.delegate =self;
        _collectionview.dataSource =self;
        [self addSubview:_collectionview];
        [_collectionview registerClass:[new_bgmcategoryCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionview.scrollEnabled =NO;
        _collectionview.backgroundColor =kWhiteColor;
        UIView *fg1 =[[UIView alloc]init]
        ,*fg2 =[[UIView alloc]init];
        [self addSubview:fg1];
        [self addSubview:fg2];
        fg1.backgroundColor =UIColorFromRGB(0xe1e1e1);
        fg2.backgroundColor =UIColorFromRGB(0xe1e1e1);
        [fg1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(self);
            make.height.equalTo(@(1));
        }];
        [fg2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.bottom.equalTo(self);
            make.height.equalTo(@(1));
        }];
    }
    return _collectionview;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
