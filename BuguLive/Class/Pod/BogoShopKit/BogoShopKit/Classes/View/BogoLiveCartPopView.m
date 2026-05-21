//
//  BogoLiveCartPopView.m
//  BuGuDY
//
//  Created by bogokj on 2020/3/28.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "BogoLiveCartPopView.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>

@interface BogoLiveCartPopView ()<UITableViewDelegate,UITableViewDataSource,BogoLiveStartGoodListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *addBtn;

@property(nonatomic, strong) NSString *is_explain;

@end

@implementation BogoLiveCartPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, 450);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveStartGoodListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class])];
    [self.addBtn setImagePosition:QMUIButtonImagePositionLeft];
    self.addBtn.spacingBetweenImageAndTitle = 5;
//    [self.addBtn setImage:[UIImage imageNamed:GB_IsDemo ? @"添加-Demo" : @"添加"] forState:UIControlStateNormal];
//    [self.addBtn setTitleColor:[UIColor colorWithHex:GB_IsDemo ? @"#E4A45A" : @"F46628"] forState:UIControlStateNormal];
    self.is_explain = @"";
}

- (void)setLid:(NSString *)lid{
    _lid = lid;
    [self requestData];
    
}

- (void)setType:(BogoLiveStartGoodListCellType)type{
    _type = type;
    self.addBtn.hidden = type == BogoLiveStartGoodListCellTypeForUser;
}

- (IBAction)addBtnAction:(id)sender {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickAddBtn:)]) {
        [self.delegate popView:self didClickAddBtn:sender];
    }
}

- (void)requestData{
    
    self.height = 450;
    
//    http://xx.com/api/Shoplive/liveGoodsList
    [[BogoNetwork shareInstance] GET:@"api/liveGoodsListUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self.dataArray removeAllObjects];
        if (result.status.integerValue == 200) {
            if ([result.data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArr = [NSArray arrayWithObject:result.data[@"data"]];
                for (NSDictionary *dict in [dataArr objectAtIndex:0]) {
                    BogoCommodityDetailModel *model =
                    [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
//                self.is_explain = result.data[@"is_explain"];
                
            }
            
            [self.countLabel setText:[NSString stringWithFormat:@"全部商品(%ld)",self.dataArray.count]];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCartCount" object:@(self.dataArray.count)];
        }
        
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:[UIApplication sharedApplication].keyWindow];
    }];
}

#pragma mark - BogoLiveStartGoodListCellDelegate
- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickOperateBtn:(UIButton *)sender{
    if (self.type == BogoLiveStartGoodListCellTypeForUser){
        if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickGood:)]) {
            [self.delegate popView:self didClickGood:listCell.model];
        }
    }else{
        //    http://xx.com/api/Shoplive/delLiveGoods
        [[BogoNetwork shareInstance] POST:@"api/liveDelGoodsUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"lid":self.lid,@"gid":listCell.model.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
            [self.dataArray removeObject:listCell.model];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didRemoveGood:)]) {
                [self.delegate popView:self didRemoveGood:listCell.model];
            }
            
            [self.countLabel setText:[NSString stringWithFormat:@"全部商品(%ld)",self.dataArray.count]];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCartCount" object:@(self.dataArray.count)];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:[UIApplication sharedApplication].keyWindow];
        }];
    }
}

- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickSayBtn:(UIButton *)sender{
    
//    if (listCell.model.is_live) {
//        [listCell.sayBtn setTitle:@"取消讲解" forState:UIControlStateNormal];
//        [listCell.sayBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#777777"] forState:UIControlStateNormal];
//        listCell.sayBtn.layer.cornerRadius = 4;
//        listCell.sayBtn.layer.borderColor = [UIColor qmui_colorWithHexString:@"#777777"].CGColor;
//        listCell.backgroundColor = [UIColor whiteColor];
//        listCell.inBtn.hidden = NO;
//    }else{
//        [listCell.sayBtn setTitle:@"开始讲解" forState:UIControlStateNormal];
//        listCell.inBtn.hidden = YES;
//
//        [listCell.sayBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
//        listCell.sayBtn.layer.cornerRadius = 4;
//        listCell.sayBtn.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F42416"].CGColor;
//        listCell.backgroundColor = [UIColor whiteColor];
//
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickSayBtn:)]) {
        [self.delegate popView:self didClickSayBtn:listCell.model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveStartGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class]) forIndexPath:indexPath];
    [cell setType:self.type];
    [cell setModel:self.dataArray[indexPath.row]];
    [cell setRow:indexPath.row + 1];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == BogoLiveStartGoodListCellTypeForUser) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickGood:)]) {
            [self.delegate popView:self didClickGood:self.dataArray[indexPath.row]];
        }
    }else if (self.type == BogoLiveStartGoodListCellTypeList){
        [self.delegate popView:self didClickGood:self.dataArray[indexPath.row]];
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIImage *)xy_noDataViewImage{
    return imageNamed(@"暂无商品_空状态");
}

- (NSString *)xy_noDataViewMessage{
    return @"暂无商品";
}

@end
