//
//  BogoSearchSubViewController.m
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchSubViewController.h"
#import "BogoSearchHeaderView.h"
#import "FollowerTableViewCell.h"
#import "WBStatusCell.h"
#import "BogoSearchVideoListCell.h"
#import "BogoSearchResultModel.h"
#import "SHomePageVC.h"
#import "DetailsLineViewController.h"
#import "MGGroupUserInfo.h"
#import "HMVideoPlayerViewController.h"
#import "YHPlayerViewController.h"
#import "YYPhotoGroupView.h"

@interface BogoSearchSubViewController ()<UITableViewDelegate,UITableViewDataSource,BogoSearchHeaderViewDelegate,BogoSearchVideoListCellDelegate,WBStatusCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <SenderModel *>*userDataArray;
@property(nonatomic, strong) NSMutableArray *videoDataArray;
@property(nonatomic, strong) NSMutableArray <WBStatusLayout *>*dynamicDataArray;
@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoSearchSubViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    [self headerRefresh];
}

- (void)headerRefresh{
    self.page = 1;
    [self requestData];
}

- (void)footerRefresh{
    self.page = self.page + 1;
    [self requestData];
}

- (void)requestData{
//    /mapi/index.php?ctl=index&act=search_all&keyword=夏&type=0
    [self.httpsManager POSTWithParameters:[NSMutableDictionary dictionaryWithDictionary:@{@"ctl":@"index",@"act":@"search_all",@"keyword":self.keyword,@"type":@(self.type),@"page":@(self.page)}] SuccessBlock:^(NSDictionary *responseJson) {
        if (self.page == 1) {
            [self.userDataArray removeAllObjects];
            [self.videoDataArray removeAllObjects];
            [self.dynamicDataArray removeAllObjects];
        }
        if ([responseJson toInt:@"status"] == 1) {
            BogoSearchResultModel *model = [BogoSearchResultModel mj_objectWithKeyValues:responseJson];
            if (self.type == BogoSearchSubViewControllerTypeAll) {
                [self.userDataArray addObjectsFromArray:model.user];
                [self.videoDataArray addObjectsFromArray:model.weibo];
                for (WBModel *status in model.dynamic) {
                    WBStatusLayout *layout = [[WBStatusLayout alloc]initWithStatus:status style:WBLayoutStyleTimeline];
                    [self.dynamicDataArray addObject:layout];
                }
            }else if (self.type == BogoSearchSubViewControllerTypeUser){
                [self.userDataArray addObjectsFromArray:model.user];
            }else if (self.type == BogoSearchSubViewControllerTypeVideo){
                [self.videoDataArray addObjectsFromArray:model.weibo];
            }else if (self.type == BogoSearchSubViewControllerTypeDynamic){
                for (WBModel *status in model.dynamic) {
                    WBStatusLayout *layout = [[WBStatusLayout alloc]initWithStatus:status style:WBLayoutStyleTimeline];
                    [self.dynamicDataArray addObject:layout];
                }
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        int has_next = [responseJson toInt:@"has_next"];
        if (has_next) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance]tipMessage:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - FD_Top_Height - 40) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height, 0);
        [_tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:@"WBStatusCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"FollowerTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FollowerTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"BogoSearchVideoListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoSearchVideoListCell"];
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    }
    return _tableView;
}

#pragma mark - BogoSearchVideoListCellDelegate
- (void)videoListCell:(BogoSearchVideoListCell *)videoListCell didClickVideo:(SmallVideoListModel *)model{
    HMVideoPlayerViewController *vc = [[HMVideoPlayerViewController alloc]initWithVideos:self.videoDataArray index:[self.videoDataArray indexOfObject:model] IsPushed:YES requestDict:nil];
    vc.isRefreshVideoBlock = ^(BOOL isRefresh) {
        [self headerRefresh];
    };
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

#pragma mark - BogoSearchHeaderViewDelegate
- (void)headerView:(BogoSearchHeaderView *)headerView didClickAllBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(subVC:headerView:didClickAllBtn:)]) {
        [self.delegate subVC:self headerView:headerView didClickAllBtn:sender];
    }
}

#pragma mark - WBStatusCellDelegate
/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell {
    if (self.dynamicDataArray.count > 0) {
        MGGroupUserInfo *model = (MGGroupUserInfo *)cell.layout.status;
        DetailsLineViewController *datails = [DetailsLineViewController new];
        datails.title = ASLocalizedString(@"动态详情");
        datails.model = model;

        datails.refreshData = ^{
            [self headerRefresh];
//            self.logic.page = _currentRequestPage;
//            [self.logic loadListDataWithAct:self.homeType];
        };

        [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

        [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
    }
}

/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUserInfoModel *)user {
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = cell.statusView.layout.status.uid;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
}

//点击了关注
- (void)cell:(WBStatusCell *)cell didClickMore:(UIButton *)sender{
    
    WBModel *model = cell.layout.status;
    
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
      [parmDict setObject:@"user" forKey:@"ctl"];
      [parmDict setObject:@"follow" forKey:@"act"];
      [parmDict setObject:SafeStr(model.uid) forKey:@"to_user_id"];
          
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            
            model.is_focus = @"1";
            cell.statusView.layout.status = model;
            
            [self.dynamicDataArray replaceObjectAtIndex:cell.indexRows withObject:cell.statusView.layout];
            sender.hidden = YES;
       }else{
           [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
       }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
}
/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell {
    
    WBModel *model = cell.statusView.layout.status;
    
    DetailsLineViewController *datails = [DetailsLineViewController new];
    datails.hidesBottomBarWhenPushed = YES;
    datails.title = ASLocalizedString(@"评论");
    datails.model = (MGGroupUserInfo *)model;
    
    datails.refreshData = ^{
        [self headerRefresh];
        
    };
    [self.navigationController pushViewController:datails animated:YES];
}

-(void)cell:(WBStatusCell *)cell didClickDeleteBtn:(UIButton *)sender{
    __weak __typeof(self)weakSelf = self;

    
    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"确定删除该动态?")destructiveAction:^{
           
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"dynamic" forKey:@"ctl"];
        [parmDict setObject:@"del_dynamic" forKey:@"act"];
        
        [parmDict setObject:cell.layout.status.id forKey:@"dynamic_id"];
        
        FWWeakify(self)
        
        [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
                
                [FanweMessage alertHUD:ASLocalizedString(@"删除动态成功")];
            }else{
                
                [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
            }
            
            [self headerRefresh];
            
        } FailureBlock:^(NSError *error) {
            
        }];
           
    } cancelAction:^{

    }];
    
    

}

/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell {
    __weak __typeof(self)weakSelf = self;
    WBModel *status = cell.statusView.layout.status;
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"praise" forKey:@"act"];
    
    [parmDict setObject:SafeStr(status.id) forKey:@"dynamic_id"];
    NSString *like = !status.is_like.integerValue ? @"1" : @"2";
    [parmDict setObject:like forKey:@"is_praise"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSInteger  praise = [status.praise integerValue];
        
        if ([[responseJson valueForKey:@"status"]integerValue] == 1) {
            
            [cell.statusView.toolbarView setLiked:[[responseJson valueForKey:@"is_like"]intValue] withAnimation:YES];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma 视频相关

- (void)cell:(WBStatusCell *)cell didClickVideo:(NSString *)url{
    
    YHPlayerViewController *vc = [[YHPlayerViewController alloc]initWithPlayerURL:cell.layout.status.video];
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    
}

/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBModel *status = cell.statusView.layout.status;
    NSArray<NSString *> *pics = status.picUrls;
    NSArray<NSString *> *originPics = status.picUrls;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:originPics[i]];
        item.largeImageSize = CGSizeMake(kScreenW, kScreenH);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        if (section == 0) {
            return self.userDataArray.count;
        }else if (section == 1){
            return self.videoDataArray.count ? 1 : 0;
        }else if (section == 2){
            return self.dynamicDataArray.count ? 2 : 0;
        }else{
            return 0;
        }
    }else if (self.type == BogoSearchSubViewControllerTypeUser){
        return self.userDataArray.count;
    }else if (self.type == BogoSearchSubViewControllerTypeDynamic){
        return self.dynamicDataArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        if (indexPath.section == 0) {
            FollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerTableViewCell" forIndexPath:indexPath];
            if (indexPath.row < self.userDataArray.count) {
                [cell creatCellWithModel:self.userDataArray[indexPath.row] WithRow:indexPath.row];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section == 1){
            BogoSearchVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoSearchVideoListCell" forIndexPath:indexPath];
            if (self.videoDataArray.count) {
                
                if (self.videoDataArray.count > 2) {
                    NSMutableArray *dataArr = [NSMutableArray array];
                    [dataArr addObject:self.videoDataArray[0]];
                    [dataArr addObject:self.videoDataArray[1]];
                    cell.dataArray = dataArr;
                }else{
                    
                    cell.dataArray = self.videoDataArray;
                }
                
                
                
                
            }
            cell.delegate = self;
            return cell;
        }else if (indexPath.section == 2){
            WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WBStatusCell" forIndexPath:indexPath];
            if (indexPath.row < self.dynamicDataArray.count) {

                
//                if (self.dynamicDataArray.count > 2) {
//                    NSMutableArray *dataArr = [NSMutableArray array];
//                    [dataArr addObject:self.dynamicDataArray[0]];
//                    [dataArr addObject:self.dynamicDataArray[1]];
//                    cell.layout = dataArr[indexPath.row];
//                }else{
                    
                    cell.layout = self.dynamicDataArray[indexPath.row];
//                }
                
                
                
            }
            cell.delegate = self;
            return cell;
        }else{
            return nil;
        }
    }else if (self.type == BogoSearchSubViewControllerTypeUser){
        FollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerTableViewCell" forIndexPath:indexPath];
        if (indexPath.row < self.userDataArray.count) {
            [cell creatCellWithModel:self.userDataArray[indexPath.row] WithRow:indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.type == BogoSearchSubViewControllerTypeDynamic){
        WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WBStatusCell" forIndexPath:indexPath];
        if (indexPath.row < self.dynamicDataArray.count) {
            cell.layout = self.dynamicDataArray[indexPath.row];
        }
        cell.delegate = self;
        return cell;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        if (indexPath.section == 0) {
            return 71;
        }else if (indexPath.section == 1){
            return 291;
        }else if (indexPath.section == 2){
            return self.dynamicDataArray[indexPath.row].height;
        }else{
            return 0;
        }
    }else if (self.type == BogoSearchSubViewControllerTypeUser){
        return 71;
    }else if (self.type == BogoSearchSubViewControllerTypeDynamic){
        return self.dynamicDataArray[indexPath.row].height;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        if (indexPath.section == 0) {
            SenderModel *sModel = self.userDataArray[indexPath.row];
            SHomePageVC *homeVC = [[SHomePageVC alloc]init];
            homeVC.user_id = sModel.user_id;
            homeVC.type = 0;
        //    homeVC.user_nickname = sModel.nick_name;
        //    homeVC.user_headimg = sModel.head_image;
            [self.navigationController pushViewController:homeVC animated:YES];
        }else if (indexPath.section == 2){
            MGGroupUserInfo *model = self.dynamicDataArray[indexPath.row];
            DetailsLineViewController *datails = [DetailsLineViewController new];
            datails.title = ASLocalizedString(@"动态详情");
            datails.model = model;

            datails.refreshData = ^{
    //            self.logic.page = _currentRequestPage;
    //            [self.logic loadListDataWithAct:self.homeType];
                [self headerRefresh];
            };

            [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
        }
    }else if (self.type == BogoSearchSubViewControllerTypeUser){
        SenderModel *sModel = self.userDataArray[indexPath.row];
        SHomePageVC *homeVC = [[SHomePageVC alloc]init];
        homeVC.user_id = sModel.user_id;
        homeVC.type = 0;
    //    homeVC.user_nickname = sModel.nick_name;
    //    homeVC.user_headimg = sModel.head_image;
        [self.navigationController pushViewController:homeVC animated:YES];
    }else if (self.type == BogoSearchSubViewControllerTypeDynamic){
        MGGroupUserInfo *model = self.dynamicDataArray[indexPath.row];
        DetailsLineViewController *datails = [DetailsLineViewController new];
        datails.title = ASLocalizedString(@"动态详情");
        datails.model = model;

        datails.refreshData = ^{
//            self.logic.page = _currentRequestPage;
//            [self.logic loadListDataWithAct:self.homeType];
            [self headerRefresh];
        };

        [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        BogoSearchHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"BogoSearchHeaderView" owner:nil options:nil].lastObject;
        headerView.type = section;
        headerView.delegate = self;
        if (self.type == BogoSearchSubViewControllerTypeAll) {
            if (section == 0) {
                
                headerView.allBtn.hidden = self.userDataArray.count > 2 ? NO : YES;
            }else if (section == 1){
                
                headerView.allBtn.hidden = self.videoDataArray.count > 2 ? NO : YES;
            }else if (section == 2){
                headerView.allBtn.hidden = self.dynamicDataArray.count > 2 ? NO : YES;
                
            }
        }
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type == BogoSearchSubViewControllerTypeAll) {
        return 44;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSMutableArray<SenderModel *> *)userDataArray{
    if (!_userDataArray) {
        _userDataArray = [NSMutableArray array];
    }
    return _userDataArray;
}

- (NSMutableArray *)videoDataArray{
    if (!_videoDataArray) {
        _videoDataArray = [NSMutableArray array];
    }
    return _videoDataArray;
}

- (NSMutableArray<WBStatusLayout *> *)dynamicDataArray{
    if (!_dynamicDataArray) {
        _dynamicDataArray = [NSMutableArray array];
    }
    return _dynamicDataArray;
}

@end
