//
//  BogoOpenWardCollectionView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoOpenWardCollectionView.h"
#import "BogoOpenWardCollectionCell.h"



@interface BogoOpenWardCollectionView()

@property(nonatomic, assign) NSInteger selectRow;

@end

@implementation BogoOpenWardCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectRow = 0;
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.backgroundColor = kClearColor;
    self.collectionView.scrollEnabled = NO;
    [self addSubview:self.collectionView];
}


-(void)refreshType:(BOGO_OPENWARD_Collection_TYPE)type array:(NSArray *)dataArray{
    _type = type;
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    self.selectRow = 0;
    [self.collectionView reloadData];
}

- (void)refreshTypeNameWithArray:(NSArray *)dataArray{
    
    self.selectRow = 0;
    
    for (int i = 0; i < self.dataArray.count ; i++) {
        
        
        
        BogoWardModel *model = self.dataArray[i];
        model.isSelect = NO;
        
        if (dataArray.count > i) {
            if ([dataArray[i] isEqualToString:model.type]) {
                model.isSelect = YES;
            }
        }
        
        
        
        
        
        [self.dataArray replaceObjectAtIndex:i withObject:model];
        
    }
    [self.collectionView reloadData];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray) {
        return _dataArray.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoOpenWardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoOpenWardCollectionCell" forIndexPath:indexPath];
    
    
    BogoWardModel *model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[NSDictionary class]]) {
        model = [BogoWardModel modelWithDictionary:self.dataArray[indexPath.row]];
    }
    
    [cell.btn setTitle:model.name forState:UIControlStateNormal];
    
    if (self.type == BOGO_OPENWARD_Collection_TYPE_GUARDIANS) {
        cell.btn.spacingBetweenImageAndTitle = 10;
        cell.btn.imagePosition = QMUIButtonImagePositionTop;
        [cell.btn setTitle:[NSString stringWithFormat:ASLocalizedString(@"%@守护"),model.name] forState:UIControlStateNormal];
//        [cell.btn setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal options:YYWebImageOptionShowNetworkActivity];
        
        WeakSelf
        [cell.btn sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(50), kRealValue(18))];
            [cell.btn setImage:image forState:UIControlStateNormal];
        }];
        
        cell.btn.layer.cornerRadius = 5;
        cell.btn.layer.masksToBounds = YES;
        
        if (self.selectRow == indexPath.row) {

            [cell.btn setTitleColor:[UIColor colorWithHexString:@"#9152F8"] forState:UIControlStateNormal];
            cell.btn.backgroundColor = [UIColor colorWithHexString:@"#F6EDFF"];
            
            cell.btn.layer.borderWidth = 1.5f;
            cell.btn.layer.borderColor = [UIColor colorWithHexString:@"#9152F8"].CGColor;
        }else{
            
            [cell.btn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
            cell.btn.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            cell.btn.layer.borderWidth = 0;
        }
        
        
        
    }else if(self.type == BOGO_OPENWARD_Collection_TYPE_PRIVITE){
        
        cell.btn.layer.borderWidth = 0;
        
        cell.btn.spacingBetweenImageAndTitle = 5;
        cell.btn.imagePosition = QMUIButtonImagePositionTop;
        cell.btn.backgroundColor = kClearColor;
        cell.btn.titleLabel.font = [UIFont systemFontOfSize:12];
        if (model.isSelect) {
//            [cell.btn setImageWithURL:[NSURL URLWithString:model.select_icon] forState:UIControlStateNormal options:YYWebImageOptionShowNetworkActivity];
            
            WeakSelf
            [cell.btn sd_setImageWithURL:[NSURL URLWithString:model.select_icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if(!error)
                {
                    image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(40), kRealValue(40))];
                    [cell.btn setImage:image forState:UIControlStateNormal];
                }
                else
                {
                    image = [weakSelf scaleImage:[UIImage imageNamed:@"DefaultImg"] scaleToSize:CGSizeMake(kRealValue(40), kRealValue(40))];
                    [cell.btn setImage:image forState:UIControlStateNormal];

                }

            }];
            
            [cell.btn setTitleColor:[UIColor colorWithHexString:@"#AE2CF1"] forState:UIControlStateNormal];
        }else{
//            [cell.btn setImageWithURL:[NSURL URLWithString:model.default_icon] forState:UIControlStateNormal options:YYWebImageOptionShowNetworkActivity];
            
            WeakSelf
            [cell.btn sd_setImageWithURL:[NSURL URLWithString:model.default_icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(40), kRealValue(40))];
                [cell.btn setImage:image forState:UIControlStateNormal];
                
                if(!error)
                {
                    image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(40), kRealValue(40))];
                    [cell.btn setImage:image forState:UIControlStateNormal];
                }
                else
                {
                    image = [weakSelf scaleImage:[UIImage imageNamed:@"DefaultImg"] scaleToSize:CGSizeMake(kRealValue(40), kRealValue(40))];
                    [cell.btn setImage:image forState:UIControlStateNormal];

                }
                
                
            }];
            
            
            [cell.btn setTitleColor:[UIColor colorWithHexString:@"#AE2CF1"] forState:UIControlStateNormal];
        }
        
    }else if(self.type == BOGO_OPENWARD_Collection_TYPE_TIME){
        
        cell.btn.layer.cornerRadius = 4;
        cell.btn.layer.masksToBounds = YES;
        cell.btn.spacingBetweenImageAndTitle = 5;
        cell.btn.imagePosition = QMUIButtonImagePositionLeft;
        BogoWardPayTimeModel *timeModel = self.dataArray[indexPath.row];
        
        if ([self.dataArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
            timeModel = [BogoWardPayTimeModel modelWithDictionary:self.dataArray[indexPath.row]];
        }
        
        NSString *timeStr = [NSString stringWithFormat:@"%@/%@",timeModel.coin,timeModel.name];
        [cell.btn setTitle:timeStr forState:UIControlStateNormal];
        [cell.btn setImage:[UIImage imageNamed:@"bogo_me_top_diamond"] forState:UIControlStateNormal];
        
        if (self.selectRow == indexPath.row) {

            [cell.btn setTitleColor:[UIColor colorWithHexString:@"#9152F8"] forState:UIControlStateNormal];
            cell.btn.backgroundColor = [UIColor colorWithHexString:@"#F6EDFF"];
            cell.btn.layer.borderWidth = 1.5f;
            cell.btn.layer.borderColor = [UIColor colorWithHexString:@"#9152F8"].CGColor;
        }else{
            
            [cell.btn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
            cell.btn.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            cell.btn.layer.borderWidth = 0;
        }
        
        
    }
    
    
    cell.btn.selected = model.isSelect;
    
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == BOGO_OPENWARD_Collection_TYPE_PRIVITE) {
        return;
    }
    
    self.selectRow = indexPath.row;
    
    //点击守护
    if (self.selectRowBlock && self.type == BOGO_OPENWARD_Collection_TYPE_GUARDIANS) {
        self.selectRowBlock(self.dataArray[indexPath.row]);
    }
    //点击时长
    if (self.selectTimeCollectionViewRowBlock && self.type == BOGO_OPENWARD_Collection_TYPE_TIME) {
        self.selectTimeCollectionViewRowBlock(self.dataArray[indexPath.row]);
    }
    
    [self.collectionView reloadData];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.type == BOGO_OPENWARD_Collection_TYPE_GUARDIANS) {

        CGFloat cellWidth = ceil((self.collectionView.width/3 - 42/3.0)) ;

        return CGSizeMake(cellWidth, (78));
    }else if (self.type == BOGO_OPENWARD_Collection_TYPE_PRIVITE) {
        

//        CGFloat cellWidth = ceil((self.collectionView.width/4 - 30/3.0)) ;

        return CGSizeMake(ceil(self.collectionView.width/4 - 20), (78));
        
//        return CGSizeMake((self.width - (10 * 3 + 10 * 2)) / 4, (75));
    }
    
    return CGSizeMake((self.width - (12 * 2 + 10)) / 2, (40));

}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (self.type == BOGO_OPENWARD_Collection_TYPE_GUARDIANS) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
    else if (self.type == BOGO_OPENWARD_Collection_TYPE_PRIVITE) {
        return UIEdgeInsetsMake(0, 0, 0, 10);
    }
 
    return UIEdgeInsetsMake(0, 10, 0, 10);
}



- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *contentLayout = [[UICollectionViewFlowLayout alloc] init];

        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:contentLayout];
        _collectionView.backgroundColor = kClearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"BogoOpenWardCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BogoOpenWardCollectionCell"];
    }
    return _collectionView;
}

- (UIImage*)scaleImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end

