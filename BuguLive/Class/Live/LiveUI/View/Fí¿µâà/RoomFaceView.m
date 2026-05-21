//
//  RoomFaceView.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/27.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomFaceView.h"
#import "RoomFaceModel.h"
#import "RoomFaceCell.h"
#import "HorizontalLayout.h"

@interface RoomFaceView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIButton *selectedBtn;
@property(nonatomic, strong) UIButton *face1Btn;
@property(nonatomic, strong) NSString *face1_image_name;
@end

@implementation RoomFaceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#202038"];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self addSubview:self.bgView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(self.bgView.mas_bottom);
            make.bottom.equalTo(self).offset(-20);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-(55+45));
        }];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(44);
        }];
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"app" forKey:@"ctl"];
        [dict setValue:@"room_memes_type_list" forKey:@"act"];
        [dict setValue:@"0" forKey:@"i_type"];

        
        [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
            if ([responseJson toInt:@"status"] == 1) {
                int i = 0;
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:responseJson[@"list"]];
//                [array addObjectsFromArray:responseJson[@"list"]];
//                [array addObjectsFromArray:responseJson[@"list"]];
                
                for (NSDictionary *dict in array) {
                    
                    RoomFaceModel *model = [RoomFaceModel mj_objectWithKeyValues:dict];
                    UIButton*  Button=[[UIButton alloc]init];
                    Button.imageEdgeInsets = UIEdgeInsetsMake(3, 10, 3, 10);
                    Button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    [Button sd_setImageWithURL:[NSURL URLWithString:SafeStr(model.img)] forState:UIControlStateNormal];
                    [Button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                    [Button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3B3B5E"]] forState:UIControlStateSelected];
                    [Button qmui_bindObject:model.id forKey:@"id"];
                    [Button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    Button.tag = i;
                    ViewRadius(Button, 6);
                    [self.bgView addSubview:Button];
                    
                    if (i == 0) {
                        Button.selected = YES;
                        self.selectedBtn = Button;
                        [self requestDataWithID:model.id];

                    }
                    
                    [Button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(60*i);
                        make.centerY.mas_equalTo(0);
                        make.width.mas_equalTo(48);
                        make.height.mas_equalTo(35);

                    }];
                    i++;
                }
                
            }

            
        } FailureBlock:^(NSError *error) {
        }];

        
  
    }
    return self;
}

- (void)ButtonClick:(UIButton *)sender {
    if (sender == self.selectedBtn) {
        return;
    }
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    NSString *id = [sender qmui_getBoundObjectForKey:@"id"];
    [self requestDataWithID:id];
}


- (void)requestDataWithID:(NSString *)memes_type_id{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"app" forKey:@"ctl"];
    [dict setValue:@"room_memes_list" forKey:@"act"];
    [dict setValue:@"0" forKey:@"i_type"];
    [dict setValue:memes_type_id forKey:@"memes_type_id"];

    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in responseJson[@"list"]) {
                RoomFaceModel *model = [RoomFaceModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
        }

        
        [self.collectionView reloadData];
        self.pageControl.numberOfPages = self.dataArray.count / 8 + (self.dataArray.count % 8 == 0 ? 0 : 1);
    } FailureBlock:^(NSError *error) {
    }];

}

- (void)show:(UIView *)superView{
    [super show:superView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    self.pageControl.currentPage = contentOffsetX / kScreenW;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RoomFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RoomFaceCell class]) forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(floor(kScreenW / 4), 90);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceView:didSelectFace:)]) {
        [self.delegate faceView:self didSelectFace:self.dataArray[indexPath.item]];
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        HorizontalLayout *layout = [[HorizontalLayout alloc] init];
        layout.rowCount = 4;
        layout.columCount = 2;
        layout.itemSize = CGSizeMake(floor(kScreenW / 4), 90);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[RoomFaceCell class] forCellWithReuseIdentifier:NSStringFromClass([RoomFaceCell class])];
        _collectionView.backgroundColor = kClearColor;
    }
    return _collectionView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kClearColor;
        
    }
    return _bgView;
}

@end
