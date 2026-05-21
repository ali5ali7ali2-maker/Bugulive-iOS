//
//  BogoShopSelectedTopCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoShopSelectedTopCell.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "TYCyclePagerViewCell.h"
#import <Masonry/Masonry.h>
#import "FDUIKitObjC.h"
#import "BogoShopBannerModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BogoShopSelectedTopCell ()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>

@property(nonatomic, strong) TYCyclePagerView *pagerView;

@end

@implementation BogoShopSelectedTopCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.pagerView];
        [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray<BogoShopBannerModel *> *)dataArray{
    _dataArray = dataArray;
    [self.pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDelegate,TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView{
    return self.dataArray.count;
}


- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TYCyclePagerViewCell" forIndex:index];
    if (index < self.dataArray.count) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index].image]];
    }
    return cell;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topCell:didClickBannerIndex:)]) {
        [self.delegate topCell:self didClickBannerIndex:index];
    }
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView{
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(FD_ScreenWidth - 80, 120);
    layout.itemSpacing = 10;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
}

- (TYCyclePagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]init];
        _pagerView.isInfiniteLoop = YES;
        _pagerView.autoScrollInterval = 3.0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        // registerClass or registerNib
        [_pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"TYCyclePagerViewCell"];
    }
    return _pagerView;
}

@end
