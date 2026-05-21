

#import "TYTabButtonPagerController.h"

@interface TYTabButtonPagerController ()
@property (nonatomic, assign) CGFloat selectFontScale;
@end

#define kUnderLineViewHeight 3
#define kTitleColor RGB(254, 0, 57)
#define ess_color [UIColor colorWithRed:139/255.0 green:78/255.0 blue:252/255.0 alpha:1]

@implementation TYTabButtonPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureTabButtonPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configureTabButtonPropertys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.delegate) {
        self.delegate = self;
    }
    if (!self.dataSource) {
        self.dataSource = self;
    }
    _selectFontScale = self.normalTextFont.pointSize/self.selectedTextFont.pointSize;
    [self configureSubViews];
}

- (void)configureSubViews
{
   //progress
    //下划线颜色
    self.progressView.backgroundColor = ess_color;
   //self.progressView.layer.cornerRadius = 20;
   //self.progressView.layer.masksToBounds = YES;
    // tabBar
    self.pagerBarView.backgroundColor = _pagerBarColor;
    self.collectionViewBar.backgroundColor = _collectionViewBarColor;
}

- (void)configureTabButtonPropertys
{
    self.cellSpacing = 2;
    self.cellEdging = 3;
    self.barStyle = TYPagerBarStyleProgressView;
    
    _normalTextColor = kBlackColor;
//    UIColorFromRGB(0x999999);//home 选中颜色
    
    _selectedTextColor = [UIColor colorWithHexString:@"#9152F8"];
//    UIColorFromRGB(0x7e37fb);
    _selectedbackcolor = kRedColor;
//    UIColorFromRGB(0x999999);
    
    _normalbackcolor = kGreenColor;
//    [UIColor colorWithRed:241/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    _pagerBarColor = kClearColor;
    _collectionViewBarColor = [UIColor clearColor];
    
    //_progressRadius = self.progressHeight/2;
    [self registerCellClass:[TYTabTitleViewCell class] isContainXib:NO];
    
}

- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    [super setBarStyle:barStyle];
    
    switch (barStyle) {
        case TYPagerBarStyleProgressView:
            self.progressWidth = 0;
            self.progressHeight = kUnderLineViewHeight;
            self.progressEdging = 3;
            break;
        case TYPagerBarStyleProgressBounceView:
            self.progressHeight = kUnderLineViewHeight;
            self.progressWidth = 20;
            break;
        case TYPagerBarStyleCoverView:
            self.progressWidth = 3;
            self.progressHeight = self.contentTopEdging-8;
            self.progressEdging = -self.progressHeight/4;
            break;
        default:
            break;
    }
    
    if (barStyle == TYPagerBarStyleCoverView) {
        self.progressColor = [UIColor lightGrayColor];
    }else {
        self.progressColor = UIColorFromRGB(0x7e37fb);
    }
    self.progressRadius = self.progressHeight/2;
}

#pragma mark - private
- (void)transitionFromCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell
{
    if (fromCell) {
        fromCell.titleLabel.textColor = _normalTextColor;
//        UIColorFromRGB(0x999999);
      //  fromCell.titleLabel.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
       fromCell.transform = CGAffineTransformMakeScale(self.selectFontScale, self.selectFontScale);
    }
    
    if (toCell) {
        toCell.titleLabel.textColor = _selectedTextColor;
//        Main_textColor;
//        toCell.titleLabel.backgroundColor = [UIColor blueColor];
        toCell.transform = CGAffineTransformIdentity;
    }
}

- (void)transitionFromCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    
    CGFloat currentTransform = (1.0 - self.selectFontScale)*progress;
    
    fromCell.transform = CGAffineTransformMakeScale(1.0-currentTransform, 1.0-currentTransform);
    toCell.transform = CGAffineTransformMakeScale(self.selectFontScale+currentTransform, self.selectFontScale+currentTransform);
    
    CGFloat narR,narG,narB,narA;
    CGFloat selR,selG,selB,selA;
    
    [self.normalTextColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    [self.selectedTextColor getRed:&selR green:&selG blue:&selB alpha:&selA];
 
    
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    
    fromCell.titleLabel.textColor = _normalTextColor;
//    [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    
    toCell.titleLabel.textColor = _selectedTextColor;
//    [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController
{
    NSAssert(NO, @"you must impletement method numberOfControllersInPagerController");
    return 1;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    NSAssert(NO, @"you must impletement method pagerController:controllerForIndex:");
    return nil;
}

#pragma mark - TYTabPagerControllerDelegate
- (void)pagerController:(TYTabPagerController *)pagerController configreCell:(TYTabTitleViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
    TYTabTitleViewCell *titleCell = (TYTabTitleViewCell *)cell;
    titleCell.titleLabel.text = title;
    titleCell.titleLabel.font = self.selectedTextFont;
}

- (void)pagerController:(TYTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self transitionFromCell:(TYTabTitleViewCell *)fromCell toCell:(TYTabTitleViewCell *)toCell];
        }];
    }else{
        [self transitionFromCell:fromCell toCell:toCell];
    }
}

- (void)pagerController:(TYTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    [self transitionFromCell:fromCell toCell:toCell progress:progress];
}

@end
