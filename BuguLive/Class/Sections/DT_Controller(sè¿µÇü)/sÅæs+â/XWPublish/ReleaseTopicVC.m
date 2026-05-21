//
//  ReleaseTopicVC.m
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "ReleaseTopicVC.h"
#import "ReleaseTopicCell.h"

@interface ReleaseTopicVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property ( nonatomic,assign) int                        page;

@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic, strong) UITextField *myTextFiled;

@end

@implementation ReleaseTopicVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
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
    
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索框"]];
    //    imageView.contentMode = UIViewContentModeScaleToFill
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12 + MG_TOP_MARGIN);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(32);
        make.right.equalTo(self.closeBtn.mas_left).offset(-25);
    }];
    imageView.userInteractionEnabled = YES;
    
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(imageView.mas_centerY);
    }];
    
    UIImageView * imageViewTopic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"话题"]];
    
    [imageView addSubview:imageViewTopic];
    
    [imageViewTopic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(13);
        //           make.right.equalTo(self.closeBtn.mas_left).offset(25);
        
        
    }];
    
    
    [imageView addSubview:self.myTextFiled];
    self.myTextFiled.textAlignment = NSTextAlignmentLeft;
    
    [self.myTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.mas_equalTo(36);
        make.right.mas_equalTo(-10);
        //           make.right.equalTo(self.closeBtn.mas_left).offset(25);
        
        
    }];
    
    
}

- (void)closeButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self.tableView registerClass:[ReleaseTopicCell class] forCellReuseIdentifier:NSStringFromClass([ReleaseTopicCell class])];
    //    [self.tableView registerClass:[CellForWorkGroupRepost class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroupRepost class])];
    
    
    //    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
    [self requestData];
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
- (void)requestData{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"dynamic_theme" forKey:@"act"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray * array = responseJson[@"data"];
        for (id obj in array)
        {
            MGDynamicTopicModel *model =[MGDynamicTopicModel mj_objectWithKeyValues:obj];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

- (void)configureData{
    
    //    while (self.dataArray.count < 10) {
    //        DTTopicModel * model = [[DTTopicModel alloc]init];
    //        model.title = [NSString stringWithFormat:ASLocalizedString(@"话题%d"),arc4random_uniform(30)];
    //        [self.dataArray addObject:model];
    //    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReleaseTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReleaseTopicCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topic = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.myTextFiled resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    //将TopicModel传递过去
    !self.releaseTopicBlock?:self.releaseTopicBlock(self.dataArray[indexPath.row]);
}





- (void)textFieldDidChange:(UITextField*) sender
{
    //        [self loadNetDataWithPage:_currentPage andTextFiledStr:sender.text];
}



- (UITextField *)myTextFiled
{
    if (!_myTextFiled)
    {
        _myTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(35*kScaleWidth, (44-25*kScaleWidth)/2, kScreenW -110*kScaleWidth, 25*kScaleWidth)];
        _myTextFiled.backgroundColor = kClearColor;
        //        _myTextFiled.layer.cornerRadius = 25*kScaleWidth/2;
        _myTextFiled.textAlignment = NSTextAlignmentCenter;
        _myTextFiled.font = [UIFont systemFontOfSize:14];
        _myTextFiled.delegate = self;
        [_myTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _myTextFiled.clearsOnBeginEditing = NO;
        //        _myTextFiled.clearsContextBeforeDrawing = YES;
        _myTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _myTextFiled.leftViewMode = UITextFieldViewModeAlways;//设置左边距显示的时机，这个表示一直显示
        _myTextFiled.placeholder = ASLocalizedString(@"话题搜索");
    }
    return _myTextFiled;
}
@end
