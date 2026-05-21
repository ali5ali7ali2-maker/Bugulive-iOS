//
//  New_SimultaneousmusicController.m
//  BuguLive
//
//  Created by bugu on 2019/5/21.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "New_SimultaneousmusicController.h"
#import "new_SimultaneousheaderView.h"
#import "new_SimultaneousCell.h"
#import "Music_manager.h"
#import "HMVideoPlayerViewController.h"
#import "TCVideoRecordViewController.h"
#import "TCBGMHelper.h"
@interface New_SimultaneousmusicController ()<UICollectionViewDelegate,UICollectionViewDataSource,headerDelegate,TCBGMHelperListener>
{
    BOOL iscanDosimultane;
}
@property (nonatomic, strong)UICollectionView *collectionview;
@property (nonatomic, strong)UIButton *doSameparagraph;//拍同款
@property (nonatomic, strong)NSMutableArray *dataAry;
@property (nonatomic, assign)int page;
@property(nonatomic) TCBGMHelper* bgmHelper;
@end

@implementation New_SimultaneousmusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page =1;
    [self getdataWith:_page];
    _bgmHelper = [TCBGMHelper sharedInstance];
    [_bgmHelper setDelegate:self];
    //    self.navtitle =@"";
    //    self.needLeft =YES;
    // Do any additional setup after loading the view.
}
- (void)dosameAction
{
    //拍同款
    if (iscanDosimultane)
    {
        TCVideoRecordViewController *vc = [[TCVideoRecordViewController alloc] init];
        vc.savePath = YES;
        vc.musicPatch = _model.localPatch;
        vc.model =_model;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }else{
//        [FanweMessage alertHUD:@"音乐不存在"];
    }
}
- (void)setModel:(music_obj *)model
{
    _model =model;
    [self.collectionview.mj_header beginRefreshing];
    [self.doSameparagraph addTarget:self action:@selector(dosameAction) forControlEvents:UIControlEventTouchUpInside];
    TCBGMElement* ele = [TCBGMElement new];
    ele.name =model.music_name;
    ele.netUrl =model.music_url;
    ele.author =model.music_author;
    NSString *localpatch;
    if ([ele.name hasSuffix:@".mp3"])
    {
        localpatch = ele.name;
    }else
    {
        localpatch = [NSString stringWithFormat:@"%@.mp3",model.id];
        ele.name =localpatch;
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bgm/%@", localpatch]]]){
        _model.localPatch =[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bgm/%@", localpatch]];
        iscanDosimultane =YES;
    }
    else [_bgmHelper downloadBGM:ele];
}
- (void)startPlaymusic
{
    if (_model.localPatch)
    {
        
        NSError *error =nil;
        AVAudioPlayer *player =[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:_model.localPatch] error:&error];
        player.volume =0.6;
        player.numberOfLoops=1;
        [player prepareToPlay];
        [player play];
        if (error)
        {
            NSLog(@"%@",error);
        }
//        CGFloat _BGMDuration =[[TXUGCRecord shareInstance]setBGM:_model.localPatch];
//        [[TXUGCRecord shareInstance] setBGMVolume:.7];
//        [[TXUGCRecord shareInstance]playBGMFromTime:0 toTime:_BGMDuration withBeginNotify:^(NSInteger errCode) {
//            NSLog(@"%ld",errCode);
//        } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
//            NSLog(@"%ld",durationMS);
//        } andCompleteNotify:^(NSInteger errCode) {
//            NSLog(@"%ld",errCode);
//        }];
    }
}
- (void)getdataWith:(int) page
{
    __block typeof(self)blockself =self;
    [Music_manager getMusicSameparagraphWIthmid:_model.id andPage:_page andCallback:^(id response) {
        if (response)
        {
            if (blockself.page ==1)
            {
                blockself.dataAry =[response mutableCopy];
            }else
            {
                [blockself.dataAry addObjectsFromArray:response];
            }
            [blockself.collectionview reloadData];
        }
        [blockself.collectionview.mj_header endRefreshing];
        [blockself.collectionview.mj_footer endRefreshing];
    }];
}
#pragma 代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    new_SimultaneousCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model =[SmallVideoListModel mj_objectWithKeyValues:self.dataAry[indexPath.item]];
    cell.index =indexPath.item;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        new_SimultaneousheaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionheader" forIndexPath:indexPath];
        headerView.model =_model;
        headerView.delegate =self;
        return headerView;
    }else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *listAry =[NSMutableArray new];
    for (id obj in self.dataAry)
    {
        SmallVideoListModel* model =[SmallVideoListModel mj_objectWithKeyValues:obj];
        [listAry addObject:model];
    }
    HMVideoPlayerViewController *vc = [[HMVideoPlayerViewController alloc]initWithVideos:listAry index:indexPath.item IsPushed:YES requestDict:@{}];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}
- (void)didselectWithIndex:(int)index
{
    switch (index)
    {
        case 1:
        {
            //返回
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            //分享
        }
            break;
        default:
            break;
    }
}

-(void) onBGMDownloadDone:(TCBGMElement*)element
{
    if([[element isValid] boolValue]){
        BGMLog(@"Download \"%@\" success!", [element name]);
        NSString *localpatch;
        if ([element.name hasSuffix:@".mp3"])
        {
            localpatch =element.name;
        }else
        {
            localpatch = [NSString stringWithFormat:@"%@.mp3",element.name];
            element.name =localpatch;
        }
        _model.localPatch =[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bgm/%@", localpatch]];
        iscanDosimultane =YES;
    }
    else BGMLog(@"Download \"%@\" failed!", [element name]);
}
-(void) onBGMListLoad:(NSDictionary*)dict
{
    
}
- (void)onBGMDownloading:(TCBGMElement *)current percent:(float)percent
{
    
}
#pragma 懒加载
- (UICollectionView *)collectionview
{
    if (!_collectionview)
    {
        CGFloat item_w  =(kScreenW-3) /3;
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing =0;
        layout.minimumInteritemSpacing =0;
        layout.itemSize =CGSizeMake(item_w, 340*w_bili);
        layout.headerReferenceSize =CGSizeMake(kScreenW, 470*w_bili);
        _collectionview =[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionview.delegate =self;
        _collectionview.dataSource =self;
        [self.view addSubview:_collectionview];
        [_collectionview registerClass:[new_SimultaneousCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionview registerClass:[new_SimultaneousheaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionheader"];
        __block typeof(self)blockself =self;
        _collectionview.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            blockself.page ++;
            [blockself getdataWith:blockself.page];
        }];
        _collectionview.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            blockself.page =1;
            [blockself getdataWith:blockself.page];
        }];
        }
    return _collectionview;
}
- (NSMutableArray *)dataAry
{
    if (!_dataAry)
    {
        _dataAry =[NSMutableArray new];
    }
    return _dataAry;
}
- (UIButton *)doSameparagraph
{
    if (!_doSameparagraph)
    {
        _doSameparagraph =[[UIButton alloc]init];
        [self.view addSubview:_doSameparagraph];
        [_doSameparagraph mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-40*w_bili);
            make.centerX.equalTo(self.view);
            make.width.height.equalTo(@(140*w_bili));
        }];
        [_doSameparagraph setBackgroundImage:[UIImage imageNamed:@"dosame_icon"] forState:0];
    }
    return _doSameparagraph;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
