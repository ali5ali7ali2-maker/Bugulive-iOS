//
//  BogoNoblePayView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNoblePayView.h"
#import "BogoNoblePayCell.h"

@implementation BogoNoblePayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    for (UIView *subView in self.subviews) {
        [subView setLocalizedString];
    }
}

-(void)reloadNetSourse{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"noble" forKey:@"ctl"];
    [parmDict setObject:@"select_coin" forKey:@"act"];
    [parmDict setObject:self.model.id forKey:@"id"];
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            
            BogoNoblePayModel *model = [BogoNoblePayModel mj_objectWithKeyValues:responseJson];
            
            self.payModel = model;
            self.paySelectModel = model.list.firstObject;
            self.titleL.text = model.name;
            [self.collectionView reloadData];

            
        }else{
            [FanweMessage alertHUD:[responseJson objectForKey:@"error"]];
        }
    } FailureBlock:^(NSError *error) {
            [FanweMessage alertHUD:ASLocalizedString(@"支付失败，请重试")];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.payModel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoNoblePayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoNoblePayCell" forIndexPath:indexPath];
    
    
    BogoNoblePayListModel *model = self.payModel.list[indexPath.row];
//    modelself.payModel.list[indexPath.row];
    
    if (self.paySelectModel == model) {
        model.isSelect = YES;
    }else{
        model.isSelect = NO;
    }
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.paySelectModel = self.payModel.list[indexPath.row];
    [self.collectionView reloadItemsAtIndexPaths:collectionView.indexPathsForVisibleItems];
}

- (IBAction)clickConfirmBtn:(UIButton *)sender {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"noble" forKey:@"ctl"];
    [parmDict setObject:@"pay" forKey:@"act"];
    [parmDict setObject:self.paySelectModel.id forKey:@"id"];
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD ]
            if (self.delegate && [self.delegate respondsToSelector:@selector(protocolBuySuccessWithModel:)]) {
                [self.delegate protocolBuySuccessWithModel:self.model];
            }
            
            [FanweMessage alertHUD:[responseJson objectForKey:@"error"]];
        }else{
            [FanweMessage alertHUD:[responseJson objectForKey:@"error"]];
        }
    } FailureBlock:^(NSError *error) {
        [FanweMessage alertHUD:ASLocalizedString(@"支付失败，请重试")];
    }];
    
}


#pragma mark - Lazy Load
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenHeight)];
        _shadowView.backgroundColor = kGrayTransparentColor2_1;
//        [kBlackColor colorWithAlphaComponent:0.3];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

//- (void)setSelectModel:(BogoNobleListSubTypeModel *)selectModel{
//
//}

- (void)show:(UIView *)superView{
//    [self requestWardData];
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BogoNoblePayCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BogoNoblePayCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    [self reloadNetSourse];
    [UIView animateWithDuration:0.25 animations:^{
        //        self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        self.bottom = kScreenHeight;
        self.shadowView.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, self.width, self.height);
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
    }];
}


@end
