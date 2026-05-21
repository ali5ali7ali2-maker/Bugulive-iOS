//
//  BogoNobleViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/22.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNobleViewController.h"
#import "BogoNobleTitleCell.h"
#import "BogoNoblePrivilegeCell.h"
#import "BogoNobleListModel.h"
#import "BogoNobleBottomView.h"//底部视图
#import "BogoNobleAlertView.h"//弹窗view
#import "BogoNoblePayView.h" //支付view

@interface BogoNobleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,BogoNobleBottomDelegate,BogoNoblePayDelegate>

@property(nonatomic, strong) UICollectionView *titleCollectionView;
@property(nonatomic, strong) UICollectionView *contentCollectionView;

@property(nonatomic, strong) NSMutableArray *titleListArr;
@property(nonatomic, strong) NSMutableArray *contentListArr;

@property(nonatomic, strong) BogoNobleListModel *model;
@property(nonatomic, strong) BogoNobleListTypeModel *typeModel;
@property(nonatomic, strong) BogoNobleListSubTypeModel *selectModel;



@property(nonatomic, strong) UIView *bgTopView;
@property(nonatomic, strong) UIImageView *bgTopImgView;

@property(nonatomic, strong) BogoNobleBottomView *bottomView;

@property(nonatomic, strong) BogoNobleAlertView *alertView;
@property(nonatomic, strong) BogoNoblePayView *payView;


@property(nonatomic, strong) UIView *lineView;//滑动line

@end

@implementation BogoNobleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    [self setNavView];
    [self setUpView];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self setModel];
}

-(void)setNavView{
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW * 0.5, kRealValue(40))];
    titleL.text = ASLocalizedString(@"贵族列表");
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    titleL.centerX = kScreenW / 2;
    backBtn.frame = CGRectMake(kRealValue(10), kStatusBarHeight, kRealValue(40), kRealValue(40));
}

-(void)clickBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpView{
    
    UICollectionViewFlowLayout *titleLayout = [[UICollectionViewFlowLayout alloc] init];
    titleLayout.itemSize = CGSizeMake(kScreenW / 5, kRealValue(70));
    titleLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    titleLayout.minimumInteritemSpacing = 10;
    titleLayout.minimumLineSpacing = 10;
    titleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenW, kRealValue(48)) collectionViewLayout:titleLayout];
    self.titleCollectionView.delegate = self;
    self.titleCollectionView.dataSource = self;
    self.titleCollectionView.backgroundColor = kWhiteColor;
    self.titleCollectionView.showsHorizontalScrollIndicator = NO;
    [self.titleCollectionView registerNib:[UINib nibWithNibName:@"BogoNobleTitleCell" bundle:nil] forCellWithReuseIdentifier:@"BogoNobleTitleCell"];
    [self.titleCollectionView addSubview:self.lineView];
    
    
    UIImageView *contentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(6), self.titleCollectionView.bottom + kRealValue(117), kScreenW - kRealValue(6 * 2), kScreenH - self.titleCollectionView.bottom - kRealValue(117) - self.bottomView.height - kRealValue(26))];
    contentImgView.image = [UIImage imageNamed:@"bogo_noble_contentBgImg"];
    contentImgView.userInteractionEnabled = YES;
    
    UICollectionViewFlowLayout *contentLayout = [[UICollectionViewFlowLayout alloc] init];
    contentLayout.itemSize = CGSizeMake((contentImgView.width - kRealValue(10 * 2 + 10 * 5)) / 4, kScreenW / 4);
    contentLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    contentLayout.minimumInteritemSpacing = 10;
    contentLayout.minimumLineSpacing = 10;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kRealValue(10), contentImgView.top + kRealValue(5), contentImgView.width - kRealValue(10 * 2),contentImgView.height - kRealValue(10)) collectionViewLayout:contentLayout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.backgroundColor = kClearColor;
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"BogoNoblePrivilegeCell" bundle:nil] forCellWithReuseIdentifier:@"BogoNoblePrivilegeCell"];
    
    
    [self.view addSubview:self.titleCollectionView];
    [self.view addSubview:self.bgTopView];
    [self.view addSubview:contentImgView];
    [self.view addSubview:self.contentCollectionView];
    [self.view addSubview:self.bottomView];
}

-(void)setModel{
    
    self.titleListArr = [NSMutableArray array];
    self.contentListArr = [NSMutableArray array];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"Aristocratic" forKey:@"ctl"];
    [parmDict setObject:@"index" forKey:@"act"];
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            
            BogoNobleListModel *model = [BogoNobleListModel mj_objectWithKeyValues:responseJson];
            self.model = model;
            
            NSLog(@"%@",model);
            
            for (BogoNobleListTypeModel *model in self.model.list) {
                [self.titleListArr addObject:model];
                if (model == self.titleListArr.firstObject) {
                    [self.bgTopImgView sd_setImageWithURL:[NSURL URLWithString:model.shop_icon] completed:nil];
                    self.bottomView.model = model.noble_recharge;
                }
            }
            
//            self.bottomView.
            
            NSInteger scrollIndex = 0;
            
            BogoNobleListTypeModel *firstModel = self.model.list.firstObject;
            self.typeModel = self.model.list.firstObject;
            
            
            [self.titleCollectionView reloadData];
            [self.contentCollectionView reloadData];
            
            
            for (int i = 0; i < self.model.list.count; i ++) {
                BogoNobleListTypeModel *typeModel = self.model.list[i];
                
                if ([self.model.user_info.nobleid isEqualToString:typeModel.id]) {
                    self.typeModel = typeModel;
                    self.bottomView.isOpen = YES;
                    scrollIndex = i;
                }
            }

            [self collectionView:self.titleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0]];
                

            
            if (scrollIndex > self.titleListArr.count / 2) {
                [self.titleCollectionView setContentOffset:CGPointMake(kScreenW / 2, 0)];
            }
            NSLog(@"%@",self.titleListArr);
            
        }else{
            
        }
    } FailureBlock:^(NSError *error) {
        [FanweMessage alertHUD:ASLocalizedString(@"加载失败")];
    }];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.titleCollectionView) {
        
        return self.titleListArr.count;
    }
    return self.typeModel.noble_type.count;
//    self.contentListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.titleCollectionView) {
        BogoNobleTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoNobleTitleCell" forIndexPath:indexPath];
        BogoNobleListTypeModel *model = self.titleListArr[indexPath.row];
        cell.titleLabel.text = model.name;
        if ([model.id isEqualToString:self.typeModel.id]) {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#C39346"];
            UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
           
            CGPoint cellCenter = attributes.center;
            CGPoint anchorPoint = [collectionView convertPoint:cellCenter toView:self.view];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.lineView.centerX = anchorPoint.x + self.titleCollectionView.contentOffset.x;
            }];
            
            
        }else{
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#C7A02B"];
        }
        
        
        return cell;
    }
    
    BogoNoblePrivilegeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoNoblePrivilegeCell" forIndexPath:indexPath];
    BogoNobleListSubTypeModel *model = self.typeModel.noble_type[indexPath.row];
    if ([model.is_type isEqualToString:@"1"]) {
        [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        cell.privilegeLabel.textColor = [UIColor colorWithHexString:@"#BE9854"];
    }else{
        [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.noicon]];
        cell.privilegeLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    }
    
    cell.privilegeLabel.text = model.title;
    
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.titleCollectionView) {
//        if (self.typeModel.id) {
//            <#statements#>
//        }
//        [self.titleCollectionView scrollToRight];
//    }
//
//    NSLog(@"contentOffset.x%f",scrollView.contentOffset.x);
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titleCollectionView) {
        BogoNobleListTypeModel *model = self.titleListArr[indexPath.row];
//        self.typeModel.isSelect = YES;
        self.typeModel = model;
        [self.bgTopImgView sd_setImageWithURL:[NSURL URLWithString:model.shop_icon] completed:nil];
        [self.titleCollectionView reloadData];
        [self.contentCollectionView reloadData];
        if ([self.model.user_info.nobleid isEqualToString:self.typeModel.id]) {
            self.bottomView.isOpen = YES;
        }else{
            self.bottomView.isOpen = NO;
        }
        self.bottomView.model = model.noble_recharge;
    }else{
        
        BogoNobleListSubTypeModel *model = self.typeModel.noble_type[indexPath.row];
        self.selectModel = model;
        self.alertView.selectModel = model;
        [self.alertView show:self.view];
    }
}

#pragma mark - 协议代理

-(void)protocolClickOpenBtn{
    self.payView.model = self.typeModel;
    [self.payView show:self.view];
}

-(void)protocolBuySuccessWithModel:(BogoNobleListTypeModel *)payModel{
    [self.payView hide];
    self.model.user_info.nobleid = payModel.id;
//    if ([self.model.user_info.nobleid isEqualToString:payModel.id]) {
        self.bottomView.isOpen = YES;
//    }
}

-(UIView *)bgTopView{
    if (!_bgTopView) {
        _bgTopView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleCollectionView.bottom, kScreenW, kRealValue(160))];
        _bgTopView.backgroundColor = [UIColor colorWithHexString:@"#352E40"];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kRealValue(15), kRealValue(103), kRealValue(80))];
        imgView.centerX = kScreenW / 2;
        imgView.image = [UIImage imageNamed:@"DefaultImg"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        imgView.clipsToBounds = YES;
        _bgTopImgView = imgView;
        [_bgTopView addSubview:imgView];
    }
    return _bgTopView;
}

-(BogoNobleBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BogoNobleBottomView alloc]initWithFrame:CGRectMake(0, kScreenH - MG_BOTTOM_MARGIN - kRealValue(68), kScreenW, kRealValue(68))];
        _bottomView.delegate = self;
        
    }
    return _bottomView;
}

-(BogoNobleAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[NSBundle mainBundle]loadNibNamed:@"BogoNobleAlertView" owner:self options:nil].lastObject;
        _alertView.frame = CGRectMake((kScreenW - kRealValue(290)) / 2, 
                               (kScreenH - kRealValue(341)) / 2, 
                               kRealValue(290), kRealValue(341));
//        _alertView.centerX = kScreenW / 2;
//        _alertView.centerY = kScreenH / 2;
    }
    return _alertView;
}

-(BogoNoblePayView *)payView{
    if (!_payView) {
        _payView = [[NSBundle mainBundle]loadNibNamed:@"BogoNoblePayView" owner:self options:nil].lastObject;
        _payView.delegate = self;
        _payView.frame = CGRectMake(0, kScreenH - MG_BOTTOM_MARGIN - kRealValue(285), kScreenW, kRealValue(285));
    }
    return _payView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleCollectionView.height - kRealValue(5), kRealValue(16), kRealValue(2))];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#D19E3D"];
        _lineView.layer.cornerRadius = kRealValue(2) / 2;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
