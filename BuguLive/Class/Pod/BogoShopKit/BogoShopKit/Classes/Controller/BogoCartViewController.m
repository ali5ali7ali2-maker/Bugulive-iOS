//
//  BogoCartViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "BogoCartViewController.h"
#import "BogoCartNoDataView.h"
#import "BogoCartCell.h"
#import "BogoCartHeaderView.h"
#import "BogoCartBottomView.h"
#import "FDUIKitObjC.h"
#import "NSKeyedArchiver+FD.h"
#import "BogoCommodityDetailModel.h"
#import <YYKit/YYKit.h>
#import "BogoShopKit.h"
#import "BogoCartModel.h"
#import "BogoOrderSubmitViewController.h"
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>

@interface BogoCartViewController ()<BogoCartNoDataViewDelegate,BogoCartBottomViewDelegate,UITableViewDelegate,UITableViewDataSource,BogoCartCellDelegate,BogoCartHeaderViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, strong) BogoCartNoDataView *noDataView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) BogoCartBottomView *bottomView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) NSMutableArray *pushDataArray;

@property(nonatomic, strong) UIButton *editBtn;

@property(nonatomic, strong) UIPanGestureRecognizer * interactivePopGestureRecognizer;

@end

@implementation BogoCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnAction)];
    
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    pan.delegate = self;
    self.interactivePopGestureRecognizer = pan;
    [self.tableView addGestureRecognizer:pan];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
//    [self requestData];
    
    
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (self.childViewControllers.count == 1 ) {
            return NO;
        }
        
        if (self.interactivePopGestureRecognizer &&
            [[self.interactivePopGestureRecognizer.view gestureRecognizers] containsObject:gestureRecognizer]) {

            CGPoint tPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            
            NSLog(@"tPointtPoint%lf",tPoint.x);
            NSLog(@"%lf",tPoint.y);
            

            if (tPoint.x >= 0) {
                CGFloat y = fabs(tPoint.y);
                CGFloat x = fabs(tPoint.x);
                CGFloat af = 30.0f/180.0f * M_PI;
                CGFloat tf = tanf(af);
                if ((y/x) <= tf) {
                    return NO;
                }
                return NO;

            }else{
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
   
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void)requestData{
    //    http://xx.com/api/shopuser/getShopCartList
    
    self.pushDataArray = [NSMutableArray array];
    
    [[BogoNetwork shareInstance] GET:@"api/getShopCartListUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in result.data) {
            BogoCartModel *model = [BogoCartModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        
        
        self.editBtn.hidden = !self.dataArray.count > 0;
        
        
        if (self.dataArray.count) {
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
            if (self.bottomView) {
                [self.bottomView removeFromSuperview];
                self.bottomView = nil;
            }
            
            [self.view addSubview:self.bottomView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.view);
                make.height.mas_equalTo(FD_Bottom_SafeArea_Height + 50);
            }];
        }else{
            [self.view addSubview:self.noDataView];
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)editBtnAction{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishBtnAction)];
    [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView setType:BogoCartBottomViewTypeEdit];
}

- (void)finishBtnAction{
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnAction)];
    [self.bottomView setType:BogoCartBottomViewTypeNormal];
}

#pragma mark - BogoCartCellDelegate
- (void)cartCell:(BogoCartCell *)cartCell didClickSelectBtn:(UIButton *)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cartCell];
    [cartCell setSelected:sender.isSelected];
    cartCell.listModel.selected = sender.isSelected;
    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    BogoCartModel *model = self.dataArray[indexPath.section];
    if (model.selected) {
        //原来被选中，如果有子项不选中，变为不选中
        for (BogoCartModel *model in self.dataArray) {
            for (BogoCartListModel *listModel in model.cart_list) {
                if (!listModel.selected) {
                    break;
                }
            }
        }
        model.selected = NO;
        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //原来未选中，如果子项全选中，变为已选中
        BOOL ret = YES;
        for (BogoCartModel *model in self.dataArray) {
            for (BogoCartListModel *listModel in model.cart_list) {
                ret = listModel.selected && ret;
            }
        }
        if (ret) {
            model.selected = YES;
            [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    //计算价钱
    [self caculatePrice];
    [self caculateCount];
}

- (void)cartCell:(BogoCartCell *)cartCell didInputValue:(NSInteger)num{
    //计算价钱
    [self caculatePrice];
}

#pragma mark - BogoCartHeaderViewDelegate
- (void)headerView:(BogoCartHeaderView *)headerView didClickSelectBtn:(UIButton *)sender{
    BogoCartModel *model = self.dataArray[headerView.section];
    for (BogoCartListModel *listModel in model.cart_list) {
        listModel.selected = sender.isSelected;
    }
    [self.tableView reloadSection:headerView.section withRowAnimation:UITableViewRowAnimationNone];
    //计算价钱
    [self caculatePrice];
    [self caculateCount];
}

#pragma mark - BogoCartBottomViewDelegate
- (void)bottomView:(BogoCartBottomView *)bottomView didClickAccountBtn:(UIButton *)sender{
    
    for (BogoCartModel *model in self.dataArray) {
        for (BogoCartListModel *listModel in model.cart_list) {
            
            if (listModel.selected) {
                
                if ([self.pushDataArray containsObject:model]) {
                    [self.pushDataArray removeObject:model];
                }
                [self.pushDataArray addObject:model];
            }
            
        }
    }
    
    if (self.pushDataArray.count > 0) {
        
        
        for (BogoCartModel *model in self.pushDataArray) {
            NSMutableArray *cartListArr = [NSMutableArray arrayWithArray:model.cart_list];
            for (BogoCartListModel *listModel in model.cart_list) {

                if (!listModel.selected) {
                    
                    [cartListArr removeObject:listModel];
                }
            }
            model.cart_list = cartListArr;
        }
        //去结算
        BogoOrderSubmitViewController *orderSubmitVC = [[BogoOrderSubmitViewController alloc]init];
        orderSubmitVC.cartDataArray = self.pushDataArray;
        orderSubmitVC.source = self.source;
        [self.navigationController pushViewController:orderSubmitVC animated:YES];
    }else{
        [[FDHUDManager defaultManager]show:@"请选择一件商品" ToView:self.view];
    }
}

- (void)bottomView:(BogoCartBottomView *)bottomView didClickDeleteBtn:(UIButton *)sender{
//    http://xx.com/api/shopuser/delCart
    __weak __typeof(self)weakSelf = self;
    NSMutableArray *idArray = [NSMutableArray array];
    NSMutableArray *tempDataArray = [NSMutableArray arrayWithArray:self.dataArray];
    for (BogoCartModel *model in self.dataArray) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:model.cart_list];
        for (BogoCartListModel *listModel in model.cart_list) {
            if (listModel.selected) {
                [idArray addObject:listModel.id];
            }
            [tempArray removeObject:listModel];
        }
        model.cart_list = tempArray;
        if (!model.cart_list.count) {
            [tempDataArray removeObject:model];
        }
    }
//    [self.dataArray setArray:tempDataArray];
//    if (!self.dataArray.count) {
//        [self.view addSubview:self.noDataView];
//        [self.bottomView removeFromSuperview];
//        self.editBtn.hidden = YES;
//    }
    
    
    if (idArray.count < 1) {
        [[FDHUDManager defaultManager] show:@"请选择要删除的商品" ToView:self.view];
        return;
    }
    
    [[BogoNetwork shareInstance] POST:@"api/delCartUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"id":[idArray componentsJoinedByString:@","]} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [self requestData];
//        [strongSelf.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
    }];
}

- (void)bottomView:(BogoCartBottomView *)bottomView didClickSelectBtn:(UIButton *)sender{
    for (BogoCartModel *model in self.dataArray) {
        model.selected = sender.isSelected;
        for (BogoCartListModel *listModel in model.cart_list) {
            listModel.selected = sender.isSelected;
        }
    }
    [self.tableView reloadData];
    [self caculatePrice];
    [self caculateCount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BogoCartModel *model = self.dataArray[section];
    return model.cart_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoCartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCartCell class]) forIndexPath:indexPath];
    BogoCartModel *model = self.dataArray[indexPath.section];
    [cell setType:BogoCartCellTypeNormal];
    [cell setListModel:model.cart_list[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BogoCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoCartHeaderView class])];
    headerView.delegate = self;
    [headerView setCartModel:self.dataArray[section]];
    [headerView setSection:section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BogoCartModel *model = self.dataArray[indexPath.section];
    BogoCartListModel *detailModel = model.cart_list[indexPath.row];
    if (detailModel.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:detailModel.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = detailModel.gid;
        detailVC.distribution_id = detailModel.distribution_uid;
        detailVC.uid = detailModel.share_uid;
        detailVC.source = self.source;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

#pragma mark - cell删除操作
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){

        BogoCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BogoCartModel *model = self.dataArray[indexPath.section];
        
        __weak __typeof(self)weakSelf = self;
        NSMutableArray *idArray = [NSMutableArray array];
        NSMutableArray *tempDataArray = [NSMutableArray arrayWithArray:self.dataArray];
        for (BogoCartModel *model in self.dataArray) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:model.cart_list];
            for (BogoCartListModel *listModel in model.cart_list) {
                if (listModel == model) {
                    [idArray addObject:listModel.id];
                }
                [tempArray removeObject:listModel];
            }
            model.cart_list = tempArray;
            if (!model.cart_list.count) {
                [tempDataArray removeObject:model];
            }
        }
        [self.dataArray setArray:tempDataArray];
        
        if (!self.dataArray.count) {
            [self.view addSubview:self.noDataView];
            [self.bottomView removeFromSuperview];
        }
        
        [[BogoNetwork shareInstance] POST:@"api/delCartUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"id":[idArray componentsJoinedByString:@","]} success:^(BogoNetworkResponseModel * _Nonnull result) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        } failure:^(NSString * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
        }];
    }
}


#pragma mark - BogoCartNoDataViewDelegate
- (void)noDataView:(BogoCartNoDataView *)noDataView didClickGoBtnAction:(UIButton *)sender{
    //去逛逛
    [self.navigationController popToRootViewControllerAnimated:YES];
//     popViewControllerAnimated:YES];
}

- (BogoCartNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoCartNoDataView class]) owner:nil options:nil].lastObject;
        _noDataView.delegate = self;
    }
    return _noDataView;
}

- (BogoCartBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoCartBottomView class]) owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        [_bottomView setType:BogoCartBottomViewTypeNormal];
    }
    return _bottomView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height + 50, 0);
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCartCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCartCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCartHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BogoCartHeaderView class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)caculatePrice{
    double price = 0;
    for (BogoCartModel *model in self.dataArray) {
        for (BogoCartListModel *listModel in model.cart_list) {
            if (listModel.selected) {
                price = price + listModel.price.doubleValue * listModel.num / 100;
            }
        }
    }
    [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",price]];
}

- (void)caculateCount{
    NSInteger count = 0;
    NSInteger allCount = 0;
    for (BogoCartModel *model in self.dataArray) {
        for (BogoCartListModel *listModel in model.cart_list) {
            allCount = allCount + 1;
            if (listModel.selected) {
                count = count + (listModel.selected ? 1 : 0);
                continue;
            }
        }
    }
    NSLog(@"allCount:%ld",allCount);
    NSLog(@"count:%ld",count);
    self.bottomView.selectBtn.selected = allCount == count;
    [self.bottomView setNum:[NSString stringWithFormat:@"%ld",count]];
}


-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.frame = CGRectMake(0, 0, 60, 30);
    }
    return _editBtn;
}

@end
