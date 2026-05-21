//
//  BogoSetPriviteNobleViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/26.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSetPriviteNobleViewController.h"
#import "SetTableViewCell.h"
@interface BogoSetPriviteNobleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArr;

@end

@implementation BogoSetPriviteNobleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = ASLocalizedString(@"隐私特权设置");
    
    [self setupBackBtnWithBlock:nil];
    
    _listArr = [NSMutableArray arrayWithObjects:ASLocalizedString(@"隐身进场"),ASLocalizedString(@"榜单隐身"), nil];
    [self.view addSubview:self.tableView];
    
}

- (void)setupBackBtnWithBlock:(BackBlock)backBlock
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
//    NSArray *sectionArr = self.listArr[indexPath.section];
    cell.setText.text = [NSString stringWithFormat:@"%@", self.listArr[indexPath.row]];
    
    cell.indexRow = indexPath.row;
    cell.setText.text = self.listArr[indexPath.row];
    cell.line.hidden = NO;
    cell.memoryText.hidden = YES;
    cell.nobleOpenSwitch.hidden = NO;
    cell.labOutLogin.hidden = YES;
    cell.comeBackIMG.hidden = YES;
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SetTableViewCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



@end
