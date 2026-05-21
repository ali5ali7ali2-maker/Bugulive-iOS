//
//  BogoShopRefundReasonPopView.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/19.
//

#import "BogoShopRefundReasonPopView.h"
#import "BogoShopRefundReasonListCell.h"
#import "BogoShopKit.h"
#import "BogoRefundReasonModel.h"
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoShopRefundReasonPopView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoShopRefundReasonPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoShopRefundReasonListCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoShopRefundReasonListCell"];
}

- (void)requestData{
    [[BogoNetwork shareInstance] GET:@"order_api/getReasonRefundUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data) {
            BogoRefundReasonModel *model = [BogoRefundReasonModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self];
    }];
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self hide];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoShopRefundReasonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoShopRefundReasonListCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
