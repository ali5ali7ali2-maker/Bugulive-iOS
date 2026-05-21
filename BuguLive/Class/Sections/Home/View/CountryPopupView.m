//
//  CountryPopupView.m
//  BuguLive
//
//  Created by voidcat on 2024/9/21.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "CountryPopupView.h"
#import "Masonry.h"

@interface CountryPopupView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *countries;

@end

@implementation CountryPopupView

- (instancetype)initWithFrame:(CGRect)frame countries:(NSArray *)countries {
    self = [super initWithFrame:frame];
    if (self) {
        self.countries = countries;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 设置背景颜色为半透明
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    // 添加点击手势隐藏弹窗
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopup)];
//    [self addGestureRecognizer:tapGesture];
    //不适用手势了，与按钮点击有冲突
    
    // 添加点击手势隐藏弹窗
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.frame = self.bounds;
    [tapButton addTarget:self action:@selector(hidePopup) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tapButton];
    // 创建国家列表视图
    [self setupCountryListView];
}

- (void)hidePopup {
    [self removeFromSuperview];
}

- (void)setupCountryListView {
    // 创建 UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((self.frame.size.width - 40) / 3, 40); // 确保每行显示3个
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    
    // 创建 UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CountryCell"];
    
    // 添加到视图
    [self addSubview:self.collectionView];
    
    // 使用 Masonry 进行约束
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self); // 比屏幕一半高一点
        make.width.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.6);
    }];
    //titleLabel价格背景view
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];

    
    // 添加顶部标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"All Country";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(9);
        make.bottom.equalTo(self.collectionView.mas_top).offset(-10);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(titleLabel).offset(-10);
    }];
    //发送到最后面
    [self sendSubviewToBack:bgView];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.countries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CountryCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#AAD2F0"];
    cell.layer.cornerRadius = 5;
    
    // 移除旧的子视图
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加国旗
    UIImageView *flagImageView = [[UIImageView alloc] init];
    [flagImageView sd_setImageWithURL:[NSURL URLWithString:self.countries[indexPath.item][@"img"]]];
    flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:flagImageView];
    
    [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(10);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(18, 12));
    }];
    
    // 添加国家名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.countries[indexPath.item][@"name"];
    nameLabel.textColor = [UIColor colorWithHexString:@"#6280BF"];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagImageView.mas_right).offset(10);
        make.centerY.equalTo(cell.contentView);
    }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(countryPopupView:didSelectCountry:)]) {
        [self.delegate countryPopupView:self didSelectCountry:self.countries[indexPath.item]];
        [self hidePopup];
    }
}

@end
