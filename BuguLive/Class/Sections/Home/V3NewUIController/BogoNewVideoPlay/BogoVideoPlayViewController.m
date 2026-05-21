//
//  BogoVideoPlayViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/20.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoVideoPlayViewController.h"
#import "BogoVideoPlayCell.h"
#import "BogoVideoModel.h"
@interface BogoVideoPlayViewController ()<BogoVideoTableViewCellDelegate,BogoVideoTableViewCellDataSource>

@property(nonatomic, strong) NSMutableArray<BogoVideoModel *> *listArr;

@end

@implementation BogoVideoPlayViewController

- (instancetype)initWithModelArr:(NSMutableArray *)arr{
    BogoVideoPlayViewController *vc = [BogoVideoPlayViewController new];
    vc.listArr = arr;
    return vc;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTable];
    [self setUpPlayerView];
    
//    _player.URLAsset = [[BogoVideoPlayerURLAsset alloc] initWithURL:URL playModel:[BogoPlayModel playModelWithTableView:_tableView indexPath:indexPath]];

}

-(void)setUpPlayerView{
//    _player = SJVideoPlayer.player;
//    [self.view addSubview:_player.view];
//    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        } else {
//            make.top.offset(20);
//        }
//        make.left.right.offset(0);
//        make.height.equalTo(self.player.view.mas_width).multipliedBy(9/16.0);
//    }];
}

-(void)setUpTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [BogoVideoPlayCell registerWithTableView:_tableView];
 
//    // 创建测试数据
//    _listArr = NSMutableArray.array;
//    __auto_type items = [BogoVideoModel testItemsWithCount:3];
//    for ( BogoVideoModel *item in items ) {
//        [_listArr addObject:[BogoVideoModel alloc] init];
////                   WithItem:item]];
//    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
//    [_listArr[indexPath.row] height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BogoVideoPlayCell cellWithTableView:tableView indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BogoVideoPlayCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.dataSource = _listArr[indexPath.row];
    cell.delegate = self;
}


- (BOOL)shouldAutorotate {
    return NO;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [_player vc_viewDidAppear];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [_player vc_viewWillDisappear];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [_player vc_viewDidDisappear];
//}


- (void)coverItemWasTapped:(nonnull BogoVideoPlayCell *)cell {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}


@end
