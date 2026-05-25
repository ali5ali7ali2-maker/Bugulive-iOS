//
//  BogoDTHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoDTHeadView.h"
#import "BogoDTHeadCell.h"
#import "BGTopicTimeLineListController.h"

@implementation BogoDTHeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUpView];
}

-(void)setUpView{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BogoDTHeadCell" bundle:nil] forCellWithReuseIdentifier:@"BogoDTHeadCell"];
    self.collectionView.backgroundColor = kClearColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(void)resetTopicModel:(NSArray *)arr{
    self.listArr = [NSMutableArray arrayWithArray:arr];
    [self.collectionView reloadData];
//    for (int i = 0; i < 4; i ++) {
//        if (i > 4) return;
//        MGNewDTHeadControl *control = [self.topicView viewWithTag:100 + i];
//
//        if(arr.count > i)
//        {
//            [control resetControlModel:arr[i]];
//            //给有数据的view添加手势
//            [control addTarget:self action:@selector(MGNewDTHeadAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoDTHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoDTHeadCell" forIndexPath:indexPath];
    cell.backgroundColor = kClearColor;
    [cell resetControlModel:self.listArr[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
//                if (self.logic.topicArr.count > index - 1) {
    pushVC.topic = self.listArr[indexPath.row];
//                    self.logic.topicArr[index];
    [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return CGSizeMake((kScreenW-30)/2.0f, (kScreenW-30) / 2.0f + kRealValue(30));
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//   
//    return 0;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 0, 10);
//}


@end
