//
//  ReleaseAtPeopleVC.m
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "ReleaseAtPeopleVC.h"
#import "ReleaseAtPeopleCell.h"

@interface ReleaseAtPeopleVC ()

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property ( nonatomic,assign) int                        page;

@property(nonatomic,strong) UIButton *closeBtn;

@end

@implementation ReleaseAtPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    [self configureData];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (void)initNavView{
    
    self.closeBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:ASLocalizedString(@"取消")forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.view addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.right.mas_equalTo(-10);
        
        
    }];
    
    
    UIButton * searchBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.view addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight - 22);
        make.left.mas_equalTo(15);
    }];
    
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = ASLocalizedString(@"提醒谁看");
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        
        make.centerY.equalTo(searchBtn);
        
        
    }];
    
}

- (void)closeButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBtnClick{
    
}

- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (kNavigationBarHeight+kStatusBarHeight), kScreenW, kScreenH  - (kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStylePlain];
    //    if (isIPhoneX()) {
    //        self.tableView.height = kScreenH - 49 - 64 - 20;
    //    }
    
    NSLog(@"%f",kTabBarHeight);
    NSLog(@"%f",kNavigationBarHeight);
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    //    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = kWhiteColor;
    
    
    //    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[ReleaseAtPeopleCell class] forCellReuseIdentifier:NSStringFromClass([ReleaseAtPeopleCell class])];
    //    [self.tableView registerClass:[CellForWorkGroupRepost class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroupRepost class])];
    
    
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
    
}

#pragma mark    下拉刷新
- (void)refreshHeader
{
    self.page = 1;
    [self loadDataWithPage:1];
}

#pragma mark    上拉加载
- (void)refreshFooter
{
    self.page ++;
    [self loadDataWithPage:self.page];
}

- (void)loadDataWithPage:(int)page
{
    [BGMJRefreshManager endRefresh:self.tableView];
    
}
- (void)configureData{
    
    while (self.dataArray.count < 10) {
        PersonCenterUserModel * model = [[PersonCenterUserModel alloc]init];
        model.nick_name = [NSString stringWithFormat:ASLocalizedString(@"王%d明"),arc4random_uniform(30)];
        [self.dataArray addObject:model];
    }
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return 5;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReleaseAtPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReleaseAtPeopleCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.user = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //block
    
    !self.releaseAtPeopleBlock?:self.releaseAtPeopleBlock(self.dataArray[indexPath.row]);
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
