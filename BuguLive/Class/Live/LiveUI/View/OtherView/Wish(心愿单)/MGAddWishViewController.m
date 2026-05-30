//
//  MGAddWithViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGAddWishViewController.h"

@interface MGAddWishViewController ()<UITableViewDelegate,UITableViewDataSource,MGLiveAddWishCellDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *listArr;
//@property(nonatomic, strong) NSMutableArray *listGiftArr;
//@property(nonatomic, strong) NSMutableArray *listWishArr;

@property(nonatomic, strong) MGLiveWishModel *model;

@end

@implementation MGAddWishViewController

-(instancetype)initWithWishType:(MGADD_WISH)wishType{
    MGAddWishViewController *vc = [MGAddWishViewController new];
    vc.wishType = wishType;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setModel];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    UILabel *titleL = [UILabel new];
    titleL.frame = CGRectMake(0, MG_TOP_MARGIN + 4, kScreenW / 2, kRealValue(44));
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.centerX = kScreenW / 2;
    titleL.text = self.wishType == MGWISHTYPE_ADD ? ASLocalizedString(@"添加礼物和数量"): ASLocalizedString(@"选择礼物");
    titleL.text = self.wishType == MGWISHTYPE_LIST ? ASLocalizedString(@"心愿单"): titleL.text;
    titleL.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleL];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - kRealValue(80), MG_TOP_MARGIN, kRealValue(80), kNavigationBarHeight)];
    //     [rightButton setImage:[UIImage imageNamed:@"hm_search"] forState:UIControlStateNormal];
     [rightButton setTitle:ASLocalizedString(@"完成")forState:UIControlStateNormal];
     [rightButton setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
     [rightButton addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    // 左上角按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(20, MG_TOP_MARGIN + 4, 35, kNavigationBarHeight)];
    [leftButton setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLefttBtn:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:leftButton];

    self.view.backgroundColor = kWhiteColor;
    [self setUpView];
    if (self.wishType == MGWISHTYPE_ADD_GIFT || self.wishType == MGWISHTYPE_LIST) {
        self.tableView.height = kScreenH - kTopHeight;
        rightButton.hidden = YES;
    }
}


-(void)setModel{
    self.listArr = [NSMutableArray array];
    if (self.wishType == MGWISHTYPE_ADD_GIFT) {
        self.model = [MGLiveWishModel new];
    }else{
        
    }
    self.model = [MGLiveWishModel new];
    [self requestModel];
}

-(void)requestModel{

        //4-16 3.心愿单无效。
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

        NSString *actStr = @"";
    //     //心愿单礼物列表
        if (self.wishType == MGWISHTYPE_ADD_GIFT) {
            actStr = @"gift_list";
        }else if (self.wishType == MGWISHTYPE_LIST){
            actStr = @"wish_list";
            [mDict setObject:_roomId forKey:@"room_id"];
        }
        
        if ([BGUtils isBlankString:actStr]) {
            return;
        }
    [mDict setObject:@"user_wish" forKey:@"ctl"];
    [mDict setObject:actStr forKey:@"act"];

    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] == 1)
        {

            [self.listArr removeAllObjects];
            NSArray *arr = [responseJson valueForKey:@"list"];
            if (arr.count > 0) {
                for (NSDictionary *dic in arr)
                {
                    
                    MGLiveWishModel *model = [MGLiveWishModel mj_objectWithKeyValues:dic];
                    [self.listArr addObject:model];
                }
            }
            [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {

    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)clickRightBtn:(UIBarButtonItem *)item{
    MGLiveAddWishCell *numCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    MGLiveAddWishCell *txtCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    self.model.g_num = numCell.textField.text;
    self.model.txt = txtCell.textField.text;
    if ([BGUtils isBlankString:self.model.g_id]) {
        [FanweMessage alert:ASLocalizedString(@"请选择礼物")];
        return;
    }
    if ([BGUtils isBlankString:self.model.g_num]) {
        [FanweMessage alert:ASLocalizedString(@"请填写礼物数量")];
        return;
    }

    if ([BGUtils isBlankString:self.model.txt]) {
        self.model.txt = @"";
    }
    
    
    if (self.clickGiftCellBlcok) {
        self.clickGiftCellBlcok(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)clickLefttBtn:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)protocolClickLiveAddWishModel:(MGLiveWishModel *)model{
    self.model.g_id = model.id;
}

-(void)setUpView{
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.wishType == MGWISHTYPE_ADD ? 3 : self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.wishType == MGWISHTYPE_LIST) {
        return kRealValue(185);
    }
    return kRealValue(44);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MGLiveAddWishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGLiveAddWishCell"];
    if (self.wishType == MGWISHTYPE_ADD){
        MGLiveAddWishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGLiveAddWishCell"];
        cell.delegate = self;
        [cell resetCellWithWishType:self.wishType WithModel:nil];
        NSArray *arr = @[ASLocalizedString(@"选择礼物"),ASLocalizedString(@"添加数量"),ASLocalizedString(@"报答方式(选填)")];
        NSArray *placeHolderArr = @[ASLocalizedString(@"无"),ASLocalizedString(@"数量最多输入5个"),ASLocalizedString(@"编辑8字以内")];
        cell.topicL.text = arr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.enabled = indexPath.row != 0;
        if (indexPath.row == 1) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        cell.textField.placeholder = placeHolderArr[indexPath.row];
        cell.textFieldBlock = ^(NSString * _Nonnull str) {
            if (indexPath.row == 1) self.model.g_num = str;
            if (indexPath.row == 2) self.model.txt = str;
        };
        return cell;
    }else if (self.wishType == MGWISHTYPE_ADD_GIFT) {
        MGLiveAddWishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGLiveAddWishCell"];
        [cell resetCellWithWishType:self.wishType WithModel:self.listArr[indexPath.row]];
        return cell;
        
    }else if (self.wishType == MGWISHTYPE_LIST){
        MGLiveWishListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGLiveWishListCell"];
        [cell resetCellWithWishType:self.wishType WithModel:self.listArr[indexPath.row]];
        NSString *str = ASLocalizedString(@"心愿一");
        if (indexPath.row == 1) {
            str = ASLocalizedString(@"心愿二");
        }else if (indexPath.row == 2){
            str = ASLocalizedString(@"心愿三");
        }
        cell.titleL.text = str;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    if (indexPath.row == 0 && self.wishType == MGWISHTYPE_ADD) {
        MGAddWishViewController *vc = [[MGAddWishViewController alloc]initWithWishType:MGWISHTYPE_ADD_GIFT];
        vc.clickGiftCellBlcok = ^(MGLiveWishModel * _Nonnull wishModel) {
            weakSelf.model = wishModel;
            weakSelf.model.g_id = wishModel.id;
            weakSelf.model.g_icon = wishModel.icon;
            weakSelf.model.g_name = wishModel.name;
            MGLiveAddWishCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textField.text = wishModel.name;
            [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:wishModel.icon] placeholderImage:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (self.wishType == MGWISHTYPE_ADD_GIFT) {//点击选择礼物后返回
        MGLiveWishModel *model = self.listArr[indexPath.row];
        if (self.clickGiftCellBlcok) {
            self.clickGiftCellBlcok(model);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenW, kScreenH / 2 - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MGLiveAddWishCell class] forCellReuseIdentifier:@"MGLiveAddWishCell"];
        [_tableView registerClass:[MGLiveWishListCell class] forCellReuseIdentifier:@"MGLiveWishListCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
