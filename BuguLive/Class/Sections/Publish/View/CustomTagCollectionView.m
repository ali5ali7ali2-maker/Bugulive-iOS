#import "CustomTagCollectionView.h"
#import "VoicePeopleTagView.h"
@interface CustomTagCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) NSString *selectedTag;


@end

@implementation CustomTagCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumInteritemSpacing = 8;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //改成注册xib VoicePeopleTagView
    [self.collectionView registerNib:[UINib nibWithNibName:[VoicePeopleTagView className] bundle:nil] forCellWithReuseIdentifier:@"VoicePeopleTagView"];
    [self addSubview:self.collectionView];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VoicePeopleTagView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VoicePeopleTagView" forIndexPath:indexPath];
    cell.peopleName = self.tags[indexPath.item];
    if ([self.selectedTag isEqualToString:self.tags[indexPath.item]]) {
        cell.cellSelected = YES;
    }
    else {
        cell.cellSelected = NO;
    }
//    cell.tagLabel.text = self.tags[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(indexPath.item);
        self.selectedTag = self.tags[indexPath.item];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.collectionView.width-30)/2, 132);
}

@end
