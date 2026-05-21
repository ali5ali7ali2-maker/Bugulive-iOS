//
//  choseMuiscVC.m
//  BuguLive
//
//  Created by zzl on 16/6/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "choseMuiscVC.h"
#import "musicCell.h"
#import "dataModel.h"
#import "MJRefresh.h"
@interface choseMuiscVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,musicDownloadDelegate,UIScrollViewDelegate>

@end

@implementation choseMuiscVC
{
    NSMutableArray*    _savedmusic;
    NSMutableArray*    _searchmusic;
    NSMutableArray*    _history;
    int         _pagesearch;
    int         _pagesaved;
    
    int         _datatype;// 0 下载歌曲,1 搜索数据,2历史记录
    
    NSString*   _keywords;
    
    musiceModel*    _selectback;
    
    
}

- (void)viewDidLoad
{
    self.mHidNarBar = YES;
    [super viewDidLoad];

    self.view.layer.cornerRadius = 10;
    
    self.mPageName = ASLocalizedString(@"点歌");
    self.msearchbar.placeholder = ASLocalizedString(@"请输音乐名称");
    _savedmusic     = NSMutableArray.new;
    _searchmusic    = NSMutableArray.new;
    _history        = NSMutableArray.new;
    
    self.msearchbar.delegate = self;
    _datatype = 0;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [leftImageView setImage:[UIImage imageNamed:@"搜索 (10)"]];
    [leftView addSubview:leftImageView];
    
    self.msearchbar.leftView = leftView;
    self.msearchbar.leftViewMode = UITextFieldViewModeAlways;
    self.msearchbar.clearButtonMode = UITextFieldViewModeAlways;
    
    UINib* nib = [UINib nibWithNibName:@"musicCell" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.mtableview.delegate = self;
    self.mtableview.dataSource = self;
    self.mtableview.tableFooterView = UIView.new;
    
    self.mTableView     = self.mtableview;
    self.mHaveFooter    = YES;
    self.mHaveHeader    = YES;
    
    self.mtableview.backgroundColor = [UIColor colorWithRed:240/255.0f green:247/255.0f blue:246/255.0f alpha:1];
    [BGMJRefreshManager refresh:self.mtableview target:self headerRereshAction:@selector(headerStartRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerStartRefresh)];

    self.titleTopConstraint.constant = MG_BOTTOM_MARGIN + 20;
    
    //搜索使用的
    nib = [UINib nibWithNibName:@"musicCell" bundle:nil];
    [self.msearchtableview registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.msearchtableview.delegate = self;
    self.msearchtableview.dataSource = self;
    self.msearchtableview.tableFooterView = UIView.new;
    
    [BGMJRefreshManager refresh:self.msearchtableview target:self headerRereshAction:@selector(headerStartRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerStartRefresh)];
    
    self.msearchtableview.backgroundColor = [UIColor colorWithRed:240/255.0f green:247/255.0f blue:246/255.0f alpha:1];
    
    self.mhistorytableview.delegate = self;
    self.mhistorytableview.dataSource = self;
    self.mhistorytableview.tableFooterView = UIView.new;
    
    [BGMJRefreshManager refresh:self.mhistorytableview target:self headerRereshAction:@selector(headerStartRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerStartRefresh)];
    
    self.mhistorytableview.backgroundColor = [UIColor colorWithRed:240/255.0f green:247/255.0f blue:246/255.0f alpha:1];
    
    [self forcesHeaderReFresh];
    
    self.playerView.hidden = NO;
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(1);
        make.right.equalTo(self.view).offset(-1);
        make.height.equalTo(@74);
    }];
    
    [self.searchBtn addTarget:self action:@selector(handleSearchEvent) forControlEvents:UIControlEventTouchUpInside];

}

- (IBAction)backClick:(id)sender {
    _keywords = @"";
    self.backBtn.hidden = YES;
    self.msearchbar.hidden = YES;
    self.searchBtn.hidden = NO;
    self.closeBtn.hidden = NO;
    self.msearchbar.text = @"";
    [self headerStartRefresh];
}


- (void)handleSearchEvent {
    self.backBtn.hidden = NO;
    self.msearchbar.hidden = NO;
    self.searchBtn.hidden = YES;
    self.closeBtn.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (IBAction)backBtClicked:(UIButton *)sender
{
    [super backBtClicked:sender];
    if(self.mitblock)
    {
        self.mitblock(_selectback);
    }
    
    _selectback = nil;
    [_savedmusic removeAllObjects];
    [_searchmusic removeAllObjects];
    [_history removeAllObjects];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField              // return NO to not become first responder
{
//    if( textField.text.length == 0 )
//    {
//        [self showPage:YES];
//        [self chageDataType:1 bforceload:NO];//刚刚上去 如果没有输入东西 就是 历史记录
//    }
//    else
//    {
//        [self showPage:YES];
//        [self chageDataType:1 bforceload:NO];//如果有文字,就是搜索歌曲
//    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar   // called when cancel button pressed
{
//    [self showPage:NO];
//    [self chageDataType:0 bforceload:NO];//不搜索了,就是 本地歌曲
//    searchBar.text =  nil;
//    //[_searchmusic removeAllObjects];
//    //[_history removeAllObjects];
//    [searchBar resignFirstResponder];
//    //刷新一下
//    [self headerStartRefresh];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _keywords = textField.text;
    [self headerStartRefresh];//n 35
    [textField resignFirstResponder];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    _keywords = searchText;
    if( _keywords.length == 0 )
    {
        [self chageDataType:2 bforceload:YES];//如果搜索关键字删除完了, 就展示历史搜索记录
    }
    else
    {
        [self chageDataType:1 bforceload:YES];//搜索开始
        [self headerStartRefresh];//n 35
    }
}

- (void)chageDataType:(int)type bforceload:(BOOL)bforceload
{
//    _datatype = type;
//    UITableView* whattab = nil;
//    
//    BOOL brefrush =YES;
//    if(_datatype == 0)
//    { // 有数据就不管
//        self.msearchtableview.hidden = YES;
//        self.mhistorytableview.hidden = YES;
//        self.mtableview.hidden = NO;
//        if( _savedmusic.count && !bforceload ) brefrush= NO;
//        
//        whattab = self.mtableview;
//        
//    }
//    else if(_datatype == 1)
//    { // 如果搜索有数据,
//        self.msearchtableview.hidden = NO;
//        self.mhistorytableview.hidden = YES;
//        self.mtableview.hidden = YES;
//        if( _searchmusic.count && !bforceload ) brefrush= NO;
//        
//        whattab = self.msearchtableview;
//    }
//    else if(_datatype == 2)
//    {
//        self.msearchtableview.hidden = YES;
//        self.mhistorytableview.hidden = NO;
//        self.mtableview.hidden = YES;
//        if( _history.count && !bforceload ) brefrush= NO;
//        
//        whattab = self.mhistorytableview;
//    }
//    
//    if(brefrush)
//        [whattab.mj_header beginRefreshing];
//    else
//        [whattab reloadData];
}

- (void)showPage:(BOOL)bshowsearch
{
//    [UIView animateWithDuration:0.3f animations:^{
//
//        self.mtopconsth.constant = bshowsearch ? 75:125;
//        [self.view layoutIfNeeded];
//
//    }];
}

- (void)headerStartRefresh
{

    _pagesaved = 1;
    [musiceModel getMyMusicList:_pagesaved search:_keywords block:^(SResBase *resb, NSArray *all) {
        
        [self headerEndRefresh];
        [_savedmusic removeAllObjects];
        if( resb.msuccess )
        {
            [_savedmusic addObjectsFromArray: all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        [self.mtableview reloadData];
    }];
}

- (void)footerStartRefresh
{
    if( _datatype == 0 )
    {
        _pagesaved ++;
        [musiceModel getMyMusicList:_pagesaved search:_keywords block:^(SResBase *resb, NSArray *all) {
            
            [self footerEndRefresh];
            
            if( resb.msuccess )
            {
                if (all)
                {
                    if ([all count])
                    {
                        [_savedmusic addObjectsFromArray:all];
                    }
                    else
                    {
                        _pagesaved --;
                    }
                }
                else
                {
                    _pagesaved --;
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            [self.mtableview reloadData];
        }];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( tableView == self.msearchtableview )
        return _searchmusic.count;
    else if( tableView == self.mtableview )
        return _savedmusic.count;
    else
        return _history.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark 删除单元格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mtableview || tableView == self.mhistorytableview)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mtableview || tableView == self.mhistorytableview)
        return YES;
    return NO;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == self.mtableview || tableView == self.mhistorytableview)
        return ASLocalizedString(@"删除");
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == self.mtableview )
    {
        if( editingStyle == UITableViewCellEditingStyleDelete )
        {
            if (indexPath.row < _savedmusic.count)
            {
                musiceModel* oneobj =  _savedmusic[ indexPath.row ];
                [SVProgressHUD showWithStatus:ASLocalizedString(@"正在删除...")];
                [oneobj delThis:^(SResBase *resb) {
                    if( resb.msuccess )
                    {
                        [SVProgressHUD dismiss];
                        [_savedmusic removeObject:oneobj];
                        [self.mtableview beginUpdates];
                        [self.mtableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.mtableview endUpdates];
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:resb.mmsg];
                    }
                }];
            }
        }
    }
    if ( tableView == self.mhistorytableview)
    {
        if ( editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (indexPath.row < _history.count)
            {
                [musiceModel deleteHistory:indexPath.row];
                [_history removeObjectAtIndex:indexPath.row];
                [self.mhistorytableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}
- (void)setPlayMusicId:(NSString *)playMusicId
{
    _playMusicId = playMusicId;
    [self.mTableView reloadData];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    musiceModel * oneobj = nil;
    
    if( tableView == self.mtableview )
    {
        if (indexPath.row < _savedmusic.count)
        {
            oneobj =  _savedmusic[ indexPath.row ];
        }
    }

    musicCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = oneobj;
    if([self.playMusicId isEqualToString:oneobj.id])
    {
        cell.playBtn.selected = YES;
    }
    else
    {
        cell.playBtn.selected = NO;
    }
    cell.clickPlay = ^(BOOL isPlay, musiceModel *model) {
        
        self.playerView.songTitleLabel.text = model.title;
        self.playerView.playPauseButton.selected = isPlay;
        self.playerView.chosemusic = model;
        if(isPlay)
        {
            self.playMusicId = model.id;
            if([self.delegate respondsToSelector:@selector(playMusicClicked:)])
            {
                [self.delegate playMusicClicked:model];
            }
            
            //发送一个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playMusic" object:model];
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(stopMusic)])
            {
                [self.delegate stopMusic];
            }

            //发送一个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMusic" object:nil];
        }

        
    };
    
    oneobj.mmUIRef = cell;
    
    return cell;
    
}

-(void)clickDelete:(UITapGestureRecognizer *)sender{
    [musiceModel deleteHistory:sender.view.tag];
    [_history removeObjectAtIndex:sender.view.tag];
    [_mhistorytableview reloadData];
//     removeObject:sender.view];
}

#pragma mark 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    musiceModel * oneobj = nil;
    
//    if( tableView == self.msearchtableview )
//    {
//        if (indexPath.row < _searchmusic.count)
//        {
//            oneobj =  _searchmusic[ indexPath.row];
//        }
//    }
//    else if( tableView == self.mtableview )
//    {
//        if (indexPath.row < _savedmusic.count)
//        {
//            oneobj =  _savedmusic[ indexPath.row ];
//        }
//    }
//    else
//    {
//        if (indexPath.row < _history.count)
//        {
//            oneobj =  _history[ indexPath.row ];
//        }
//    }
//    
//    if( [oneobj isKindOfClass:[NSString class]] )
//    {
//        self.msearchbar.text = (NSString*)oneobj;
//        [self textField:self.msearchbar textDidChange:(NSString*)oneobj];
//    }
//    else
//    {
//        if( oneobj.mmFileStatus == 1 )
//        {//选择了
//            [oneobj addThisToMyList:nil];//如果本地有,也添加到服务器,
//            _selectback = oneobj;
//            [self backBtClicked:nil];
//        }
//        else if( oneobj.mmFileStatus == 0 )
//        {//下载
//            oneobj.mmDelegate = self;
//            [oneobj startDonwLoad:tableView];
//        }
//        else
//        {//下载中,不处理
//            
//        }
//    }
}

#pragma mark 滑动键盘下落
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.msearchbar resignFirstResponder];
}

#pragma mark   --------------------------------musicModel代理方法---------------------------------------
- (void)musicDownloading:(musiceModel *)obj context:(id)context needstop:(BOOL *)needstop
{
    NSInteger index;
    UITableView* tagtableview = (UITableView*)context;
    if( tagtableview == nil || tagtableview.isDragging || tagtableview.tracking || tagtableview.decelerating )
        return;
    
    if( 0 == obj.mmFileStatus )
    {
        [SVProgressHUD showErrorWithStatus:obj.mmDownloadInfo];
    }
    
    if( context == self.msearchtableview )
        index =  [_searchmusic indexOfObject:obj];
    else if(context == self.mtableview)
        index =  [_savedmusic indexOfObject:obj];
    
    if( index != NSNotFound /*&& !tagtableview.hidden*/ )
    {
        if( obj.mmUIRef )
        {
            musicCell* cell = (musicCell*) obj.mmUIRef;
            NSIndexPath* row = [tagtableview  indexPathForCell:cell];
            if( row && row.row == index )
            {
                [tagtableview reloadData];
                //[tagtableview reloadRowsAtIndexPaths:@[ row ] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(CustomPlayerView *)playerView
{
    __weak __typeof(self)weakSelf = self;
    if (!_playerView)
    {
        _playerView = [[CustomPlayerView alloc] init];
        _playerView.play = ^(musiceModel * _Nonnull chosemusic) {
            weakSelf.playMusicId = chosemusic.id;
            //发送一个通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playMusic" object:chosemusic];
        };
    }
    
    return _playerView;
}

@end
