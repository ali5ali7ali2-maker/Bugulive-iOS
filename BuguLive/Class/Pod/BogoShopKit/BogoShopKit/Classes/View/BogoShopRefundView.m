//
//  BogoShopRefundView.m
//  BogoShopKit
//
//  Created by 宋晨光 on 2021/9/1.
//

#import "BogoShopRefundView.h"
#import "BogoShopRefundCell.h"
#import <YYKit/YYKit.h>
#import "BogoShopKit.h"

@implementation BogoShopRefundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        
        
    }
    return self;
}

-(void)setUpView{
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 44)];
    titleL.text = @"退款原因";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(FD_ScreenWidth - 10 - 30, 0, 30, 30);
    closeBtn.centerY = titleL.centerY;
    [closeBtn setImage:[UIImage imageNamed:@"com_close_1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
//    closeBtn.backgroundColor = [UIColor yellowColor];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(FD_ScreenWidth - 10 - 30, self.height - FD_Bottom_SafeArea_Height - 40 - 18, 270, 40);
    confirmBtn.centerX = kScreenW / 2;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"bogo_shop_refund_confirmBtn" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
//    confirmBtn.backgroundColor = [UIColor redColor];
    CGFloat confirmBtnHeight = 40;
    
    self.tableView.frame = CGRectMake(0, titleL.bottom, FD_ScreenWidth, self.height - 44 - FD_Bottom_SafeArea_Height - confirmBtnHeight - 10 - 18);
    
    
    [self addSubview:titleL];
    [self addSubview:self.tableView];
    [self addSubview:closeBtn];
    [self addSubview:confirmBtn];
    
    
}

- (void)setListArr:(NSMutableArray *)listArr{
    _listArr = listArr;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoShopRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoShopRefundCell"];
    
    if (self.listArr.count > 0) {
        BogoRefundReasonModel *model = self.listArr[indexPath.row];
        
        
        if ([_model.value isEqualToString:model.value]) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
        cell.model = model;
        
        __weak __typeof(self)weakSelf = self;
        cell.clickSelectModelBlock = ^(BogoRefundReasonModel * _Nonnull model) {
            weakSelf.model = model;
            [weakSelf.tableView reloadData];
        };
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

-(void)clickConfirmBtn:(UIButton *)sender{
    if (self.clickConfirmBlock) {
        self.clickConfirmBlock(_model);
        [self hide];
    }
}

-(void)clickCloseBtn:(UIButton *)sender{
    
    [self hide];
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight / 2 + 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoShopRefundCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoShopRefundCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



@end
