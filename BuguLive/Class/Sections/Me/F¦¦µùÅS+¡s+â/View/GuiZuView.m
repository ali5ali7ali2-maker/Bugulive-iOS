//
//  GuiZuView.m
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "GuiZuView.h"
#import "GuiZuRightsCollectCell.h"

@interface GuiZuView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIView *gzView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *descLabel;

@property (nonatomic, retain) UICollectionView *collectionView;

@end

static NSString *const image_name_bg = @"贵族背景";
static NSString *const image_name = @"玄铁";


@implementation GuiZuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    
    _bgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_bg];
        imageView;
    });
    _iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name];
        imageView;
    });
    [self addSubview:_bgImageView];
    [self addSubview:_iconImageView];
    
    
    _gzView = ({
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = kWhiteColor;
        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:0.5].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,2);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 7;
        
        
        view;
    });
    
    _nameLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:18];
        label.text = ASLocalizedString(@"贵族特权");
        label;
    });
    _descLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = ASLocalizedString(@"拥有特权2/9");
        
        label;
    });
    [self addSubview:_gzView];
    [_gzView addSubview:_nameLabel];
    [_gzView addSubview:_descLabel];
    [_gzView addSubview:self.collectionView];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealValue(255));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(58);
        make.centerX.mas_equalTo(0);
    }];
    
    [_gzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(36);
        make.left.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
//        make.height.mas_equalTo(self.collectionView.bottom +20);
        make.height.mas_equalTo(kRealValue(355));

    }];
    
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.centerX.mas_equalTo(0);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(6);
        make.centerX.mas_equalTo(0);
        
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descLabel.mas_bottom).offset(16);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(300);
        
    }];
    
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuiZuRightsCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GuiZuRightsCollectCell class]) forIndexPath:indexPath];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenW-14*5)/3, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //    if (section == 0) {
    //        return UIEdgeInsetsMake(0, 14, 0, 14);
    //
    //         }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}





#pragma mark - setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenW , 300) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GuiZuRightsCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([GuiZuRightsCollectCell class])];
        //     [_collectionView registerClass:[RechargeTypeCell class] forCellWithReuseIdentifier:NSStringFromClass([RechargeTypeCell class])];
        //        [_collectionView registerClass:[SignHeaderCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        //           withReuseIdentifier:NSStringFromClass([SignHeaderCollectReusView class])];
        //        [_collectionView registerClass:[SignFooterCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
        //        withReuseIdentifier:NSStringFromClass([SignFooterCollectReusView class])];
    }
    return _collectionView;
}

@end
