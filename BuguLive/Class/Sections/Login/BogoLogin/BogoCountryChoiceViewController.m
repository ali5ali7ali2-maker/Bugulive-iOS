//
//  BogoCountryChoiceViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoCountryChoiceViewController.h"
#import "BogoChoiceAreaCell.h"

@interface BogoCountryChoiceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UITextField *searchField;

@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation BogoCountryChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
    
    
    [self.view addSubview:self.searchField];
    [self.view addSubview:self.tableView];
    
    self.dataArr = [NSMutableArray array];
    
    self.view.backgroundColor = kWhiteColor;
}

-(void)setUpView{
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:ASLocalizedString(@"取消") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, kRealValue(30))];
    titleL.text =ASLocalizedString( @"选择国家/地区");
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.centerX = kScreenW / 2;
    
    
    cancleBtn.frame = CGRectMake(kRealValue(10), kStatusBarHeight, 44, 44);
    
    titleL.centerY = cancleBtn.centerY;
    
    [self.view addSubview:cancleBtn];
    [self.view addSubview:titleL];
    self.dataArr = [NSMutableArray array];
    [self requestModelWithPageIndex:1];
}

-(void)clickCancleBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestModelWithPageIndex:(NSInteger)pageIndex{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
   
    [parmDict setObject:@"mobile_code" forKey:@"act"];
    
    [parmDict setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"p"];
    [parmDict setObject:self.searchField.text forKey:@"keyword"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
             
        FWStrongify(self)
        
        if (pageIndex == 1) {
            [self.dataArr removeAllObjects];
        }

        NSArray *arr = [NSArray modelArrayWithClass:[BogoChoiceAreaModel class] json:[responseJson valueForKey:@"data"]];
        
        [self.dataArr addObjectsFromArray:arr];
        [self.tableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BogoChoiceAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoChoiceAreaCell"];
    
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickAreaBlock) {
        self.clickAreaBlock(self.dataArr[indexPath.row]);
        [self clickCancleBtn:nil];
    }
    
}

-(UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(kRealValue(12), kTopHeight, kScreenW - kRealValue(12 * 2),kRealValue(32))];
        _searchField.placeholder = ASLocalizedString(@"请输入搜索内容");
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        _searchField.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _searchField.layer.cornerRadius = kRealValue(32 / 2);
        _searchField.layer.masksToBounds = YES;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"bogo_home_top_search"];
        imageView.center = leftView.center;
        [leftView addSubview:imageView];
        _searchField.leftView = leftView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.delegate = self;
        
    }
    return _searchField;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchField.bottom, kScreenW, kScreenH - self.searchField.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoChoiceAreaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoChoiceAreaCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
