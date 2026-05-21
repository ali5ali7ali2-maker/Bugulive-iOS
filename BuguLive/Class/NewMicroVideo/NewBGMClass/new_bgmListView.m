//
//  new_bgmListView.m
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "new_bgmListView.h"
//#import "Music_manager.h"
@interface new_bgmListView ()<UITableViewDelegate,UITableViewDataSource,new_bgmitemDelegate>
{
    int _page;
}
@property (nonatomic, strong)NSMutableArray *datasource;
@property (nonatomic, strong)music_obj *waitObj;
@end
@implementation new_bgmListView

- (instancetype)init
{
    self =[super init];
    _page =1;
    return self;
}
- (void)mp3Play:(music_obj *)model
{
    __weak typeof(self) weakself =self;
    [self addVideoWithPlayerLayerFrame:CGRectZero withPlayerItemUrlString:model.music_url complete:^(AVPlayer *player) {
        weakself.player =player;
        [weakself.player play];
    }];
}
- (void)setDatasource:(NSArray *)datasource andPage:(int)page
{
    if (page > _page)
    {
        _page =page;
        for (id obj in datasource)
        {
            music_obj *model =[music_obj mj_objectWithKeyValues:obj];
            [self.datasource addObject:model];
        }
    }else
    {
        [self.datasource removeAllObjects];
        for (id obj in datasource)
        {
            music_obj *model =[music_obj mj_objectWithKeyValues:obj];
            [self.datasource addObject:model];;
        }
    }
    [self.tableview reloadData];
}
#pragma 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    new_bgmitemCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell =[[new_bgmitemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    cell.delegate =self;
    cell.model =self.datasource[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    music_obj *model =self.datasource[indexPath.row];
    if (model.isselect)
    {
        return 140 +104;
    }else
    {
        return 140;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    music_obj *model =self.datasource[indexPath.row];
    //点击播放试听，展开cell
    for (music_obj *obj in self.datasource)
    {
        if (obj == model)
        {
            if(!obj.isselect)
            {
                obj.isselect =YES;
                if (_waitObj == obj)
                {
                    [self.player play];
                }else{
                    [self mp3Play:obj];
                }
                _waitObj =nil;
            }else
            {
                obj.isselect =NO;
                [self.player pause];
                _waitObj =obj;
            }
        }else
        {
            obj.isselect =NO;
        }
    }
    [self.tableview reloadData];
}
- (void)selectItem:(music_obj *)model
{
    if ([_delegate respondsToSelector:@selector(SureUseobj:)])
    {
        [_delegate SureUseobj:model];
    }
}
- (void)doCollection:(music_obj *)model
{
//    [Music_manager MusicManagerdoCollection:model.id andcallback:^(id response) {
//        if (response)
//        {
//            model.is_collection =1;
//            [self.tableview reloadData];
//        }
//    }];
}
#pragma 懒加载
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_tableview];
        _tableview.delegate =self;
        _tableview.dataSource =self;
        _tableview.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.width.height.equalTo(self);
        }];
    }
    return _tableview;
}
- (NSMutableArray *)datasource
{
    if (!_datasource)
    {
        _datasource =[NSMutableArray new];
    }
    return  _datasource;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
