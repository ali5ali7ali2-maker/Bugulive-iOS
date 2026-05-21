//
//  ToolsView.m
//  BuguLive
//
//  Created by yy on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ToolsView.h"

@implementation ToolsView
{
    NSMutableArray  *_dataArray;
}

static NSString *const cellId = @"cellId";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _BuguLive = [GlobalVariables sharedInstance];
        
        if (!_toolsSelArray)
        {
            if ([GlobalVariables sharedInstance].isOtherPush) {
                _toolsSelArray  = [[NSMutableArray alloc]initWithObjects:ASLocalizedString(@"外设直播_推流地址"), nil];
                
                _toolsNameArray = [[NSMutableArray alloc]initWithObjects:ASLocalizedString(@"推流地址"), nil];
                
                _toolsUnselArray = [[NSMutableArray alloc]initWithObjects:ASLocalizedString(@"外设直播_推流地址"), nil];
            }else{
                _toolsSelArray  = [[NSMutableArray alloc]initWithObjects:
                                   @"lr_plugin_beauty_sel",
                                   @"lr_plugin_micro_sel",
                                   @"lr_plugin_camera_sel",
                                   @"lr_plugin_flash_sel",
                                   @"lr_plugin_mirror_sel",
                                   @"lr_plugin_sound_sel", nil];
                
                _toolsNameArray = [[NSMutableArray alloc]initWithObjects:
                                   ASLocalizedString(@"美颜"),
                                   ASLocalizedString(@"麦克风"),
                                   ASLocalizedString(@"翻转"),
                                   ASLocalizedString(@"闪光灯"),
                                   ASLocalizedString(@"镜像"), nil];
                
                _toolsUnselArray = [[NSMutableArray alloc]initWithObjects:
                                    @"lr_plugin_beauty_sel",
                                    @"lr_plugin_micro_unsel",
                                    @"lr_plugin_camera_unsel",
                                    @"lr_plugin_flash_unsel",
                                    @"lr_plugin_mirror_unsel", nil];
            }
            
            _cellArray = [[NSMutableArray alloc]init];
            _dataArray = [[NSMutableArray alloc]init];
        }
        
        [self setupModel];
        [self createToolCollection];
    }
    return self;
}

- (void)setupModel
{
    dispatch_queue_t queue = dispatch_queue_create("toolsQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i = 0; i < _toolsNameArray.count; i++)
        {
            PluginToolsModel *model = [[PluginToolsModel alloc]init];
            //2.麦克风
            if (i == 1)
            {
                model.isSelected = YES;
            }
            else
            {
                model.isSelected = NO;
            }
            [_dataArray addObject:model];
        }
    });
}

- (void)createToolCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kScreenW / 4 - 20, kScreenW / 4 - 25);
    //    CGSizeMake((self.size.width - 20 - 20 * 5) / 4 - 1, (self.size.width - 20 - 20 * 5) / 4 - 1);
    //    layout.sectionInset = UIEdgeInsetsMake(27, 4, 0, 0);
    //    layout.minimumLineSpacing = 0;
    //    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _toolsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20, self.size.height) collectionViewLayout:layout];
    _toolsCollectionView.backgroundColor = [UIColor clearColor];
    _toolsCollectionView.delegate = self;
    _toolsCollectionView.dataSource = self;
    _toolsCollectionView.showsHorizontalScrollIndicator = NO;   //关闭滚动线
    _toolsCollectionView.allowsMultipleSelection = YES;         //允许多选
    _toolsCollectionView.alwaysBounceHorizontal = YES;          //总是允许横向滚动
    _toolsCollectionView.pagingEnabled = NO;
    [_toolsCollectionView registerClass:[ToolsCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:_toolsCollectionView];
}

#pragma mark    --------------------------collectionView代理方法--------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //如果是后置摄像头，则没有镜像
    if (![GlobalVariables sharedInstance].isOtherPush) {
        if (_isRearCamera)
        {
            if ([_toolsNameArray containsObject:ASLocalizedString(@"镜像")])
            {
                [_toolsNameArray removeObject:ASLocalizedString(@"镜像")];
            }
        }
        else
        {
            if (![_toolsNameArray containsObject:ASLocalizedString(@"镜像")])
            {
                [_toolsNameArray insertObject:ASLocalizedString(@"镜像")atIndex:4];
            }
        }
    }
    return _toolsNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PluginToolsModel *model;
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    ToolsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.toolLabel.text = _toolsNameArray[indexPath.row];
    [cell.toolBtn setTitle:_toolsNameArray[indexPath.row] forState:UIControlStateNormal];
    if (model.isSelected)
    {
        //        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]];
        [cell.toolBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];
    }
    else
    {
        [cell.toolBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];
        //        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]];
    }
    [_cellArray addObject:cell];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark 选中单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self collectionView:_toolsCollectionView didHighlightItemAtIndexPath:indexPath];
    
    if (!SUS_WINDOW.isPushStreamIng && ![GlobalVariables sharedInstance].isOtherPush)
    {
        [self closePlugin];
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"直播开启中，请稍候!")];
        [_toolsCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    else
    {
        [self judgmentTools:YES indexPath:indexPath cell:cell];
    }
}

#pragma mark    取消选中单元格
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self judgmentTools:NO indexPath:indexPath cell:cell];
}



- (void)judgmentTools:(BOOL)selected indexPath:(NSIndexPath *)indexPath cell:(ToolsCollectionViewCell *)cell
{
    PluginToolsModel *model;
    PluginToolsModel *mirrorModel;  //镜像model
    PluginToolsModel *lightModel;   //闪光灯model
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    
    //0.音乐      1.美颜    3.切换摄像
    if (indexPath.row == 0  || indexPath.row == 2)
    {
        if (indexPath.row == 2)
        {
            _isRearCamera = !_isRearCamera;

        }
        
//        if(indexPath.row == 1)
//        {
//            model.isSelected = !model.isSelected;
//        }
        
        [self selectOrDeselect:indexPath.row isSelected:_isRearCamera];
    }
    //2.麦克风
    else if (indexPath.row == 1)
    {
        model.isSelected = !model.isSelected;
        [self selectOrDeselect:indexPath.row isSelected:model.isSelected];
    }
    //4.闪光灯
    else if (indexPath.row == 3)
    {
        //如果是后置摄像头
        if (_isRearCamera)
        {
            _isClick = !_isClick;
        }
        else
        {
            _isClick = NO;
        }
        model.isSelected = _isClick;
        [self selectOrDeselect:indexPath.row isSelected:_isClick];
    }
    //5.镜像
    else if (indexPath.row == 4)
    {
        _isOpenMirror = !_isOpenMirror;
        model.isSelected = !model.isSelected;
        [self selectOrDeselect:indexPath.row isSelected:model.isSelected];
    }
    
    [_cellArray removeAllObjects];
    [_toolsCollectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PluginToolsModel *model;
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[_toolsCollectionView cellForItemAtIndexPath:indexPath];
    
    if (model.isSelected)
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]];
    }
    else
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PluginToolsModel *model;
    if (indexPath.row < _dataArray.count)
    {
        model = _dataArray[indexPath.row];
    }
    
    ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[_toolsCollectionView cellForItemAtIndexPath:indexPath];
    if (model.isSelected)
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsSelArray objectAtIndex:indexPath.row]]];
    }
    else
    {
        cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row]]];
    }
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 20;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 20;
//}

#pragma mark    取消闪光灯高亮图片
- (void)closeLight:(NSIndexPath *)indexPath
{
    ToolsCollectionViewCell *cell = [_cellArray objectAtIndex:indexPath.row +1];
    cell.toolImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_toolsUnselArray objectAtIndex:indexPath.row +1]]];
}

#pragma mark    关闭插件中心
- (void)closePlugin
{
    if (_toPCVdelegate && [_toPCVdelegate respondsToSelector:@selector(closeSelfView:)])
    {
        [_toPCVdelegate closeSelfView:self];
    }
}

- (void)selectOrDeselect:(NSInteger)row isSelected:(BOOL)isSelected
{
    [self closePlugin];
    if (_toSDKdelegate && [_toSDKdelegate respondsToSelector:@selector(selectToolsItemWith:selectIndex:isSelected:)])
    {
        [_toSDKdelegate selectToolsItemWith:self selectIndex:row isSelected:isSelected];
    }
}

@end
