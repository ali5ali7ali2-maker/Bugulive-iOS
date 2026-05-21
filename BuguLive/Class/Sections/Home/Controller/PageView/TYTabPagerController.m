#import "TYTabPagerController.h"
#import "TYTabTitleViewCell.h"
#import <QMUIKit/QMUIKit.h>
@interface TYTabPagerController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    struct {
        unsigned int titleForIndex :1;
    }_tabDataSourceFlags;
    struct {
        unsigned int configreReusableCell :1;
        unsigned int didSelectAtIndexPath :1;
        unsigned int didScrollToTabPageIndex :1;
        unsigned int transitionFromeCellAnimated :1;
        unsigned int transitionFromeCellProgress :1;
    }_tabDelegateFlags;
}
// views
//@property (nonatomic, weak) UIView *pagerBarView;
@property (nonatomic, weak) UICollectionView *collectionViewBar;
@property (nonatomic, weak) UIView *progressView;
@property (nonatomic ,assign) Class cellClass;
@property (nonatomic ,assign) BOOL cellContainXib;
@property (nonatomic ,strong) NSString *cellId;

@end

//#define kCollectionViewBarHieght 50 + 44
//tabbar高度
#define kUnderLineViewHeight 1
#define _pageBarWidth  (kScreenW - 10 * 2)

@implementation TYTabPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configireTabPropertys];
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configireTabPropertys];
    }
    return self;
}

- (void)configireTabPropertys
{
    _kCollectionViewBarHieght = 50 + 44;
    
    _animateDuration = 0.1;
    _barStyle = TYPagerBarStyleNoneView;
    _normalTextFont = [UIFont systemFontOfSize:16];
    _selectedTextFont = [UIFont boldSystemFontOfSize:20];
    _cellSpacing = 0;
    _cellEdging = 0;
    _progressHeight = kUnderLineViewHeight;
    _progressEdging = 0;
    _progressWidth = 0;
    self.changeIndexWhenScrollProgress = 1.0;
    self.contentTopEdging = _kCollectionViewBarHieght;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // add pager bar
    [self addPagerBarView];
    // add title views
    [self addCollectionViewBar];
    // add progress view
    [self addUnderLineView];
}

- (void)addPagerBarView
{
    //首页顶部背景颜色
    _bgTopImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mg_hm_topBgImgView"]];
    _bgTopImgView.frame = CGRectMake(0, 0, kScreenW, _kCollectionViewBarHieght);
    [self.view addSubview:_bgTopImgView];
    
    _pagerBarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame), self.kCollectionViewBarHieght)];

    [self.view addSubview:_pagerBarView];
  
}

//在这里添加控件
- (void)addCollectionViewBar
{
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20,0, CGRectGetWidth(self.view.frame), _pagerBarView.height) collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.backgroundColor = kYellowColor;
    collectionView.dataSource = self;
    [_pagerBarView addSubview:collectionView];
    //tabbar title
    
    _collectionViewBar = collectionView;
    if (_cellContainXib) {
        UINib *nib = [UINib nibWithNibName:_cellId bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:_cellId];
    }else {
        [collectionView registerClass:_cellClass forCellWithReuseIdentifier:_cellId];
    }
}

// layout tab view
- (void)layoutTabPagerView
{
    ((UICollectionViewFlowLayout *)_collectionViewBar.collectionViewLayout).minimumLineSpacing = 0;
    // CGFloat collectionViewEaging = _barStyle != TYPagerBarStyleCoverView ? _collectionLayoutEdging : (_collectionLayoutEdging > 0 ? _collectionLayoutEdging : -_progressEdging+_cellSpacing);
    ((UICollectionViewFlowLayout *)self.collectionViewBar.collectionViewLayout).sectionInset = UIEdgeInsetsMake(5,0,0,0);
    //tabbar 位置
    
//    if(isIPhoneX())
//    {
//        _pagerBarView.frame = CGRectMake(0,self.collectionLayoutEdging ,CGRectGetWidth(self.view.frame),_kCollectionViewBarHieght);
//    }
//    else
//    {
        _pagerBarView.frame = CGRectMake(0,MG_TOP_MARGIN,CGRectGetWidth(self.view.frame),_kCollectionViewBarHieght);
//    }
    
    CGFloat collectionbar_w =0;
    for (int i =0; i<[self.dataSource numberOfControllersInPagerController]; i++)
    {
        NSString *title = [self.dataSource pagerController:self titleForIndex:i];
        CGFloat width = [self boundingSizeWithString:title font:_selectedTextFont constrainedToSize:CGSizeMake(300, 100)].width+_cellEdging*1.5;
        if (width > _pageBarWidth/7)
        {
            collectionbar_w +=width;
        }else
            collectionbar_w +=_pageBarWidth/7;
    }
    if (collectionbar_w > _pageBarWidth)
    {
        collectionbar_w =_pageBarWidth;
    }
//    _collectionViewBar.frame = CGRectMake(10,0,collectionbar_w,_kCollectionViewBarHieght);
    
//    _collectionViewBar.y += 10;
//    int x = CGRectGetMinXHorizontallyCenterInParentRect(self.view.frame,_collectionViewBar.frame);
//    _collectionViewBar.x = x;
    
    self.pagerBarView.frame = CGRectMake(0, isIPhoneX()  ? 30 : 10, kScreenW - self.collectionLayoutEdging , kRealValue(44));
    self.collectionViewBar.frame = self.pagerBarView.bounds;
}

//添加下划线
- (void)addUnderLineView
{
    UIView *underLineView = [[UIView alloc]init];
    underLineView.hidden = (_barStyle == TYPagerBarStyleNoneView);
    underLineView.layer.cornerRadius = 2;
    if (_barStyle != TYPagerBarStyleCoverView) {
        [_collectionViewBar addSubview:underLineView];
    }else{
        underLineView.layer.zPosition = -1;
        [_collectionViewBar insertSubview:underLineView atIndex:0];
    }
    _progressView = underLineView;
}

#pragma mark - setter
- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    _barStyle = barStyle;
    _progressView.hidden = (_barStyle == TYPagerBarStyleNoneView);
}

- (void)setDelegate:(id<TYTabPagerControllerDelegate>)delegate
{
    [super setDelegate:delegate];
    _tabDelegateFlags.configreReusableCell = [self.delegate respondsToSelector:@selector(pagerController:configreCell:forItemTitle:atIndexPath:)];
    _tabDelegateFlags.didSelectAtIndexPath = [self.delegate respondsToSelector:@selector(pagerController:didSelectAtIndexPath:)];
    _tabDelegateFlags.didScrollToTabPageIndex = [self.delegate respondsToSelector:@selector(pagerController:didScrollToTabPageIndex:)];
    _tabDelegateFlags.transitionFromeCellAnimated = [self.delegate respondsToSelector:@selector(pagerController:transitionFromeCell:toCell:animated:)];
    _tabDelegateFlags.transitionFromeCellProgress = [self.delegate respondsToSelector:@selector(pagerController:transitionFromeCell:toCell:progress:)];
}

- (void)setDataSource:(id<TYPagerControllerDataSource>)dataSource
{
    [super setDataSource:dataSource];
    
    _tabDataSourceFlags.titleForIndex = [self.dataSource respondsToSelector:@selector(pagerController:titleForIndex:)];
    NSAssert(_tabDataSourceFlags.titleForIndex, @"TYPagerControllerDataSource pagerController:titleForIndex: not impletement!");
}

#pragma mark - public
- (void)reloadData
{
    [_collectionViewBar reloadData];
    
    [super reloadData];
}

// update tab subviews frame
- (void)updateContentView
{
    [super updateContentView];
    [self layoutTabPagerView];
    [self setUnderLineFrameWithIndex:1 animated:NO];
    [self tabScrollToIndex:1 animated:NO];
}

- (void)registerCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib
{
    _cellClass = cellClass;
    _cellId = NSStringFromClass(cellClass);
    _cellContainXib = isContainXib;
}

- (CGRect)cellFrameWithIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return CGRectZero;
    }
    UICollectionViewLayoutAttributes * cellAttrs = [_collectionViewBar layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cellAttrs.frame;
}

- (UICollectionViewCell *)cellForIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return nil;
    }
    return [_collectionViewBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)tabScrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_tabDelegateFlags.didScrollToTabPageIndex) {
        [self.delegate pagerController:self didScrollToTabPageIndex:index];
    }
    
    if (index < self.countOfControllers) {
        [_collectionViewBar scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

#pragma mark - private
// set up progress view frame
//设置下划线
- (void)setUnderLineFrameWithIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_progressView.isHidden || self.countOfControllers == 0) {
        return;
    }
    CGRect cellFrame = [self cellFrameWithIndex:index];
    CGFloat progressEdging = _progressWidth > 0 ? (cellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressX = cellFrame.origin.x+progressEdging;
    CGFloat progressY = _barStyle == TYPagerBarStyleCoverView ? (cellFrame.size.height - _progressHeight)/2:(cellFrame.size.height - _progressHeight);
    progressY += 3;
    CGFloat width = cellFrame.size.width-2*progressEdging;
    if (animated) {
        [UIView animateWithDuration:_animateDuration animations:^{
            _progressView.frame = CGRectMake(progressX + 13, progressY+3, width - 26, _progressHeight);
        }];
    }else {
        _progressView.frame = CGRectMake(progressX + 13, progressY+3, width - 26, _progressHeight);
    }
}
- (void)setUnderLineFrameWithfromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    if (_progressView.isHidden || self.countOfControllers == 0) {
        return;
    }
    
    CGRect fromCellFrame = [self cellFrameWithIndex:fromIndex];
    CGRect toCellFrame = [self cellFrameWithIndex:toIndex];
    
    CGFloat progressFromEdging = _progressWidth > 0 ? (fromCellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressToEdging = _progressWidth > 0 ? (toCellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressY = _barStyle == TYPagerBarStyleCoverView ? (toCellFrame.size.height - _progressHeight)/2 + 3:(toCellFrame.size.height - _progressHeight) + 3;
    progressY += 3;
    CGFloat progressX, width;
    
    if (_barStyle == TYPagerBarStyleProgressBounceView) {
        if (fromCellFrame.origin.x < toCellFrame.origin.x) {
            if (progress <= 0.5) {
                progressX = fromCellFrame.origin.x + progressFromEdging ;
                width = (toCellFrame.size.width-progressToEdging+progressFromEdging+_cellSpacing)*2*progress + fromCellFrame.size.width-2*progressFromEdging ;
            }else {
                progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width-progressFromEdging+progressToEdging+_cellSpacing)*(progress-0.5)*2 ;
                width = CGRectGetMaxX(toCellFrame)-progressToEdging - progressX ;
            }
        }else {
            if (progress <= 0.5) {
                progressX = fromCellFrame.origin.x + progressFromEdging - (toCellFrame.size.width-progressToEdging+progressFromEdging+_cellSpacing)*2*progress;
                width = CGRectGetMaxX(fromCellFrame) - progressFromEdging - progressX ;
            }else {
                progressX = toCellFrame.origin.x + progressToEdging ;
                width = (fromCellFrame.size.width-progressFromEdging+progressToEdging + _cellSpacing)*(1-progress)*2 + toCellFrame.size.width - 2*progressToEdging ;
            }
        }
    }else {
        progressX = (toCellFrame.origin.x+progressToEdging-(fromCellFrame.origin.x+progressFromEdging))*progress+fromCellFrame.origin.x+progressFromEdging ;
        width = (toCellFrame.size.width-2*progressToEdging)*progress + (fromCellFrame.size.width-2*progressFromEdging)*(1-progress) ;
    }
    _progressView.frame = CGRectMake(progressX + 13,progressY+3, width - 26, _progressHeight);//下划线宽度
    
}
#pragma mark - override transition
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated
{
    UICollectionViewCell *fromCell = [self cellForIndex:fromIndex];
    UICollectionViewCell *toCell = [self cellForIndex:toIndex];
    
    if (![self isProgressScrollEnabel]) {
        // if isn't progressing
        if (_tabDelegateFlags.transitionFromeCellAnimated) {
            [self.delegate pagerController:self transitionFromeCell:fromCell toCell:toCell animated:animated];
        }
        [self setUnderLineFrameWithIndex:toIndex animated:fromCell && animated ? animated: NO];
    }
    [self tabScrollToIndex:toIndex animated:toCell ? YES : fromCell && animated ? animated: NO];
}
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    UICollectionViewCell *fromCell = (TYTabTitleViewCell *)[self cellForIndex:fromIndex];
    UICollectionViewCell *toCell = (TYTabTitleViewCell *)[self cellForIndex:toIndex];
    
    if (_tabDelegateFlags.transitionFromeCellProgress) {
        [self.delegate pagerController:self transitionFromeCell:fromCell toCell:toCell progress:progress];
    }
    
    [self setUnderLineFrameWithfromIndex:fromIndex toIndex:toIndex progress:progress];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfControllersInPagerController];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellId forIndexPath:indexPath];
    
    if (_tabDataSourceFlags.titleForIndex) {
        NSString *title = [self.dataSource pagerController:self titleForIndex:indexPath.item];
        if (_tabDelegateFlags.configreReusableCell) {
            [self.delegate pagerController:self configreCell:cell forItemTitle:title atIndexPath:indexPath];
        }
        
        if (_tabDelegateFlags.transitionFromeCellAnimated) {
            [self.delegate pagerController:self transitionFromeCell:(indexPath.item == self.curIndex ? nil : cell) toCell:(indexPath.item == self.curIndex ? cell : nil) animated:NO];
        }
        
    }
    
    return cell;
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self moveToControllerAtIndex:indexPath.item animated:YES];
    if (_tabDelegateFlags.didSelectAtIndexPath) {
        [self.delegate pagerController:self didSelectAtIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(false)
//    {
//        return CGSizeMake(_pageBarWidth/3,CGRectGetHeight(_collectionViewBar.frame) - 10);
//    }

    NSString *title = [self.dataSource pagerController:self titleForIndex:indexPath.item];
    CGFloat width = [self boundingSizeWithString:title font:_selectedTextFont constrainedToSize:CGSizeMake(300, 100)].width+_cellEdging*1.5;
    if (width > _pageBarWidth/7)
    {
        return CGSizeMake(width,CGRectGetHeight(_collectionViewBar.frame) - 10);
    }
    return CGSizeMake(_pageBarWidth/7,CGRectGetHeight(_collectionViewBar.frame) - 10);
}

// text size
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}
@end
