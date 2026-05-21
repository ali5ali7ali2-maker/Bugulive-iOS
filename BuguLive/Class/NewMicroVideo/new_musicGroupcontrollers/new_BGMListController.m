//
//  new_BGMListController.m
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "new_BGMListController.h"

@interface new_BGMListController ()<new_bgmSureDelegate,new_bgmcategoryDelegate,UITextFieldDelegate>
{
    UIButton *leftBtn,*RecommendBTn,*FindBtn,*collectionBTn,*searchCancelBtn;
    UILabel *titleLa;
    UIView *contentView;
    UITextField *searchField;
    int findPage,Recommendpage,collectionpage,typepage;
}

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)new_bgmListView *musicListview,*searchListview;
@property (nonatomic, strong)new_BGMcategory *musiccategoryview;


@end

@implementation new_BGMListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kBlackColor;
    findPage =1;
    Recommendpage =1;
    collectionpage =1;
    typepage =1;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawContent];
    if (_type_id)
    {
        [self getTypeList];
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden =YES;
}
- (void)leftAction
{
    if (self.navigationController.viewControllers.count >1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)ListAction:(UIButton *)sender
{
    __block typeof(self)blockself =self;
    switch (sender.tag)
    {
        case 1:
        {
            RecommendBTn.selected =YES;
            FindBtn.selected =NO;
            collectionBTn.selected =NO;
            self.headerView.frame =CGRectMake(0, 0, kScreenW, 120 );
            self.musicListview.tableview.tableHeaderView =self.headerView;
        }
            break;
        case 2:
        {
            RecommendBTn.selected =NO;
            FindBtn.selected =YES;
            collectionBTn.selected =NO;
        }
            break;
        case 3:
        {
            RecommendBTn.selected =NO;
            FindBtn.selected =NO;
            collectionBTn.selected =YES;
            self.headerView.frame =CGRectMake(0, 0, kScreenW, 120);
                            self.musicListview.tableview.tableHeaderView =self.headerView;
        }
            break;
        default:
            break;
    }
    if (sender.tag ==1 )
    {
        [self getrecommendList];
    }
    if (sender.tag ==2)
    {
//        //发现
//        if(self.musiccategoryview.dataSource.count <=0)
//        {
//            //执行请求分类菜单
//            [Music_manager MusicManagerget_type_list:^(id response) {
//                if (response && [response isKindOfClass:[NSArray class]])
//                {
//                    NSArray *datasource =response;
//                    [blockself showWithFindHeader:datasource];
//                }
//                [blockself getFindList];
//            }];
//        }else
//        {
//            [blockself showWithFindHeader:self.musiccategoryview.dataSource];
//            [self getFindList];
//        }
    }
    if (sender.tag ==3)
    {
        [self getmusic_collection];
    }
}
//发现头部的显示数据
- (void)showWithFindHeader:(NSArray *)datasource
{
    CGFloat need_h =0;
    if (datasource.count%4 !=0)
    {
        need_h =(kScreenW-4) /4*(datasource.count/4 +1);
    }else
    {
        need_h =(kScreenW-4) /4*datasource.count/4;
    }
    self.musiccategoryview.frame =CGRectMake(0, 120, _headerView.width, need_h);
    self.headerView.frame =CGRectMake(0, 0, kScreenW, 120 +need_h);
    self.musiccategoryview.dataSource =datasource;
    self.musiccategoryview.delegate =self;
    self.musicListview.tableview.tableHeaderView =self.headerView;
}
//发现列表数据
- (void)getFindList
{
    __block typeof(self)blockself =self;
    Recommendpage =1;
    collectionpage =1;
//    //执行发现下音乐列表
//    [Music_manager MusicManagerget_find_music:findPage andcallback:^(id response) {
//        if (response && [response isKindOfClass:[NSArray class]])
//        {
//            [blockself.musicListview setDatasource:response andPage:blockself->findPage];
//            NSArray *responseData =response;
//            if (responseData.count>=20)
//            {
//                blockself->findPage ++;
//            }
//        }
//    }];
}
//推荐列表数据
- (void)getrecommendList
{
    __block typeof(self)blockself =self;
    findPage =1;
    collectionpage =1;
//    //执行发现下音乐列表
//    [Music_manager MusicManagerget_recommend_music:findPage andcallback:^(id response) {
//        if (response && [response isKindOfClass:[NSArray class]])
//        {
//            [blockself.musicListview setDatasource:response andPage:blockself->Recommendpage];
//            NSArray *responseData =response;
//            if (responseData.count>=20)
//            {
//                blockself->Recommendpage ++;
//            }
//        }
//    }];
}
//收藏列表的数据
- (void)getmusic_collection
{
    __block typeof(self)blockself =self;
    findPage =1;
    Recommendpage =1;
//    //执行发现下音乐列表
//    [Music_manager MusicManagerget_my_collection:collectionpage  andcallback:^(id response) {
//        if (response && [response isKindOfClass:[NSArray class]])
//        {
//            [blockself.musicListview setDatasource:response andPage:blockself->collectionpage];
//            NSArray *responseData =response;
//            if (responseData.count>=20)
//            {
//                blockself->collectionpage ++;
//            }
//        }
//    }];
}
//类别下的数据列表
- (void)getTypeList
{
    __block typeof(self)blockself =self;
//    //执行发现下音乐列表
//    [Music_manager MusicManagerGetget_music_listWithid:_type_id page:typepage  andcallback:^(id response) {
//        if (response && [response isKindOfClass:[NSArray class]])
//        {
//            [blockself.musicListview setDatasource:response andPage:blockself->typepage];
//            NSArray *responseData =response;
//            if (responseData.count>=20)
//            {
//                blockself->typepage ++;
//            }
//        }
//    }];
}
//根据搜索键来获取音乐列表
- (void)searchWithMusic:(NSString *)key
{
    __block typeof(self)blockself =self;
//    [Music_manager MusicManagerserchWithkey:key page:1 andcallback:^(id response) {
//        if (response && [response isKindOfClass:[NSArray class]])
//        {
//            [blockself.searchListview setDatasource:response andPage:1];
//            NSArray *responseData =response;
//            if (responseData.count>=20)
//            {
//
//            }
//        }
//    }];
}
- (void)SearchcancelAction
{
    [self searchListview].hidden =YES;
    searchField.text =@"";
    [searchField resignFirstResponder];
}
#pragma 代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [searchField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-160 );
    }];
    [self searchListview].hidden =NO;
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [searchField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-30 );
    }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchWithMusic:textField.text];
    return YES;
}
- (void)SureUseobj:(music_obj *)model
{
    if (model)
    {
        __block typeof(self)blockself =self;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [blockself.musicListview.player pause];
            blockself.nav.useMusicBlock(model);
        }];
    }
}
- (void)itemSelect:(new_bgmcategoryModel *)model
{
    new_BGMListController *vc =[new_BGMListController new];
    vc.nav =self.nav;
    vc.type_id =model.type_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma 懒加载
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
        _headerView.layer.masksToBounds =YES;
        RecommendBTn =[[UIButton alloc]init];
        [_headerView addSubview:RecommendBTn];
        [RecommendBTn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(90));
            make.top.equalTo(_headerView).offset(30);
        }];
        [RecommendBTn setTitle:ASLocalizedString(@"推荐")forState:0];
        RecommendBTn.tag =1;
        [RecommendBTn setTitleColor:kGrayColor forState:0];
        [RecommendBTn setTitleColor:kBlackColor forState:UIControlStateSelected];
        FindBtn =[[UIButton alloc]init];
        [_headerView addSubview:FindBtn];
        [FindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(90));
            make.top.equalTo(_headerView).offset(30);
        }];
        [FindBtn setTitle:ASLocalizedString(@"发现")forState:0];
        FindBtn.tag =2;
        [FindBtn setTitleColor:kGrayColor forState:0];
        [FindBtn setTitleColor:kBlackColor forState:UIControlStateSelected];
        collectionBTn =[[UIButton alloc]init];
        [_headerView addSubview:collectionBTn];
        [collectionBTn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(90));
            make.top.equalTo(_headerView).offset(30);
        }];
        [collectionBTn setTitle:ASLocalizedString(@"收藏")forState:0];
        collectionBTn.tag =3;
        [collectionBTn setTitleColor:kGrayColor forState:0];
        [collectionBTn setTitleColor:kBlackColor forState:UIControlStateSelected];
        NSArray *btnary =@[RecommendBTn,FindBtn,collectionBTn];
        [btnary mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:100 tailSpacing:100];
        [RecommendBTn addTarget:self action:@selector(ListAction:) forControlEvents:UIControlEventTouchUpInside];
        [FindBtn addTarget:self action:@selector(ListAction:) forControlEvents:UIControlEventTouchUpInside];
        [collectionBTn addTarget:self action:@selector(ListAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:self.musiccategoryview];
        self.musiccategoryview.frame =CGRectMake(0, 120, _headerView.width, 0);
        [self ListAction:FindBtn];
    }
    return _headerView;
}
- (new_BGMcategory *)musiccategoryview
{
    if (!_musiccategoryview)
    {
        _musiccategoryview =[[new_BGMcategory alloc]init];
    }
    return _musiccategoryview;
}

- (new_bgmListView *)searchListview
{
    if (!_searchListview)
    {
        _searchListview =[[new_bgmListView alloc]init];
        [contentView addSubview:_searchListview];
        [_searchListview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.bottom.centerX.equalTo(contentView);
            if (searchField)
            {
                make.top.equalTo(searchField.mas_bottom);
            }else
            {
                make.top.equalTo(contentView).offset(90);
            }
        }];
        _searchListview.delegate =self;
        _searchListview.backgroundColor =kWhiteColor;
    }
    [_searchListview bringSubviewToFront:contentView];
    return _searchListview;
}

- (new_bgmListView *)musicListview
{
    if (!_musicListview)
    {
        _musicListview =[[new_bgmListView alloc]init];
        [contentView addSubview:_musicListview];
        [_musicListview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.bottom.centerX.equalTo(contentView);
            if (searchField)
            {
                make.top.equalTo(searchField.mas_bottom);
            }else
            {
                make.top.equalTo(contentView).offset(90);
            }
        }];
        _musicListview.delegate =self;
        if (!_type_id)
        {
            _musicListview.tableview.tableHeaderView =self.headerView;
        }
    }
    return _musicListview;
}
- (void)drawContent
{
    if (!contentView)
    {
        contentView =[[UIView alloc]init];
        [self.view addSubview:contentView];
        NSLog(@"%.2f",kStatusBarHeight);
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.height.equalTo(self.view);
            make.top.mas_equalTo(kStatusBarHeight);
        }];
        contentView.layer.cornerRadius =10.;
        contentView.backgroundColor =kWhiteColor;
        leftBtn =[UIButton new];
        [contentView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.top.equalTo(contentView);
            make.width.height.equalTo(@(90));
        }];
        if (_type_id)
        {
            [leftBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:0];
        }else
        {
            [leftBtn setImage:[UIImage imageNamed:@"new_bgm_close"] forState:0];
        }
        
        [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        titleLa =[UILabel new];
        [contentView addSubview:titleLa];
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftBtn);
            make.height.equalTo(leftBtn);
            make.centerX.width.equalTo(contentView);
        }];
        titleLa.textColor =kBlackColor;
        titleLa.font =[UIFont fontWithName:@"Helvetica-Bold" size:18.];
        titleLa.textAlignment =1;
        titleLa.text =ASLocalizedString(@"选择音乐");
        if (!_type_id)
        {
            searchField =[[UITextField alloc]init];
            [contentView addSubview:searchField];
            [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(leftBtn.mas_bottom).offset(30);
                make.left.equalTo(contentView).offset(30);
                make.right.equalTo(contentView).offset(-30 );
                make.height.equalTo(@(70));
            }];
            searchField.backgroundColor =UIColorFromRGB(0xf1f1f1);
            searchField.textAlignment =0;
            searchField.delegate =self;
            searchField.attributedPlaceholder =[self backplaceholder];
            searchField.layer.cornerRadius =2.;
            
            searchCancelBtn =[UIButton new];
            [contentView addSubview:searchCancelBtn];
            [searchCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(searchField.mas_right).offset(30);
                make.centerY.height.equalTo(searchField);
                make.width.equalTo(@(130));
            }];
            [searchCancelBtn setTitle:ASLocalizedString(@"取消")forState:0];
            [searchCancelBtn setTitleColor:UIColorFromRGB(0xfb3763) forState:0];
            searchCancelBtn.titleLabel.font =[UIFont systemFontOfSize:15.];
            [searchCancelBtn addTarget:self action:@selector(SearchcancelAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [self musicListview];
    }
}
- (NSAttributedString *)backplaceholder
{
    NSMutableAttributedString *backattr =[NSMutableAttributedString new];
    NSTextAttachment *img =[[NSTextAttachment alloc]init];
    img.image =[UIImage imageNamed:@"ic_edit_search_gray"];
    img.bounds =CGRectMake(0, -2, 15, 15);
    NSAttributedString *imgattr =[NSAttributedString attributedStringWithAttachment:img];
    NSAttributedString *strattr =[[NSAttributedString alloc]initWithString:ASLocalizedString(@" 搜索音乐")attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.],NSForegroundColorAttributeName:kGrayColor}];
    [backattr appendAttributedString:imgattr];
    [backattr appendAttributedString:strattr];
    return backattr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    NSLog(@"musicListview%@",self.musicListview);
//    NSLog(@"%@",self.musicListview.player);
//
//    NSLog(@"searchListview%@",self.searchListview);
//    NSLog(@"%@",self.searchListview.player);
    
    [self.musicListview.player pause];
    [self.searchListview.player pause];
//    if (self.searchListview.player) {
    
//    self.searchListview.player = nil;
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
