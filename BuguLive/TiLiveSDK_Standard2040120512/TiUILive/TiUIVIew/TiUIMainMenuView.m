//
//  TiUIMainMenuView.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIMainMenuView.h"
#import "TIConfig.h"
#import "TISetSDKParameters.h"
#import "TIDownloadZipManager.h"

#import "TiUISliderRelatedView.h"
#import "TiUIMenuViewCell.h"

#import "TiUIMenuOneViewCell.h"
#import "TiUIMenuTowViewCell.h"
#import "TiUIMenuThreeViewCell.h"
 

@interface TiUIMainMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource>
 
//滑块相关View
@property(nonatomic,strong) TiUISliderRelatedView  *sliderRelatedView;
//菜单view背景
@property(nonatomic,strong) UIView *backgroundView;
//美颜菜单view
@property(nonatomic,strong) UICollectionView *menuView;
//美颜菜单二级联动CollectionView子菜单
@property(nonatomic,strong) UICollectionView *subMenuView;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@property(nonatomic,assign) NSInteger mainindex;
@property(nonatomic,assign) NSInteger subindex;

@end

static NSString *const TiUIMenuViewCollectionViewCellId = @"TiUIMainMenuViewCollectionViewCellId";
static NSString *const TiUISubMenuViewCollectionViewCellId = @"TiUIMainSubMenuViewCollectionViewCellId";

@implementation TiUIMainMenuView

-(TiUISliderRelatedView *)sliderRelatedView{
    if (_sliderRelatedView == nil) {
        _sliderRelatedView = [[TiUISliderRelatedView alloc]init];
        
         
        //默认美白拉条
        [_sliderRelatedView.sliderView setSliderType:TI_UI_SLIDER_TYPE_ONE WithValue:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_WHITENING_SLIDER]];
        WeakSelf;//滑动拉条调用成回调
        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
            TiUIDataCategoryKey valueForKey;
            if (weakSelf.mainindex==4) {
                valueForKey = TI_UIDCK_FILTER_SLIDER;
            }else{
                valueForKey  = (weakSelf.mainindex+1)*100 + weakSelf.subindex;
            }
            
            //储存滑条参数
            [TISetSDKParameters setFloatValue:value forKey:valueForKey];
            //设置美颜参数
            [TISetSDKParameters setBeautySlider:value forKey:valueForKey withIndex:weakSelf.subindex];
            
        }];
        
    }
    return _sliderRelatedView;
}

-(UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = TI_Color_Default_Text_Black;
    }
    return _backgroundView;
}

-(UICollectionView *)menuView{
    if (_menuView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(TiUIMenuViewHeight*2, TiUIMenuViewHeight);
//        // 设置最小行间距
        layout.minimumLineSpacing = 0;
          
        _menuView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_menuView setTag:10];
        _menuView.showsHorizontalScrollIndicator = NO;
        _menuView.backgroundColor=[UIColor whiteColor];
        _menuView.dataSource= self;
        _menuView.delegate = self;
        [_menuView registerClass:[TiUIMenuViewCell class] forCellWithReuseIdentifier:TiUIMenuViewCollectionViewCellId];
       
    }
    return _menuView;
}
-(UICollectionView *)subMenuView{
    if (_subMenuView == nil) {
           UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        SCREEN_WIDTH
        
                layout.itemSize = CGSizeMake(self.frame.size.width, TiUIViewBoxTotalHeight- TiUIMenuViewHeight - TiUISliderRelatedViewHeight-1);
        //        // 设置最小行间距
                layout.minimumLineSpacing = 0;
                _subMenuView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
                [_subMenuView setTag:20];
                _subMenuView.showsHorizontalScrollIndicator = NO;
                _subMenuView.backgroundColor=[UIColor whiteColor];
                _subMenuView.dataSource= self;
                _subMenuView.scrollEnabled = NO;//禁止滑动
        
        //注册多个cell 不重用，重用会导致嵌套的UICollectionView内的cell 错乱
        // FIXME: --json 数据完善后可再次尝试--
        for (TIMenuMode *mod in [TIMenuPlistManager shareManager].mainModeArr) {
            
            switch (mod.menuTag) {
                case 0:
                case 1:
                {
                    [_subMenuView registerClass:[TiUIMenuOneViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mod.menuTag]];
                }
                    break;
                case 4:
                case 5:
                case 6:
                      {
                    [_subMenuView registerClass:[TiUIMenuTowViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mod.menuTag]];
                      }
                     break;
                  case 2:
                  case 3:
                  case 7:
                  case 8:
                  case 9:
                       {
                     [_subMenuView registerClass:[TiUIMenuThreeViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mod.menuTag]];
                        }
                    break;
                    
                default:
                {
                [_subMenuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mod.menuTag]];
                }
                    break;
            }
            
           
        }
    }
    return _subMenuView;
}

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         
        
        [self addSubview:self.sliderRelatedView];
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.menuView];
        [self.backgroundView addSubview:self.subMenuView];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_offset(TiUISliderRelatedViewHeight);
        }];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.sliderRelatedView.mas_bottom);
        }];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.right.top.equalTo(self.backgroundView);
             make.height.mas_offset(TiUIMenuViewHeight);
        }];
        [self.subMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.right.bottom.equalTo(self.backgroundView);
              make.top.equalTo(self.menuView.mas_bottom).offset(0.5);
         }];
          
    }
    return self;
}
 
 
#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     return [[TIMenuPlistManager shareManager] mainModeArr].count;
}
   
 //返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     TIMenuMode *mode = [[TIMenuPlistManager shareManager] mainModeArr][indexPath.row];
    
    if (collectionView.tag==10) {
          
        TiUIMenuViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUIMenuViewCollectionViewCellId forIndexPath:indexPath];
        if (mode.selected)
            {
              self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            }
        [cell setMenuMode:mode];
         
        return cell;
        
    }else if (collectionView.tag==20){
        
        switch (mode.menuTag) {
            case 0:
            case 1:
            {
            TiUIMenuOneViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mode.menuTag] forIndexPath:indexPath];
                
                WeakSelf;
                [cell setClickOnCellBlock:^(NSInteger index) {
                    weakSelf.subindex = index;
                    
                    [weakSelf setSliderTypeAndValue];
                
                }];
                [cell setMode:mode];
                return cell;
            }
                break;

            case 4:
            case 5:
            case 6:
            {
               TiUIMenuTowViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mode.menuTag] forIndexPath:indexPath];
                WeakSelf;
                [cell setClickOnCellBlock:^(NSInteger index) {//只有滤镜执行
                    weakSelf.subindex = index;
                    [weakSelf setSliderTypeAndValue];
                              }];
               [cell setMode:mode];
               return cell;
            }
                break;
                
            case 2:
            case 3:
            case 7:
            case 8:
            case 9:
            {
            TiUIMenuThreeViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mode.menuTag] forIndexPath:indexPath];
                [cell setMode:mode];
                return cell;
            }
                break;
                
            default:
            {
                UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%ld",TiUISubMenuViewCollectionViewCellId,(long)mode.menuTag] forIndexPath:indexPath];
                cell.backgroundColor = [UIColor orangeColor];
                    return cell;
            }
                break;
        }
         
    }
    
        return nil;
}
#pragma mark ---UICollectionViewDelegate---
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == self.selectedIndexPath.row) return;
     
    
    if (collectionView.tag ==10)
    {
         
        self.mainindex = indexPath.row;
        switch (indexPath.row) {
            case 0:
                for (TIMenuMode *mod in [TIMenuPlistManager shareManager].meiyanModeArr) {
                      if (mod.selected) {
                        self.subindex = mod.menuTag;
                          }
                     }
                 [self.sliderRelatedView setSliderHidden:NO];
                 [self setSliderTypeAndValue];
                break;
            case 1:
                for (TIMenuMode *mod in [TIMenuPlistManager shareManager].meixingModeArr) {
                      if (mod.selected) {
                        self.subindex = mod.menuTag;
                          }
                     }
                 [self.sliderRelatedView setSliderHidden:NO];
                 [self setSliderTypeAndValue];
                break;
            case 4:
                for (TIMenuMode *mod in [TIMenuPlistManager shareManager].lvjingModeArr) {
                      if (mod.selected) {
                        self.subindex = mod.menuTag;
                          }
                     }
                 [self.sliderRelatedView setSliderHidden:NO];
                 [self setSliderTypeAndValue];
                break;
                
                break;
            default:
                [self.sliderRelatedView setSliderHidden:YES];
                
                break;
        }
        
          [TIMenuPlistManager shareManager].mainModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TIMenu.json"];

          [TIMenuPlistManager shareManager].mainModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TIMenu.json"];
                                             
                   if(self.selectedIndexPath){
                     [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                   }
                   else
                   {
                     [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                   }
                     self.selectedIndexPath = indexPath;

            [self.subMenuView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    }
}


-(void)setSliderTypeAndValue{
    TiUISliderType sliderType = TI_UI_SLIDER_TYPE_ONE;
    TiUIDataCategoryKey categoryKey = TI_UIDCK_SKIN_WHITENING_SLIDER;
            if (self.mainindex==0) {
                        
                    switch (self.subindex) {
                               case 0:
                            sliderType = TI_UI_SLIDER_TYPE_ONE;
                            categoryKey = TI_UIDCK_SKIN_WHITENING_SLIDER;// 美白
                            
                                break;
                                case 1:
                            sliderType = TI_UI_SLIDER_TYPE_ONE;
                            categoryKey = TI_UIDCK_SKIN_BLEMISH_REMOVAL_SLIDER;// 磨皮
                            
                                break;
                                case 2:
                            sliderType = TI_UI_SLIDER_TYPE_TWO;
                            categoryKey = TI_UIDCK_SKIN_BRIGHTNESS_SLIDER;// 亮度
                            
                                break;
                                case 3:
                            sliderType = TI_UI_SLIDER_TYPE_ONE;
                            categoryKey = TI_UIDCK_SKIN_TENDERNESS_SLIDER;// 粉嫩
                                
                                break;
                                case 4:
                            sliderType = TI_UI_SLIDER_TYPE_ONE;
                            categoryKey = TI_UIDCK_SKIN_SKINBRIGGT_SLIDER;// 鲜明
                                
                                break;
                            default:
                                break;
                        }
                    }
                    else if (self.mainindex==1)
                    {
                         switch (self.subindex) {
                                       case 0:
                                    sliderType = TI_UI_SLIDER_TYPE_ONE;
                                    categoryKey = TI_UIDCK_EYE_MAGNIFYING_SLIDER;// 大眼
                                    
                                        break;
                                        case 1:
                                    sliderType = TI_UI_SLIDER_TYPE_ONE;
                                    categoryKey = TI_UIDCK_FACE_NARROWING_SLIDER;// 瘦脸
                                    
                                        break;
                                        case 2:
                                    sliderType = TI_UI_SLIDER_TYPE_ONE;
                                    categoryKey = TI_UIDCK_CHIN_SLIMMING_SLIDER;// 窄脸
                                    
                                        break;
                                        case 3:
                                    sliderType = TI_UI_SLIDER_TYPE_TWO;
                                    categoryKey = TI_UIDCK_JAW_TRANSFORMING_SLIDER;// 下巴
                                        
                                        break;
                            case 4:
                        sliderType = TI_UI_SLIDER_TYPE_TWO;
                        categoryKey = TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER;// 额头
                            
                            break;
                            case 5:
                        sliderType = TI_UI_SLIDER_TYPE_TWO;
                        categoryKey = TI_UIDCK_MOUTH_TRANSFORMING_SLIDER;// 嘴型
                            
                            break;
                            case 6:
                        sliderType = TI_UI_SLIDER_TYPE_TWO;
                        categoryKey = TI_UIDCK_NOSE_SLIMMING_SLIDER;// 瘦鼻
                            
                            break;
                            case 7:
                        sliderType = TI_UI_SLIDER_TYPE_ONE;
                        categoryKey = TI_UIDCK_TEETH_WHITENING_SLIDER;// 美牙
                            break;
                            case 8:
                            sliderType = TI_UI_SLIDER_TYPE_TWO;
                            categoryKey = TI_UIDCK_EYE_SPACING_SLIDER;// 眼间距
                                break;
                            case 9:
                            sliderType = TI_UI_SLIDER_TYPE_ONE;
                            categoryKey = TI_UIDCK_NOSE_LONG_SLIDER;// 长鼻
                                break;
                            case 10:
                            sliderType = TI_UI_SLIDER_TYPE_TWO;
                            categoryKey = TI_UIDCK_EYE_CORNER_SLIDER;// 眼角
                                break;
                                 
                                 
                            default:
                                break;
                                }
                        }
                        else if (self.mainindex==4)
                        {
                            sliderType = TI_UI_SLIDER_TYPE_ONE;
                            categoryKey = TI_UIDCK_FILTER_SLIDER;// 滤镜
                            
                            if (self.subindex) {

                                [self.sliderRelatedView setSliderHidden:NO];
                            }else{

                                [self.sliderRelatedView setSliderHidden:YES];
                            }
                        }
                                  
                                  
                    [self.sliderRelatedView.sliderView setSliderType:sliderType WithValue:[TISetSDKParameters getFloatValueForKey:categoryKey]];
                    
    
    
}
 
 
-(void)dealloc{
    [TIMenuPlistManager releaseShareManager];
    [TIDownloadZipManager releaseShareManager];
} 

@end
