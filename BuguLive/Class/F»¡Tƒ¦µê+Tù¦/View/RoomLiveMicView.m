//
//  RoomLiveMicView.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomLiveMicView.h"
#import "RoomUsers.h"
#import "RoomUserCell.h"
#import "RoomMasterCell.h"
#import "RoomUserInfo.h"
#import "RoomModel.h"
#import "BogoRODispatchModel.h"
#import "VoiceHTTPManger.h"
#import "TrueLoveButton.h"
@interface RoomLiveMicView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RoomUserCellDelegate,RoomMasterCellDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) QMUIButton *shareBtn;
@property(nonatomic, strong) UIButton *trueLoveBtn;
@property(nonatomic, strong) NSMutableDictionary *cellDict;

@property(nonatomic, strong) QMUIFillButton *AnnouncementBtn;
//@property(nonatomic, strong) UIButton *numberBtn;
@property(nonatomic, strong) TrueLoveButton *trueLoveButton;

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UIImageView *iconImageView1;
@property(nonatomic, strong) UIImageView *rankImageView1;

@property(nonatomic, strong) UIImageView *iconImageView2;
@property(nonatomic, strong) UIImageView *rankImageView2;

@property(nonatomic, strong) UIImageView *iconImageView3;
@property(nonatomic, strong) UIImageView *rankImageView3;

@property(nonatomic, strong) UIView *roomOrderDispatchView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *infoBtn;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) int timeCount;
@end

@implementation RoomLiveMicView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpView];

        
    }
    return self;
}



- (void)setUpView {
    self.backgroundColor = kClearColor;
    [self addSubview:self.collectionView];
//    [self addSubview:self.trueLoveBtn];
    
    self.clipsToBounds = NO;
    _AnnouncementBtn = ({
        
        QMUIFillButton * button = [[QMUIFillButton alloc]initWithFrame:CGRectZero];
//        button.spacingBetweenImageAndTitle = 8;
//        [button setTitle:ASLocalizedString(@"公告") forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"公告 (1)"] forState:UIControlStateNormal];
   
//        button.layer.cornerRadius = 13;
        button.clipsToBounds = YES;
        button.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.15];
        [button addTarget:self action:@selector(AnnouncementBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        button;
        
    });
    
    _trueLoveButton = ({
        
        TrueLoveButton * button = [TrueLoveButton getView];
//        button.layer.cornerRadius = 13;
//        button.clipsToBounds = YES;
//        button.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.15];
        //添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTrueLoveButtonRecognizer)];
        [button addGestureRecognizer:tapGesture];
        button;
        
    });
    
    
    [self addSubview:_AnnouncementBtn];
    [self addSubview:_trueLoveButton];
    
    _numBtn = ({

        UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
        [button setTitle:ASLocalizedString(@"0在线") forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];

        button.layer.cornerRadius = 13;
        button.clipsToBounds = YES;
        button.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.15];
        [button addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        button;

    });

    [self addSubview:_numBtn];
//
//    self.bgView = [[UIView alloc]init];
//    self.bgView.backgroundColor = kClearColor;
//    [self addSubview:self.bgView];

    
    
    [_AnnouncementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@8);
        make.top.mas_equalTo(15);
//        make.bottom.equalTo(self.trueLoveBtn);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(26);
        
    }];
    
    [_trueLoveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_AnnouncementBtn.mas_right).offset(8);
        make.top.mas_equalTo(15);
//        make.bottom.equalTo(self.trueLoveBtn);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(23);
        
    }];
    
    [_numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(_trueLoveButton);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(26);

    }];
//
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.trueLoveBtn.mas_left).offset(-3);
//        make.bottom.equalTo(_AnnouncementBtn.mas_bottom).offset(1.5);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(100);
//
//    }];
//
//
//    for (int i = 0; i < 3; i ++) {
//
//
//
//          UIImageView * iconImageView1 = [[UIImageView alloc]init];
//          iconImageView1.contentMode = UIViewContentModeScaleAspectFill;
//          iconImageView1.clipsToBounds = YES;
//          [self.bgView addSubview:iconImageView1];
//
//
//
//
//          UIImageView * rankImageView1 = [[UIImageView alloc]init];
//          rankImageView1.contentMode = UIViewContentModeScaleAspectFill;
//
//          [self.bgView addSubview:rankImageView1];
//
//
//
//        if (i == 0) {
//            self.iconImageView1 = iconImageView1;
//            self.rankImageView1 = rankImageView1;
//
//            iconImageView1.layer.cornerRadius = 13;
//
//            [iconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(-1.5);
//                make.left.mas_equalTo(4);
//                make.size.mas_equalTo(26);
//            }];
//
//            [rankImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(0);
//                make.left.mas_equalTo(0);
//                make.width.mas_equalTo(31);
//                make.height.mas_equalTo(38);
//
//            }];
//
//
//        }else if (i == 1){
//            self.iconImageView2 = iconImageView1;
//            self.rankImageView2 = rankImageView1;
//
//            iconImageView1.layer.cornerRadius = 13;
//
//            [iconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(-1.5);
//                make.left.mas_equalTo(4+31);
//                make.size.mas_equalTo(26);
//            }];
//
//            [rankImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(0);
//                make.left.mas_equalTo(31);
//                make.width.mas_equalTo(31);
//                make.height.mas_equalTo(40);
//
//            }];
//
//        }else {
//            self.iconImageView3 = iconImageView1;
//            self.rankImageView3 = rankImageView1;
//
//            iconImageView1.layer.cornerRadius = 12.5;
//
//            [iconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(-1.5);
//                make.left.mas_equalTo(31+31.5+1+3.5);
//                make.size.mas_equalTo(25);
//            }];
//
//            [rankImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(0);
//                make.left.mas_equalTo(31+31.5+1);
//                make.width.mas_equalTo(30);
//                make.height.mas_equalTo(40);
//
//            }];
//
//        }
//
//
//
//
//
//
//
//    }
//
    [self addSubview:self.roomOrderDispatchView];
    [self.roomOrderDispatchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_AnnouncementBtn.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);

    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);

    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);

    }];
    [self.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(21);

    }];
    
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 50, 3, 50, 50)];
//    button.backgroundColor = KBlueColor;
//    [button setTitle:@"调试" forState:UIControlStateNormal];
//    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(debug) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
    
    
    
}

- (void)handleTrueLoveButtonRecognizer {
    if([self.delegate respondsToSelector:@selector(micViewdidClickRoomTrueLove)])
    {
        [self.delegate micViewdidClickRoomTrueLove];
    }
}

- (void)debug {

    
}
- (void)setUpViewddd {
    self.backgroundColor = kClearColor;
    [self addSubview:self.collectionView];
    //        [self addSubview:self.shareBtn];
    //        [self addSubview:self.trueLoveBtn];
}


- (void)setUsers:(RoomUsers *)users{
    _users = users;
    
    
    RoomUserInfo *model = self.users.dataArray[0];
 
    
    [self.collectionView reloadData];
}

- (void)setModel:(RoomModel *)model{
    _model = model;
    [self.shareBtn setTitle:[NSString stringWithFormat:@"ID:%@",model.voice.luck.integerValue ? model.voice.luck : model.voice.user_id] forState:UIControlStateNormal];
    
    self.is_open_guest = (model.voice.room_type.intValue == 2);

    [self.collectionView reloadData];
    
    self.roomOrderDispatchView.hidden = !self.is_open_guest;
//    self.bgView.hidden = self.is_open_guest;
//    self.trueLoveBtn.hidden = self.is_open_guest;
}
- (void)setOrder:(BogoRODispatchModel *)order{
    _order = order;
    
    if ([_timer isValid]) {
        [_timer invalidate];
       
    }
    _timer =nil;
    if (order.status.intValue == 2) {
        
        self.timeLabel.text = @"00:00";
    } else {
        self.timeCount = order.duration_time.intValue;
        
        self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",_timeCount / 60,_timeCount % 60];
       
     
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
    }
    
  
}

- (void)timerAction {
    
    _timeCount ++;

    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",_timeCount / 60,_timeCount % 60];

}

//*/

- (void)shareBtnAction:(QMUIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickShareBtn:)]) {
        [self.delegate micView:self didClickShareBtn:sender];
    }
}

- (void)trueLoveBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickTrueLoveBtn:)]) {
        [self.delegate micView:self didClickTrueLoveBtn:sender];
    }
}

- (void)AnnouncementBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickAnnouncementBtn:)]) {
           [self.delegate micView:self didClickAnnouncementBtn:sender];
       }
}


- (void)numBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickNumberBtn:)]) {
           [self.delegate micView:self didClickNumberBtn:sender];
       }
}

- (void)infoBtnAction:(UIButton *)sender {
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickRoomOrderDispatchInfoBtn:)]) {
        [self.delegate micView:self didClickRoomOrderDispatchInfoBtn:sender];
    }
    
}


- (void)refreshData{
    
    
    /*
    
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/get_voice_userlist
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"get_voice_userlist"];
    [CYNET POSTv2:url parameters:@{@"id":_model.voice.id} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            
            
            
//            [strongSelf.dataArray removeAllObjects];
//            for (NSDictionary *dict in responseObject[@"userlist"]) {
//                RoomUserInfo *model = [RoomUserInfo mj_objectWithKeyValues:dict];
//                [strongSelf.dataArray addObject:model];
//            }
//            [strongSelf.numberBtn setTitle:[NSString stringWithFormat:@"在线人数%ld",strongSelf.dataArray.count] forState:UIControlStateNormal];
//            _number = strongSelf.dataArray.count;
//            [strongSelf.collectionView reloadData];
            
            
            
            NSArray * temp = responseObject[@"userlist"];
            [strongSelf.numBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"%ld在线"),temp.count] forState:UIControlStateNormal];
            CGSize btnSize = [_numBtn sizeThatFits:CGSizeMake(kScreenW-80-104, 26)];
            [_numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(btnSize.width+16);
            }];
        }
    } failure:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];
     
     */
}
#pragma mark - RoomUserCellDelegate
- (void)userCell:(RoomUserCell *)userCell didClickGiftView:(UIView *)giftView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:userCell:didClickGiftView:)]) {
        [self.delegate micView:self userCell:userCell didClickGiftView:giftView];
    }
}

- (void)masterCell:(RoomMasterCell *)masterCell didClickGiftView:(UIView *)giftView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(micView:masterCell:didClickGiftView:)]) {
        [self.delegate micView:self masterCell:masterCell didClickGiftView:giftView];
    }
}
- (void)masterCell:(RoomMasterCell *)masterCell didClickUser:(RoomUserInfo *)model{
    if (!model.user_id.integerValue) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickLinkBtnIndex:)]) {
            [self.delegate micView:self didClickLinkBtnIndex:0];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickUser:)]) {
            [self.delegate micView:self didClickUser:model];
        }
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.wheat_type_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 0) {
        RoomMasterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RoomMasterCell class]) forIndexPath:indexPath];
        cell.is_open_guest = self.is_open_guest;

        RoomUserInfo *model = self.users.dataArray[indexPath.item];
        model.location = @"1";
//        [cell setModel:model];
        [cell setWheatModel:self.model.wheat_type_list[indexPath.item]];
        cell.delegate = self;

        return cell;
    }
    
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [self.cellDict objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"RoomUserCell", [NSString stringWithFormat:@"%@", indexPath]];
        [self.cellDict setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RoomUserCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    }
    RoomUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.is_open_guest = self.is_open_guest;

    RoomUserInfo *model = self.users.dataArray[indexPath.item ];
    model.location = [NSString stringWithFormat:@"%ld",indexPath.item ];
//    [cell setModel:model];
    [cell setWheatModel:self.model.wheat_type_list[indexPath.item ]];
    cell.delegate = self;
     return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_is_open_guest) {
        if (indexPath.item == 0) {
            //暂时这样位置
            return CGSizeMake(collectionView.width/2.3, 130);
        }else if (indexPath.item == 1){
            return CGSizeMake(collectionView.width/2.3, 130);
        }
        else{
            return CGSizeMake(collectionView.width / 4, 110);
        }
    }
    
    if(self.model.wheat_type_list.count == 11)
    {
        if (indexPath.item == 0) {
            return CGSizeMake(collectionView.width, 130);
        }else{
            return CGSizeMake(collectionView.width / 5, 115);
        }
    }
    if(self.model.wheat_type_list.count == 5 || self.model.wheat_type_list.count == 10 || self.model.wheat_type_list.count == 15)
    {
        return CGSizeMake(collectionView.width / 5, 115);
    }
    else if(self.model.wheat_type_list.count == 20)
    {
        return CGSizeMake(collectionView.width / 5, 115);
    }
    else
    {
        if (indexPath.item == 0) {
            return CGSizeMake(collectionView.width, 130);
        }else{
            return CGSizeMake(collectionView.width / 4, 115);
        }
    }

//    return CGSizeMake(collectionView.width / 4, 115);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==0) {
        return;
    }
    Wheat_Type_List *model = self.model.wheat_type_list[indexPath.item];
    if (!model.even_wheat.user_id) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickLinkBtnIndex:)]) {
//            [self.delegate micView:self didClickLinkBtnIndex:indexPath.item + 1];
            [self.delegate micView:self didClickLinkBtnIndex:indexPath.item ];

        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(micView:didClickUser:)]) {
            [self.delegate micView:self didClickUser:model];
        }
    }
}


- (void)ApplyForMicrophone
{
    
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 40, self.width - 30, self.height - 40) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.clipsToBounds = NO;
//        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RoomUserCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([RoomUserCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RoomMasterCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([RoomMasterCell class])];
    }
    return _collectionView;
}

- (QMUIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(-15, 6, 100, 30)];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        _shareBtn.layer.cornerRadius = 15;
        _shareBtn.clipsToBounds = YES;
        _shareBtn.imagePosition = QMUIButtonImagePositionRight;
        _shareBtn.backgroundColor = [kBlackColor colorWithAlphaComponent:0.1];
        [_shareBtn setTitle:@"ID:" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor colorWithHexString:@"#909299"] forState:UIControlStateNormal];
        [_shareBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_shareBtn setSpacingBetweenImageAndTitle:3];
        _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (UIButton *)trueLoveBtn{
    if (!_trueLoveBtn) {
        _trueLoveBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 15, 30, 30)];
        _trueLoveBtn.right = self.width - 18;
        [_trueLoveBtn setImage:[UIImage imageNamed:@"go1_"] forState:UIControlStateNormal];
        [_trueLoveBtn addTarget:self action:@selector(trueLoveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trueLoveBtn;
}

//- (UIButton *)trueLoveBtn{
//    if (!_trueLoveBtn) {
//        _trueLoveBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 2, 43, 39)];
//        _trueLoveBtn.right = self.width - 18;
//        [_trueLoveBtn setImage:[UIImage imageNamed:@"love_list"] forState:UIControlStateNormal];
//        [_trueLoveBtn addTarget:self action:@selector(trueLoveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _trueLoveBtn;
//}

- (RoomUserInfo *)emptyUser{
    RoomUserInfo *user = [[RoomUserInfo alloc]init];
    user.user_id = @"0";
    return user;
}

- (NSMutableDictionary *)cellDict{
    if (!_cellDict) {
        _cellDict = [NSMutableDictionary dictionary];
    }
    return _cellDict;
}

- (UIView *)roomOrderDispatchView{
    if (!_roomOrderDispatchView) {
        _roomOrderDispatchView = [[UIView alloc]init];
        _roomOrderDispatchView.backgroundColor = kClearColor;
        _roomOrderDispatchView.hidden = YES;
        
        [_roomOrderDispatchView addSubview:self.titleLabel];
        [_roomOrderDispatchView addSubview:self.timeLabel];
        [_roomOrderDispatchView addSubview:self.infoBtn];

    }
    return _roomOrderDispatchView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.text = ASLocalizedString(@"派单计时");
        _titleLabel.font = [UIFont systemFontOfSize:11];
        
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#FF7200"];
        _timeLabel.text = ASLocalizedString(@"00:00");
        _timeLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _timeLabel;
}

- (UIButton *)infoBtn{
    if (!_infoBtn) {
        _infoBtn = [[UIButton alloc]init];
        [_infoBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_infoBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _infoBtn.layer.cornerRadius = 21/2.0;
        _infoBtn.clipsToBounds = YES;
        _infoBtn.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.1];
        [_infoBtn setTitle:ASLocalizedString(@"派单详情") forState:UIControlStateNormal];
//        [_applyBtn.layer addSublayer:gl];
        [_infoBtn addTarget:self action:@selector(infoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBtn;
}

-(void)sendGift:(CustomMessageModel *)msgModel
{
//    RoomUserInfo *model = self.users.dataArray[indexPath.item];
//    model.location = @"1";
////        [cell setModel:model];
//    [cell setWheatModel:self.model.wheat_type_list[indexPath.item]];
    
    for (int i = 0; i < self.model.wheat_type_list.count; i++) {
        Wheat_Type_List *model = self.model.wheat_type_list[i];
        if(model.even_wheat.user_id == msgModel.to_user_id.intValue)
        {
            model.even_wheat.gift_earnings += msgModel.prop_coin.intValue;
            [self.collectionView reloadData];
        }
    }
}
@end
