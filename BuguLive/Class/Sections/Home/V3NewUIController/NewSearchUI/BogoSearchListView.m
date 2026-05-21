//
//  BogoSearchTableView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchListView.h"

static NSString const *kBogoSearchHeadView = @"kBogoSearchHeadView";

@implementation BogoSearchListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        [self setUpView];
        [self setModel];
    }
    return self;
}

-(void)setUpView{
    
    BogoSearchTableHeadView *headView = [[BogoSearchTableHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(160))];
    _headView = headView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize=CGSizeMake(kScreenW, kRealValue(166));//头视图的大小

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kWhiteColor;
//    [_collectionView registerClass:[BogoSearchTableHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BogoSearchTableHeadView"];
    [_collectionView registerClass:[BogoSearchTableHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:NSStringFromClass([BogoSearchTableHeadView class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
    
    
    [self addSubview:self.collectionView];
    
    
    
    
}

-(void)setModel{
    
    self.listArr = [NSMutableArray array];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"index" forKey:@"act"];
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
            
             NSArray *recommandArr = [responseJson objectForKey:@"recommend_list"];
            
             if (recommandArr && [recommandArr isKindOfClass:[NSArray class]])
             {
                 if (recommandArr.count > 0)
                 {
                     for (NSDictionary *dict in recommandArr)
                     {
                         LivingModel *model = [LivingModel mj_objectWithKeyValues:dict];
                         model.xponit = [dict toFloat:@"xpoint"];
                         model.yponit = [dict toFloat:@"ypoint"];
                         [self.listArr addObject:model];
                     }
                 }
             }
             [_collectionView reloadData];
             
//             [self hideNoContentView];
         }
         [BGMJRefreshManager endRefresh:_collectionView];
         
     } FailureBlock:^(NSError *error)
     {
         [BGMJRefreshManager endRefresh:_collectionView];
    }];
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        if (indexPath.section == 0) {
            BogoSearchTableHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BogoSearchTableHeadView class]) forIndexPath:indexPath];
            
            UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), self.headView.height - kRealValue(20), kScreenW / 2, kRealValue(20))];
            titleL.text =ASLocalizedString( @"热门直播");
            titleL.font = [UIFont systemFontOfSize:16];
            titleL.textColor = [UIColor colorWithHexString:@"#333333"];
            [header addSubview:titleL];
            return header;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewestItemCell" forIndexPath:indexPath];
    
    if (_listArr.count > 0) {
        LivingModel *LModel = _listArr[indexPath.row];
        [cell setCellContent:LModel Type:[@"1" intValue]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LivingModel *LModel = _listArr[indexPath.row];
    [self clickLivingModel:LModel];
}

#pragma mark NewestViewController跳转到直播

-(void)clickLivingModel:(LivingModel *)model{

    if (![BGUtils isNetConnected])
    {
        return;
    }
    
//    [self.BuguLive.newestLivingMArray removeAllObjects];
//    [self.BuguLive.newestLivingMArray addObject:model];
    
    if ([self checkUser:[IMAPlatform sharedInstance].host])
    {
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
        //点击左边主播
        
        item.chatRoomId = model.group_id;
        item.avRoomId = model.room_id;
        item.title = [NSString stringWithFormat:@"%d",model.room_id];
        item.vagueImgUrl = model.head_image;

        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = model.user_id;
        showUser.avatar = model.head_image;
        item.host = showUser;
        item.is_voice = model.is_voice;

        item.liveType = FW_LIVE_TYPE_AUDIENCE;
        
        
        //2020-1-7 小直播变大
        [LiveCenterManager sharedInstance].itemModel=item;
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item modelArr:nil isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL isFinished) {

        }];
    }
    else
    {
        [[BGHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
    }
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((kScreenW-30)/2.0f, (kScreenW-30) / 2.0f + kRealValue(30));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
   
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

@end
