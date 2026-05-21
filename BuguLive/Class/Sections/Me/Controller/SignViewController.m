//
//  SignViewController.m
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "SignViewController.h"
#import "SignCollectCell.h"
#import "SignSuccessPopView.h"
#import "SignHeaderCollectReusView.h"
#import "SignFooterCollectReusView.h"

@interface SignViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, assign) BOOL alreadySign;
@property(nonatomic, strong) BGSignModel *model;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}
- (void)initFWUI{
    [super initFWUI];
    
    self.title = ASLocalizedString(@"签到");
    [self.view addSubview:self.collectionView];
}
- (void)requestData{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"signin_list" forKey:@"act"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        NSDictionary * dict = responseJson;
        BGSignModel *model =[BGSignModel mj_objectWithKeyValues:dict];
        self.model = model;
//        self.alreadySign = model.is_sign.intValue;
        [self.collectionView reloadData];
        
        [self requestDataToady];

    } FailureBlock:^(NSError *error) {
        
    }];
    
}
- (void)requestDataToady{
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"is_signin" forKey:@"act"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
       FWStrongify(self)

        self.alreadySign = [responseJson toInt:@"today_signin"];
        [self.collectionView reloadData];
        
        [SignSuccessPopView showSignSuccessViewGift:@"0000100" WithComplete:^{
               
               
       }];
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
    
    
}

- (void)signRequest{
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"user_signin" forKey:@"act"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            //签到成功弹出成功
            //刷新头部 刷新列表
            //钻石后台返回
            FWStrongify(self)
            [self requestData];
            
    
          
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return CGSizeMake(kScreenW, 170);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==1) {
        return CGSizeMake(kScreenW, 100);
    }
    return CGSizeZero;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        SignHeaderCollectReusView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SignHeaderCollectReusView class]) forIndexPath:indexPath];
        [headerView setDataWithsignin_continue:@"1" signin_count:self.model.signin_count];
        
        return headerView;
    }
    if (indexPath.section == 1) {
        
        
        SignFooterCollectReusView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([SignFooterCollectReusView class]) forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        
        footerView.alreadySign = self.alreadySign;
        
        footerView.signBlock = ^{
            [weakSelf signRequest];
            
        };
        return footerView;
        
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.list.count > 4 ? 4 : self.model.list.count;
    }
    return self.model.list.count > 4 ? self.model.list.count - 4 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SignCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SignCollectCell class]) forIndexPath:indexPath];
    
    if (self.model.list) {
        
        if (indexPath.section == 0) {
            cell.model = self.model.list[indexPath.item];
            
        } else {
            
            cell.model = self.model.list[indexPath.item + 4];
            
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenW-14*5)/4, kRealValue(110));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, 14, 0, 14);
        
    }
    
    return UIEdgeInsetsMake(0, 59, 0, 59);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark - setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenW , kScreenH) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SignCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([SignCollectCell class])];
        [_collectionView registerClass:[SignHeaderCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass([SignHeaderCollectReusView class])];
        [_collectionView registerClass:[SignFooterCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass([SignFooterCollectReusView class])];
    }
    return _collectionView;
}

@end
