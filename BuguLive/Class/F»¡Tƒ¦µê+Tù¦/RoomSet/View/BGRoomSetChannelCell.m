//
//  BGRoomSetChannelCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomSetChannelCell.h"
#import "BGRoomSetChannelCollectCell.h"

@implementation BGRoomSetChannelCell
{
    UILabel *_micLable;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}



- (void)initUI {
    
 
    self.backgroundColor = kClearColor;
    self.contentView.backgroundColor = kClearColor;

    self.bgImageView = ({
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView;
    });
    ViewRadius(self.bgImageView, 10);
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    _micLable = [[UILabel alloc] init];
    _micLable.text = ASLocalizedString(@"麦位数量");
    _micLable.textColor = kWhiteColor;
    _micLable.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_micLable];
    [_micLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(10);
        make.left.equalTo(self.bgImageView).offset(10);
    }];
    
    self.bgImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_micLable.mas_bottom).offset(10);
        make.left.equalTo(self.bgImageView).offset(8);
        make.right.equalTo(self.bgImageView).offset(-8);
        make.height.equalTo(self.bgImageView).offset(-33-12);
    }];
  
    
}

- (void)setChannelDataArray:(NSArray *)channelDataArray{
    _channelDataArray = channelDataArray;
    
    self.collectionView.height = self.height;
    
    
    [self.collectionView reloadData];
}


- (void)setVoice_type:(NSString *)voice_type{
    _voice_type = voice_type;
//    for (NSInteger i = 0; i < self.channelDataArray.count; i++) {
//        VideoClassifiedModel *model = self.channelDataArray[i];
//        if ([model.id isEqualToString:voice_type]) {
//            model.isSelected = YES;
//          
//        }
//    }
    [self.collectionView reloadData];

}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channelDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BGRoomSetChannelCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BGRoomSetChannelCollectCell class]) forIndexPath:indexPath];
    [cell setModel:self.channelDataArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( floor(( kScreenW - 20*2 ) / 3 - 12*2), 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 10, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoClassifiedModel *model = self.channelDataArray[indexPath.item];
    
    if (model.isSelected) {
        
        model.isSelected = NO;
        if (self.selectedChannel) {
            self.selectedChannel(nil);
        }
        [collectionView reloadData];

        
    }else{
        
        for (VideoClassifiedModel *typeModel in self.channelDataArray) {
            typeModel.isSelected = (typeModel == model);
            
            if (typeModel.isSelected) {
                if (self.selectedChannel) {
                    self.selectedChannel(typeModel);
                }
            }
        }
        [collectionView reloadData];
        
    }
}



- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[BGRoomSetChannelCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([BGRoomSetChannelCollectCell class])];
    
    }
    return _collectionView;
}

@end
