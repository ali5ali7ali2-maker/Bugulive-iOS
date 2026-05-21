//
//  LoginRecommendVC.m
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "LoginRecommendVC.h"
#import "LoginRecomCollectCell.h"

#import "LoginRecomHeaderCollectReusView.h"

#import "LoginRecomFooterCollectReusView.h"

@interface LoginRecommendVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *hotDataArray;
@property(nonatomic, strong) NSMutableArray *bgDataArray;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *goBtn;

@end

@implementation LoginRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    [self initNavView];
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (void)initNavView{
    
    _titleLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:20];
        label.text = ASLocalizedString(@"为您推荐的主播");
        label;
    });
    
    [self.view addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kTopHeight - 30);
        make.top.mas_equalTo(MG_TOP_MARGIN+20);
        make.centerX.mas_equalTo(0);
    }];
    
    _goBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:ASLocalizedString(@"跳过")forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.view addSubview:_goBtn];
    
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(@(-10));
        
    }];
}

- (void)requestData{
    
    [self.bgDataArray removeAllObjects];
    
    NSString * uid = [BGIMLoginManager sharedInstance].loginParam.identifier;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"recomme_user" forKey:@"act"];
    
    [parmDict setObject:uid forKey:@"uid"];
    
    [parmDict setObject:@"1" forKey:@"first"];

    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray * array = [responseJson[@"data"]valueForKey:@"list"];
        for (id obj in array)
        {
            HMHotItemModel *model =[HMHotItemModel mj_objectWithKeyValues:obj];
            [self.bgDataArray addObject:model];
        }
        
        [self.collectionView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)goAction{
    
    //跳过
//    [self showMyHud];
    
    [[BGIMLoginManager sharedInstance] getUserSig:^{
        
        [[AppDelegate sharedAppDelegate] enterMainUI];
//        [self hideMyHud];
//
    } failed:^(int errId, NSString *errMsg) {
//        [self hideMyHud];
    }];
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    return CGSizeMake(kScreenW, 50);
//
//}
- (void)followUsers{
    
    NSMutableArray * arrUid = [NSMutableArray array];
    
    for (int i = 0; i < self.bgDataArray.count; i ++) {
        HMHotItemModel * model = self.bgDataArray[i];
        if (model.selected == YES) {
            [arrUid addObject:model.id];

        }
    }
    
    
    if (arrUid.count == 0) {
        [self goAction];
    } else {
        
        NSString * strIDAll = [arrUid componentsJoinedByString:@","];
        
        NSString * uid = [BGIMLoginManager sharedInstance].loginParam.identifier;
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"follow_all" forKey:@"act"];
        
        [parmDict setObject:strIDAll forKey:@"to_user_id"];
        
        
        [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            if ([responseJson toInt:@"status"] == 1) {
                NSLog(ASLocalizedString(@"成功responseJson:%@"),responseJson);
                
                
                [self goAction];
                
                
            }else{
                NSLog(ASLocalizedString(@"失败responseJson:%@"),responseJson);
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
        
        
        
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenW, 160);
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        LoginRecomHeaderCollectReusView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LoginRecomHeaderCollectReusView class]) forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = ASLocalizedString(@"—— 热门主播 ——");
        } else {
            headerView.titleLabel.text = ASLocalizedString(@"—— 官方推荐 ——");
            
        }
        return headerView;
    }
    if (indexPath.section == 0) {
        
        
        LoginRecomFooterCollectReusView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([LoginRecomFooterCollectReusView class]) forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        
        
        //换一批
        footerView.changeBlock = ^{
            [weakSelf requestData];
            
        };
        //开启布谷直播
        footerView.goBlock = ^{
            
            //关注主播后进入app
            [self followUsers];
            
        };
        return footerView;
        
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    if (section == 0) {
    //        return 4;
    //        return self.hotDataArray.count;
    //
    //    }
    //    return 3;
    return self.bgDataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LoginRecomCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LoginRecomCollectCell class]) forIndexPath:indexPath];
    
    
    cell.model = self.bgDataArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenW-10*2)/3, kRealValue(100));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    if (section == 0) {
    //        return UIEdgeInsetsMake(0, 14, 0, 14);
    //
    //    }
    //
    //    return UIEdgeInsetsMake(0, 59, 0, 59);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HMHotItemModel * model = self.bgDataArray[indexPath.item];
    model.selected = !model.selected;
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

#pragma mark - setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,MG_TOP_MARGIN+70, kScreenW , kScreenH-(MG_TOP_MARGIN+70)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LoginRecomCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([LoginRecomCollectCell class])];
        //        [_collectionView registerClass:[LoginRecomHeaderCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        //                   withReuseIdentifier:NSStringFromClass([LoginRecomHeaderCollectReusView class])];
        
        [_collectionView registerClass:[LoginRecomFooterCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass([LoginRecomFooterCollectReusView class])];
        
    }
    return _collectionView;
}


- (NSMutableArray *)hotDataArray{
    if (!_hotDataArray) {
        _hotDataArray = [NSMutableArray array];
    }
    return _hotDataArray;
}

- (NSMutableArray *)bgDataArray{
    if (!_bgDataArray) {
        _bgDataArray = [NSMutableArray array];
    }
    return _bgDataArray;
}
@end
