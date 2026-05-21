//
//  BogoPkAudienceView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/22.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoPkAudienceView.h"


#import "BogoPKAudienceCell.h"

@implementation BogoPkAudienceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kRealValue(26), kRealValue(26));
    layout.sectionInset = UIEdgeInsetsMake(5, 15, 0, 10);
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 10;
    
    
    self.leftCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kRealValue(15), 0, kScreenW / 2, kRealValue(36)) collectionViewLayout:layout];
    self.leftCollectionView.delegate = self;
    self.leftCollectionView.dataSource = self;
    self.leftCollectionView.backgroundColor = kClearColor;
    [self.leftCollectionView registerNib:[UINib nibWithNibName:@"BogoPKAudienceCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BogoPKAudienceCell"];
    
    
    self.rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenW / 2 + kRealValue(40), 0, kScreenW / 2, kRealValue(36)) collectionViewLayout:layout];
    self.rightCollectionView.backgroundColor = kClearColor;
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
    [self.rightCollectionView registerNib:[UINib nibWithNibName:@"BogoPKAudienceCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BogoPKAudienceCell"];
    
    [self addSubview:self.leftBGImgView];
    [self addSubview:self.rightBGImgView];
    
    [self addSubview:self.leftCollectionView];
    [self addSubview:self.rightCollectionView];
    
    [self.leftCollectionView addSubview:self.leftWinImg];
    [self.rightCollectionView addSubview:self.rightWinImg];
    
    
    [self addSubview:self.pkImgView];
    self.pkImgView.centerX = kScreenW / 2;
    self.pkImgView.centerY = self.leftCollectionView.centerY;
}



- (void)setModel:(BogoPkProgressModel *)model{
    
    self.leftArr = [NSMutableArray array];
    self.rightArr = [NSMutableArray array];
    
    
    
    if ([self.room_id isEqualToString:model.room_id1]) {
        [self.leftArr addObjectsFromArray:model.gift_list1];
        
        
        for (int i = 0; i < 3; i ++) {
            if (i + 1 > model.gift_list1.count) {
                BogoPkProgressGiftModel *model = [BogoPkProgressGiftModel new];
                
                
                [self.leftArr addObject:model];
            }
            
            if (i + 1 > model.gift_list2.count) {
                BogoPkProgressGiftModel *model = [BogoPkProgressGiftModel new];
                [self.rightArr addObject:model];
            }
        }
        //右边的数组要放在for循环的后面
        [self.rightArr addObjectsFromArray:model.gift_list2];
    }else{
        [self.leftArr addObjectsFromArray:model.gift_list2];
        
        
        for (int i = 0; i < 3; i ++) {
            if (i + 1 > model.gift_list2.count) {
                BogoPkProgressGiftModel *model = [BogoPkProgressGiftModel new];
                
                
                [self.leftArr addObject:model];
            }
            
            
            if (i + 1 > model.gift_list1.count) {
                BogoPkProgressGiftModel *model = [BogoPkProgressGiftModel new];
                [self.rightArr addObject:model];
            }
        }
        //右边的数组要放在for循环的后面
        [self.rightArr addObjectsFromArray:model.gift_list1];
    }
    
    
    
    [self.leftCollectionView reloadData];
    [self.rightCollectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoPKAudienceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoPKAudienceCell" forIndexPath:indexPath];
    
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
   
    
    
    if (collectionView == self.leftCollectionView) {
        
        BogoPkProgressGiftModel *model = self.leftArr[indexPath.row];
        
        
        if (indexPath.row == 0) {
            
            NSLog(@"indexPath.row == 0000%@",model.head_image);
            
            NSLog(@"self.leftArr[indexPath.row]%@",self.leftArr[indexPath.row]);
        
            
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"bogo_livePK_left_first"]];
            
        
            
            CGPoint cellCenter = attributes.center;
            CGPoint anchorPoint = [collectionView convertPoint:cellCenter toView:self];
            self.leftWinImg.centerX = anchorPoint.x - 10 - self.leftCollectionView.left;
            
        }else if (indexPath.row == 1){
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"bogo_livePK_left_second"]];
            
        }else if (indexPath.row == 2){
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"bogo_livePK_left_third"]];
        }
        
        
        if(model.id.length > 0)
        {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];

        }
        
        if (model.is_noble_mysterious.intValue == 1) {
            cell.imgView.image = kDefaultNobleMysteriousHeadImg;
        }
        
    }else{
        
        BogoPkProgressGiftModel *model = self.rightArr[indexPath.row];
        
        if (indexPath.row == 0) {
            
            
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"bogo_livePK_right_third"]];
            
        }else if (indexPath.row == 1){
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"bogo_livePK_right_second"]];
        }else if (indexPath.row == 2){
            
            CGPoint cellCenter = attributes.center;
            CGPoint anchorPoint = [collectionView convertPoint:cellCenter toView:self];
            self.rightWinImg.centerX = anchorPoint.x + 10 - self.rightCollectionView.left;
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"bogo_livePK_right_first"]];
        }
        
        if (model.is_noble_mysterious.intValue == 1) {
            cell.imgView.image = kDefaultNobleMysteriousHeadImg;
        }
        
        if(model.id.length > 0)
        {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];

        }
        
    }
        
        
    cell.contentView.backgroundColor = kClearColor;
    
//    bogo_livePK_left_first
    
//    bogo_livePK_left_normal
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(UIImageView *)pkImgView{
    if (!_pkImgView) {
        _pkImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(60), kRealValue(28))];
        _pkImgView.image = [UIImage imageNamed:@"bogo_livePK_center"];
        _pkImgView.centerX = kScreenW / 2;
        _pkImgView.centerY = kScreenH / 2;
    }
    return _pkImgView;
}

-(UIImageView *)leftBGImgView{
    if (!_leftBGImgView) {
        _leftBGImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, self.height)];
        _leftBGImgView.image = [UIImage imageNamed:@"bogo_livePK_left_BGView"];
        
    }
    return _leftBGImgView;
}

-(UIImageView *)rightBGImgView{
    if (!_rightBGImgView) {
        _rightBGImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW / 2, 0, kScreenW / 2, self.height)];
        _rightBGImgView.image = [UIImage imageNamed:@"bogo_livePK_right_BGView"];
    }
    return _rightBGImgView;
}


-(UIImageView *)leftWinImg{
    if (!_leftWinImg) {
        _leftWinImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16.8, 14.8)];
        _leftWinImg.image = [UIImage imageNamed:@"bogo_livePK_left_win"];
    }
    return _leftWinImg;
}

-(UIImageView *)rightWinImg{
    if (!_rightWinImg) {
        _rightWinImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13.9, 11.2)];
        _rightWinImg.image = [UIImage imageNamed:@"bogo_livePK_right_win"];
    }
    return _rightWinImg;
}

@end
