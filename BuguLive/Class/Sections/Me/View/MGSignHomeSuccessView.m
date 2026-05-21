//
//  MGSignHomeSuccessView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGSignHomeSuccessView.h"

#import "MGSignCollectCell.h"
#import "SignSuccessPopView.h"
#import "MGSignHomeHeaderCollectReusView.h"
#import "SignFooterCollectReusView.h"

@interface MGSignHomeSuccessView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, assign) BOOL alreadySign;
@property(nonatomic, strong) BGSignModel *model;
////@property(nonatomic, strong) UIView *bgView;
////@property(nonatomic, strong) UIButton *tipButton;
//@property(nonatomic, strong) UIImageView *bgImageView;
//@property(nonatomic, strong) UILabel *titleLabel;
//@property(nonatomic, strong) UILabel *giftLabel;
//
//@property(nonatomic, strong) UIImageView *successImageView;
//@property(nonatomic, strong) UIButton *closeButton;
//@property(nonatomic, strong) NSString *gift;
@property(nonatomic, strong) dismissBlock block;

@end

static NSString *const image_name_bg = @"签到成功背景";
static NSString *const image_name_success = @"签到成功";
static NSString *const image_name_btn = @"签到成功按钮";

@implementation MGSignHomeSuccessView

+(void)showTodaySignSuccessViewGift:(NSString *)gift frame:(CGRect)frame WithComplete:(dismissBlock)complete{
    MGSignHomeSuccessView *view = [[MGSignHomeSuccessView alloc]initWithFrame:frame];
    
    view.block = complete;
    [view pop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kClearColor;
        [self addSubview:self.collectionView];
        [self requestData];
        [self requestDataToady];
    }
    return self;
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
            
            [SignSuccessPopView showSignSuccessViewGift:responseJson[@"reward"] WithComplete:^{
                   
                   
           }];
          
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
    
    
}

- (void)dismissAction{
    [self dismiss];
    !self.block?:self.block();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self]) {
        [self dismiss];
    }
}

-(void)pop
{
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self];
//    self.bgImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{
//        self.bgImageView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
//        self.bgImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return CGSizeMake(kRealValue(278), kRealValue(113));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==1) {
        return CGSizeMake(kRealValue(188), kRealValue(50));
    }
    return CGSizeZero;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MGSignHomeHeaderCollectReusView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MGSignHomeHeaderCollectReusView class]) forIndexPath:indexPath];
        headerView.backgroundColor = kClearColor;
        headerView.clickCloseBlock = ^(BOOL isClose) {
            [self dismiss];
        };
//        [headerView setDataWithsignin_continue:@"1" signin_count:self.model.signin_count];
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
    
    MGSignCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MGSignCollectCell class]) forIndexPath:indexPath];
    
    if (self.model.list) {
        
        if (indexPath.section == 0) {
            cell.model = self.model.list[indexPath.item];
            
        } else {
            cell.model = self.model.list[indexPath.item+4];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kRealValue(278) - kRealValue(13 * 2) - kRealValue(11 * 2) ) / 4, kRealValue(85));
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

    return UIEdgeInsetsMake(0, 45, 0, 45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kRealValue(278) , kRealValue(348)) collectionViewLayout:layout];
        _collectionView.centerY = kScreenH / 2;
        _collectionView.centerX = kScreenW / 2;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MGSignCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([MGSignCollectCell class])];
        [_collectionView registerClass:[MGSignHomeHeaderCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass([MGSignHomeHeaderCollectReusView class])];
        [_collectionView registerClass:[SignFooterCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass([SignFooterCollectReusView class])];
    }
    return _collectionView;
}


@end
