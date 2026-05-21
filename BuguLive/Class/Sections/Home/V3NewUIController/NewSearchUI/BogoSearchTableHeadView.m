//
//  BogoSearchTableHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchTableHeadView.h"
#import "BogoSearchHistoryCell.h"
#import "SHomePageVC.h"
@implementation BogoSearchTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        [self setModel];
        
    }
    return self;
}

-(void)setUpView{
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), kRealValue(10), kScreenW / 2, kRealValue(20))];
    titleL.text =ASLocalizedString( @"浏览历史");
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleL = titleL;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, titleL.bottom + kRealValue(5), kScreenW, kRealValue(100)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = kWhiteColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"BogoSearchHistoryCell" bundle:nil] forCellWithReuseIdentifier:@"BogoSearchHistoryCell"];
    [self addSubview:titleL];
    [self addSubview:self.collectionView];
}

-(void)setModel{
    
    self.listArr = [NSMutableArray array];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"user_record" forKey:@"act"];
    [parmDict setObject:[BGIMLoginManager sharedInstance].loginParam.identifier forKey:@"uid"];
    
    [parmDict setObject:@"0" forKey:@"page"];
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             
             
             NSArray *recommandArr = [NSArray modelArrayWithClass:[LivingModel class] json:[responseJson objectForKey:@"data"]];
//             [responseJson objectForKey:@"data"];
            
             [self.listArr addObjectsFromArray:recommandArr];
//             if (recommandArr && [recommandArr isKindOfClass:[NSArray class]])
//             {
//                 if (recommandArr.count > 0)
//                 {
//                     for (NSDictionary *dict in recommandArr)
//                     {
//                         LivingModel *model = [LivingModel mj_objectWithKeyValues:dict];
////                         model.xponit = [dict toFloat:@"xpoint"];
////                         model.yponit = [dict toFloat:@"ypoint"];
//                         [self.listArr addObject:model];
//                     }
//                 }
//             }
             [_collectionView reloadData];
         }
         [BGMJRefreshManager endRefresh:_collectionView];
         
     } FailureBlock:^(NSError *error)
     {
         [BGMJRefreshManager endRefresh:_collectionView];
    }];
}



#pragma mark UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
//    FWNewEstTab_Count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0, 50);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BogoSearchHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoSearchHistoryCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    cell.model = self.listArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LivingModel *model = self.listArr[indexPath.row];
    
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = model.id;
    tmpController.type = 0;

//    BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:tmpController];
    
    [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(kRealValue(80), kRealValue(120));
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



@end
