//
//  SHomeDynamicView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/5/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "SHomeDynamicView.h"
#import "CellForWorkGroup.h"

@implementation SHomeDynamicView

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
        self.user_id = userId;
        YHTimeLineListController *vc = [[YHTimeLineListController alloc]initWithIndexAct:MGDTHOMETYPE_MY withUID:userId];
        vc.view.frame = frame;
        vc.view.left = 0;
        vc.view.backgroundColor = kRedColor;
        [self addSubview:vc.view];
    }
    return self;
}

-(void)setUpViewWithFrame:(CGRect)frame{
   
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];

    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.tableView];
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    
   
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
    
}

//-(void)refreshHeader{
//
//    [self requestDataLoadNew:YES];
//}
//
//-(void)refreshFooter{
//    [self requestDataLoadNew:NO];
//}
//
//
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [_playerView destroyPlayer];
//    _c_cell =nil;
//}


@end
