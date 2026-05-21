//
//  MGLiveRechargeView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/8/5.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountRechargeModel.h"
#import <StoreKit/StoreKit.h>
#import "Pay_Model.h"


NS_ASSUME_NONNULL_BEGIN

@interface MGLiveRechargeView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UILabel *balanceL;


@property(nonatomic, strong) UIView *shadowView;

@property(nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSMutableArray * ruleListArr;

@property (nonatomic, strong) NSMutableArray * otherPayArr;//除苹果支付外的其它第三方支付(此数组用于存有第三方支付，且show_other字段为1但支付列表只有最外面的一个统一支付列表，并没有每个不同支付方式对应不同类别时的情况)
//@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) AccountRechargeModel *model;

@property(nonatomic, assign) BOOL isSelectAgree;

@property(nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *pro_id;
@property (nonatomic, strong) SKProductsRequest * request;

@property(nonatomic, strong) NSMutableArray *payBtnArray;

@property(nonatomic, strong) UIColor *nowMainColor;


- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
