//
//  BGSoundEffectsView.m
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGSoundEffectsView.h"
#import "BGSoundEffectCell.h"

@interface BGSoundEffectsView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UIView *shadowView;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) QMUIButton *addSoundEffectBtn;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end
@implementation BGSoundEffectsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    //[self requestData];

    }
    return self;
}

- (void)initUI{
    
    _bgView=({
           UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
        view.layer.cornerRadius = 9;
           view;
       });
       
    _titleLabel= ({
           UILabel * label = [[UILabel alloc]init];
           label.textColor = kWhiteColor;
           label.font = [UIFont systemFontOfSize:16];
           label.text = ASLocalizedString(@"音效");
           label;
       });
    
   _addSoundEffectBtn  = ({
       QMUIButton * btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
       [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
       btn.titleLabel.font = [UIFont systemFontOfSize:16];
       [btn setTitle:ASLocalizedString(@"上传")forState:UIControlStateNormal];
       [btn setImage:[UIImage imageNamed:@"lr上传"] forState:UIControlStateNormal];
       btn.imagePosition = QMUIButtonImagePositionLeft;
       btn.spacingBetweenImageAndTitle = 2;
       [btn addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchUpInside];
       btn;
   });
    _addSoundEffectBtn.hidden = YES;
    
    [self addSubview:_bgView];
    [_bgView addSubview:_titleLabel];
    [_bgView addSubview:_addSoundEffectBtn];
    [_bgView addSubview:self.collectionView];
}

- (void)requestData{
    
    self.dataArray  = [NSMutableArray array];
    
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
       [parmDict setObject:@"index" forKey:@"ctl"];
       [parmDict setObject:@"home_sound" forKey:@"act"];
       
       FWWeakify(self)
       
       [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
           NSArray * array = responseJson[@"data"];
           for (id obj in array)
           {
               BGSoundEffectModel *model =[BGSoundEffectModel mj_objectWithKeyValues:obj];
               [self.dataArray addObject:model];
           }
           [self.collectionView reloadData];
           
       } FailureBlock:^(NSError *error) {
           
       }];
}

- (void)uploadAction {
    if (self.uploadBlock) {
        self.uploadBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(0);
          make.left.right.bottom.mas_equalTo(0);

      }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.centerX.mas_equalTo(0);

    }];
    [_addSoundEffectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(72);

    }];
   
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 4;
          
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BGSoundEffectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BGSoundEffectCell class]) forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    BGSoundEffectModel *model = self.dataArray[indexPath.item];
//    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//    CGFloat labelWidth = [model.name boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 60;
//
    return CGSizeMake( kScreenW / 4 + kRealValue(10) , kRealValue(40)+10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
    //    if (section == 0) {
    //        return UIEdgeInsetsMake(0, 14, 0, 14);
    //
    //    }
    //
    //    return UIEdgeInsetsMake(0, 59, 0, 59);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//2020-1-2 点击播放某个音效

//    BGSoundEffectCell *cell = (BGSoundEffectCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
//    cell.titleLabel.textColor=kRedColor;
    
    BGSoundEffectModel *model=self.dataArray[indexPath.item];
    __weak typeof(self) weakself =self;
    
    if(self.playUrl)
    {
        self.playUrl(model);
    }
    [self hide];
//    [self addVideoWithPlayerLayerFrame:CGRectZero withPlayerItemUrlString:model.url complete:^(AVPlayer *player) {
//        if(self.playUrl)
//        {
//            self.playUrl(model.url);
//        }
////        weakself.player =player;
////        [weakself.player play];
//        [weakself hide];
//    }];
}

#pragma mark - Show And Hide
- (void)show:(UIView *)superView{
    
    [self requestData];
    
    [superView addSubview:self.shadowView];
    [superView addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH / 2;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = kClearColor;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

#pragma mark - setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,70, kScreenW , kScreenH/2-70) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[BGSoundEffectCell class] forCellWithReuseIdentifier:NSStringFromClass([BGSoundEffectCell class])];
    }
    return _collectionView;
}
@end
