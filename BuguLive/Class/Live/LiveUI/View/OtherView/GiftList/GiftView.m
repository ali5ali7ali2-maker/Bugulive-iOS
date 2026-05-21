//
//  GiftView.m
//  BuguLive
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GiftView.h"

#import "SDCycleScrollView2.h"
#import "BogoNobleViewController.h"
#import "BogoLiveGiftViewPeopleCell.h"
#import "RoomUserInfo.h"
#import "GiftQuantityModel.h"
#define kGiftHorizontalNum              4   // 礼物横向的个数
#define kContinueContainerViewWidth     80  // 连发按钮宽、高度

@interface GiftView()<GiftSubViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray        *bottomViewArray;
@property (nonatomic, assign) NSInteger             giftVerticalNum;            //礼物纵向的个数
@property (nonatomic, strong) NSMutableArray        *giftMArray;
@property (nonatomic, strong) NSMutableArray        *itemArray;                 //保存GiftSubView的数组
@property (nonatomic, strong) GiftModel             *currentGiftModel;          //当前选中的GiftModel
@property (nonatomic, strong) UIView                *rechargeContainerView;     //充值容器视图
@property (nonatomic, strong) UILabel               *diamondsLabel;             //账户剩余钻石
@property (nonatomic, strong) UIImageView           *rechargeImgView;           //充值图标
@property (nonatomic, strong) QMUIButton            *rechargeBtn;           //充值按钮
@property (nonatomic, strong) UIButton              *continueBtn;               //连发按钮
@property (nonatomic, strong) UICountingLabel       *sendedTimeLabel;           //发送次数
@property (nonatomic, assign) NSInteger             sendedTime;                 //发送次数
@property (nonatomic, assign) NSInteger             sendedTimeCopy;             //发送次数
@property (nonatomic, assign) int                   upSelectedIndex;            //上一次选中的index
@property(nonatomic, strong) QMUIPopupMenuView *popView;
@property(nonatomic, strong) GiftQuantityModel *numberModel;
@property(nonatomic, strong) UIImageView *diamondsImgView;
//@property (nonatomic, strong) GiftGroupView *groupView;

@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UIView *bottomNumberView;

@property(nonatomic, strong) UICollectionView *peopleCollectionView;
@property(nonatomic, strong) NSMutableArray *newUserArray;
@property(nonatomic, strong) NSString *selectUser;
@end

@implementation GiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self initUI];
    }
    return self;
}
- (void)setIsHost:(BOOL)isHost
{
    _isHost = isHost;
    if(_isHost && !self.isVoice)
    {
        
        self.bottomContainerView.hidden = YES;
    }
}
-(void)reequestUserList
{
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"get_wheat_user" forKey:@"act"];
    NSString *roomID = @"";
    if([self.delegate respondsToSelector:@selector(roomId)])
    {
        roomID = [self.delegate roomId];
    }
    [dict setValue:roomID forKey:@"room_id"];

//    [[BGHUDHelper sharedInstance] syncLoading];

    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            

            weakSelf.newUserArray = [NSMutableArray array];
            NSMutableArray *data = responseJson[@"data"];
           
            if(data.count > 0)
            {
                RoomUserInfo *model = [RoomUserInfo mj_objectWithKeyValues:data[0]];
                [GlobalVariables sharedInstance].giftSelecUserId = model.user_id;
            }
            else
            {
                [GlobalVariables sharedInstance].giftSelecUserId = nil;
            }
            int i = 0;
            for (NSDictionary *dict in data) {
                RoomUserInfo *model = [RoomUserInfo mj_objectWithKeyValues:dict];
                if(i == 0)
                {
                    model.selected = YES;
                }
                [weakSelf.newUserArray addObject:model];
                i++;
            }
            
            [self.peopleCollectionView reloadData];
            
          
        }

        
        
    } FailureBlock:^(NSError *error) {
//        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
}

-(void)initUI
{
    CGRect frame = self.frame;
    self.numberModel = [GlobalVariables sharedInstance].giftQuantityModelList[0];
    
    self.backgroundColor = kClearColor;
    
    // 毛玻璃效果
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [self addSubview:effectView];
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.bgImgView.image = [UIImage imageNamed:@"mg_live_gift_bgImgView"];
    self.bgImgView.userInteractionEnabled = YES;
    [self addSubview:self.bgImgView];
    
    _itemArray = [NSMutableArray array];
    _bottomViewArray = [NSMutableArray array];
    
    UIView *bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-kSendGiftContrainerHeight, frame.size.width, kSendGiftContrainerHeight + MG_BOTTOM_MARGIN +  50)];
    bottomContainerView.backgroundColor = [UIColor colorWithHexString:@"#221336"];

    
    /*
    self.bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.bgImgView.image = [UIImage imageNamed:@"mg_live_gift_bgImgView"];
    self.bgImgView.userInteractionEnabled = YES;
    [self addSubview:self.bgImgView];
    
    _itemArray = [NSMutableArray array];
    _bottomViewArray = [NSMutableArray array];
    
    
    
    UIView *bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-kSendGiftContrainerHeight, frame.size.width, kSendGiftContrainerHeight + MG_BOTTOM_MARGIN +  50)];
    
    UIView *back = [[UIView alloc] initWithFrame:bottomContainerView.frame];
    back.backgroundColor = [UIColor colorWithHexString:@"#221336"];
    [self addSubview:back];

    
    bottomContainerView.backgroundColor = [UIColor colorWithHexString:@"#221336"];*/
    
    
    [self addSubview:bottomContainerView];
    
    _rechargeContainerView = [[UIView alloc]initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin, kScreenW, kSendGiftContrainerHeight-kDefaultMargin*2)];
    _rechargeContainerView.backgroundColor = [UIColor colorWithHexString:@"#221336"];

    
//        kGrayTransparentColor3_1;
    [self addSubview:bottomContainerView];
    self.bottomContainerView = bottomContainerView;
    _rechargeContainerView = [[UIView alloc]initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin, kScreenW, kSendGiftContrainerHeight-kDefaultMargin*2)];
    _rechargeContainerView.backgroundColor = [UIColor colorWithHexString:@"#221336"];
    [bottomContainerView addSubview:_rechargeContainerView];

//        kGrayTransparentColor5;
    /*
    _rechargeContainerView.userInteractionEnabled = YES;
    _rechargeContainerView.layer.cornerRadius = CGRectGetHeight(_rechargeContainerView.frame)/2;
    _rechargeContainerView = [[UIView alloc]initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin, kScreenW, kSendGiftContrainerHeight-kDefaultMargin*2)];
    _rechargeContainerView.backgroundColor = [UIColor colorWithHexString:@"#221336"];

//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRechargeAction)];
//        tap.delegate = self;
//        [_rechargeContainerView addGestureRecognizer:tap];
    
    //2020-1-15 修改礼物界面
    
    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, 0, 50, CGRectGetHeight(_rechargeContainerView.frame))];
    Label.font = [UIFont systemFontOfSize:14.0];
    Label.textColor = kWhiteColor;
    Label.text = ASLocalizedString(@"余额:");
    [self.topView addSubview:Label];
    
    _diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Label.frame),(CGRectGetHeight(_rechargeContainerView.frame)-15)/2, 15, 15)];
    _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];

    _diamondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+kDefaultMargin, 0, 50, CGRectGetHeight(_rechargeContainerView.frame))];
    _diamondsLabel.font = [UIFont systemFontOfSize:14.0];
    _diamondsLabel.textAlignment = NSTextAlignmentRight;
    _diamondsLabel.textColor = kWhiteColor;
    _diamondsLabel.text = @"0";


    _rechargeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsLabel.frame)+kDefaultMargin,(CGRectGetHeight(_rechargeContainerView.frame)-16)/2, 16, 16)];
    _rechargeImgView.contentMode = UIViewContentModeScaleAspectFit;
    _rechargeImgView.hidden = YES;
     */
//        [_rechargeImgView setImage:[UIImage imageNamed:@"lr_gift_list_recharge"]];
    
    

    
    //2020-1-15 修改礼物界面
    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, 0, 60, CGRectGetHeight(_rechargeContainerView.frame))];
    Label.font = [UIFont systemFontOfSize:14.0];
    Label.textColor = kWhiteColor;
    Label.text = ASLocalizedString(@"余额:");
//    [_rechargeContainerView addSubview:Label];
    
    UIImageView *diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Label.frame),(CGRectGetHeight(_rechargeContainerView.frame)-15)/2, 15, 15)];
    diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
    [diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
//    [_rechargeContainerView addSubview:diamondsImgView];
    
    _diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Label.frame),(CGRectGetHeight(_rechargeContainerView.frame)-15)/2, 15, 15)];
    _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];

    _diamondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+kDefaultMargin, 0, 50, CGRectGetHeight(_rechargeContainerView.frame))];
    _diamondsLabel.font = [UIFont systemFontOfSize:14.0];
    _diamondsLabel.textAlignment = NSTextAlignmentRight;
    _diamondsLabel.textColor = kWhiteColor;
    _diamondsLabel.text = @"0";
    
    _rechargeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsLabel.frame)+kDefaultMargin,(CGRectGetHeight(_rechargeContainerView.frame)-16)/2, 16, 16)];
    _rechargeImgView.contentMode = UIViewContentModeScaleAspectFit;
    _rechargeImgView.hidden = YES;
    
    _rechargeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.frame = CGRectMake(_diamondsLabel.right + kDefaultMargin, (CGRectGetHeight(_rechargeContainerView.frame)-20)/2, 100, 20);
    _rechargeBtn.layer.cornerRadius = 20 / 2;

    
    _rechargeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.frame = CGRectMake(_diamondsLabel.right + kDefaultMargin, 5, 100, 20);
    _rechargeBtn.layer.cornerRadius = 20 / 2;
    
    [_rechargeBtn setTitleColor:[UIColor colorWithHexString:@"#C28CF8"] forState:UIControlStateNormal];
    _rechargeBtn.userInteractionEnabled = YES;
//        _rechargeBtn.enabled = NO;
    [_rechargeBtn setTitle:ASLocalizedString(@"充值 >")forState:UIControlStateNormal];
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _rechargeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_rechargeBtn setImagePosition:QMUIButtonImagePositionRight];
    _rechargeBtn.spacingBetweenImageAndTitle = 2;
    _rechargeBtn.backgroundColor = kClearColor;
    [_rechargeBtn addTarget:self action:@selector(clickRechargeAction) forControlEvents:UIControlEventTouchUpInside];
    //[_rechargeBtn setImage:[UIImage imageNamed:@"lr_gift_list_recharge_next"] forState:UIControlStateNormal];
    _rechargeBtn.layer.borderColor = [UIColor colorWithHexString:@"#C28CF8"].CGColor;
    _rechargeBtn.layer.borderWidth = 1.5f;
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(frame.size.width-60-kDefaultMargin - 10, kDefaultMargin/2, 70, kSendGiftContrainerHeight-kDefaultMargin);
    
    
    
    _numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberBtn.frame = CGRectMake(_sendBtn.left - 50, kDefaultMargin/2, 90, kSendGiftContrainerHeight-kDefaultMargin);

    
    
//        [_numberBtn setTitle:@"X 1" forState:UIControlStateNormal];
    [self resetNumber];
//        [_sendBtn setImage:[UIImage imageNamed:@"ic_gift_send"] forState:UIControlStateNormal];
//        [_sendBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
//        [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
//        [_numberBtn setTitle:ASLocalizedString(@"发送")forState:UIControlStateNormal];
//        [_numberBtn setBackgroundImage:[UIImage imageNamed:@"发送按钮"] forState:UIControlStateNormal];
    /*
    _numberBtn.layer.cornerRadius = CGRectGetHeight(_numberBtn.frame)/2;
    _numberBtn.backgroundColor = RGB(55,34,86);
    _numberBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _numberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _numberBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    _numberBtn.layer.masksToBounds = YES;
    _numberBtn.titleLabel.font = kAppMiddleTextFont;
    [_numberBtn addTarget:self action:@selector(setNumAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomContainerView addSubview:_numberBtn];*/
    
//    _numberBtn.layer.cornerRadius = CGRectGetHeight(_numberBtn.frame)/2;
//    _numberBtn.backgroundColor = RGB(55,34,86);
//    _numberBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    _numberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    _numberBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//
//    _numberBtn.layer.masksToBounds = YES;
//    _numberBtn.titleLabel.font = kAppMiddleTextFont;
//    [_numberBtn addTarget:self action:@selector(setNumAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomContainerView addSubview:_numberBtn];

    
    
    [bottomContainerView addSubview:self.bottomNumberView];
    

//        [_sendBtn setTitle:ASLocalizedString(@"送礼")forState:UIControlStateNormal];
//        [_sendBtn setImage:[UIImage imageNamed:@"ic_gift_send"] forState:UIControlStateNormal];
//        [_sendBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
//        [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    
    [_sendBtn setTitle:ASLocalizedString(@"发送")forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"发送按钮"] forState:UIControlStateNormal];
    _sendBtn.layer.cornerRadius = CGRectGetHeight(_sendBtn.frame)/2;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.titleLabel.font = kAppMiddleTextFont;
    [_sendBtn addTarget:self action:@selector(senGiftAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomContainerView addSubview:_sendBtn];
    
    
    _continueContainerView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-kContinueContainerViewWidth-kDefaultMargin*2, frame.size.height-kContinueContainerViewWidth-kDefaultMargin*2-20, kContinueContainerViewWidth, kContinueContainerViewWidth+20)];
    _continueContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_continueContainerView];
    _continueContainerView.hidden = YES;
    
    _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _continueBtn.frame = CGRectMake(0, 0, kContinueContainerViewWidth, kContinueContainerViewWidth);
    [_continueBtn setImage:[UIImage imageNamed:@"lr_send_gift_normal"] forState:UIControlStateNormal];
    [_continueBtn setImage:[UIImage imageNamed:@"lr_send_gift_selected"] forState:UIControlStateHighlighted];
    [_continueBtn setBackgroundColor:[UIColor clearColor]];
    [_continueBtn addTarget:self action:@selector(senGiftAction:) forControlEvents:UIControlEventTouchUpInside];
    [_continueContainerView addSubview:_continueBtn];
    
    UILabel *continueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kContinueContainerViewWidth/2-21, kContinueContainerViewWidth, 21)];
    continueLabel.font = [UIFont systemFontOfSize:15.0];
    continueLabel.textAlignment = NSTextAlignmentCenter;
    continueLabel.textColor = [UIColor whiteColor];
    continueLabel.text = ASLocalizedString(@"连发");
    [_continueContainerView addSubview:continueLabel];
    
    _decTimeCLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, kContinueContainerViewWidth/2, kContinueContainerViewWidth, 21)];
    _decTimeCLabel.method = UILabelCountingMethodLinear;
    _decTimeCLabel.textAlignment = NSTextAlignmentCenter;
    _decTimeCLabel.textColor = [UIColor whiteColor];
    [_continueContainerView addSubview:_decTimeCLabel];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    _decTimeCLabel.formatBlock = ^NSString* (CGFloat value)
    {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return formatted;
    };
    _decTimeCLabel.method = UILabelCountingMethodLinear;
    
    _sendedTimeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, -10, kContinueContainerViewWidth, 21)];
    _sendedTimeLabel.method = UILabelCountingMethodEaseOut;
    _sendedTimeLabel.textAlignment = NSTextAlignmentCenter;
    _sendedTimeLabel.textColor = kWhiteColor;
    [_continueContainerView addSubview:_sendedTimeLabel];
    _sendedTimeLabel.formatBlock = ^NSString* (CGFloat value)
    {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return formatted;
    };
    _sendedTimeLabel.method = UILabelCountingMethodLinear;
}

- (void)resetNumber {
    [_numberBtn setTitle:self.numberModel.title forState:UIControlStateNormal];
}

#pragma mark 结束连发
- (void)finishContinue
{
    _sendBtn.hidden = NO;
    _continueContainerView.hidden = YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[QMUIButton class]]) {
        return NO;
    }
    return YES;

}

#pragma mark 点击充值
- (void)clickRechargeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(showRechargeView:)])
    {
        [_delegate showRechargeView:self];
    }
}

#pragma mark 设置当前钻石数量
- (void)setDiamondsLabelTxt:(NSString *)txt
{
    
    _diamondsLabel.text = txt;
    CGSize titleSize = [txt boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    _diamondsLabel.frame = CGRectMake(_diamondsLabel.frame.origin.x, _diamondsLabel.frame.origin.y, titleSize.width, _diamondsLabel.frame.size.height);
    _rechargeBtn.left = _diamondsLabel.right + kDefaultMargin;
    _rechargeImgView.frame = CGRectMake(_diamondsLabel.left + kDefaultMargin,_rechargeImgView.frame.origin.y, _rechargeImgView.frame.size.width, _rechargeImgView.frame.size.height);
    _rechargeContainerView.frame = CGRectMake(CGRectGetMinX(_rechargeContainerView.frame), CGRectGetMinY(_rechargeContainerView.frame), kScreenW, CGRectGetHeight(_rechargeContainerView.frame));
}

#pragma mark
- (void)setGiftView:(NSMutableArray *)giftMArray
{
    [_itemArray removeAllObjects];
    [_bottomViewArray removeAllObjects];
    
    NSMutableArray *tempOutArray = [NSMutableArray array];
    for (NSInteger i = 0; i < giftMArray.count; i++) {
        GiftModel *outModel = giftMArray[i];
        NSMutableArray *tempInArray = [NSMutableArray array];
        for (NSInteger j = 0; j < outModel.list.count; j++) {
            NSDictionary *dict = outModel.list[j];
            GiftModel *inModel = [GiftModel mj_objectWithKeyValues:dict];
            [tempInArray addObject:inModel];
        }
        [tempOutArray addObject:tempInArray];
    }
    _giftMArray = tempOutArray;
    [self createGiftSubView:giftMArray];
    
}

-(void)reloadBag
{
    [[GiftListManager sharedInstance] reloadGiftList];
    
    [GiftListManager sharedInstance].relodComplete = ^{
     
        [self removeAllSubviews];
        [self initUI];
        NSMutableArray *list = [GiftListManager sharedInstance].giftMArray;
        
        NSMutableArray *giftMArray = [NSMutableArray array];
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *key in list)
            {
                GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:key];
                [giftMArray addObject:giftModel];
            }
        }
        
        BOOL ret = NO;
        for (GiftModel *giftModel in giftMArray) {
            if (giftModel.list.count > 4) {
                ret = YES;
                break;
            }
        }
        
        WeakSelf

        [self setGiftView:giftMArray];
        
        [self changeMoney];
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) animated:NO];
        [self.topView resetIndexs:1];

    };
}
- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];

    
    [[GiftListManager sharedInstance] reloadGiftList];
    
    [self reequestUserList];
    
    
    if(self.isChat)
    {
        
        if(hidden == NO)
        {
            [self removeAllSubviews];
            [self initUI];
            
            if(_isHost && !self.isVoice)
            {
                self.bottomContainerView.hidden = YES;
            }
            
            NSMutableArray *list = [GiftListManager sharedInstance].giftMArray;
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setObject:@"app" forKey:@"ctl"];
            [mDict setObject:@"prop" forKey:@"act"];
            [mDict setObject:@"1" forKey:@"type"];
            
            FWWeakify(self)
            [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                
                FWStrongify(self)
                
                if ([responseJson toInt:@"status"] == 1)
                {

                    NSArray *list = responseJson[@"list"];
                    
                    NSMutableArray *giftMArray = [NSMutableArray array];
                    if (list && [list isKindOfClass:[NSArray class]])
                    {
                        for (NSDictionary *key in list)
                        {
                            GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:key];
                            [giftMArray addObject:giftModel];
                        }
                    }
                    
                    BOOL ret = NO;
                    for (GiftModel *giftModel in giftMArray) {
                        if (giftModel.list.count > 4) {
                            ret = YES;
                            break;
                        }
                    }
                    
                    WeakSelf

                    [self setGiftView:giftMArray];
                    
                    [self changeMoney];
                    
                }
                
            } FailureBlock:^(NSError *error) {
                
            }];
            
            

        }
    }
    else
    {
        [GiftListManager sharedInstance].relodComplete = ^{
            if(hidden == NO)
            {
                [self removeAllSubviews];
                [self initUI];
                
                if(_isHost && !self.isVoice)
                {
                    self.bottomContainerView.hidden = YES;
                }
                
                NSMutableArray *list = [GiftListManager sharedInstance].giftMArray;
                
                NSMutableArray *giftMArray = [NSMutableArray array];
                if (list && [list isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary *key in list)
                    {
                        GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:key];
                        [giftMArray addObject:giftModel];
                    }
                }
                
                BOOL ret = NO;
                for (GiftModel *giftModel in giftMArray) {
                    if (giftModel.list.count > 4) {
                        ret = YES;
                        break;
                    }
                }
                
                WeakSelf

                [self setGiftView:giftMArray];
                
                [self changeMoney];
            }
        };
    }
    

}

- (void)changeMoney
{
    FWWeakify(self)
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        FWStrongify(self)
        long currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        [self setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)currentDiamonds]];
        
    }];
}

#pragma mark 创建每一项

- (void)handleNunberEvent:(QMUIFillButton *)sender {
    
    for (int i=0; i<_bottomNumberView.subviews.count; i++) {
        if([_bottomNumberView.subviews[i] isKindOfClass:[QMUIFillButton class]])
        {
            QMUIButton *btn = _bottomNumberView.subviews[i];
            btn.selected = NO;
        }
    }
    
    self.numberModel = [sender qmui_getBoundObjectForKey:@"model"];

    
    sender.selected = YES;
}


-(UIView *)bottomNumberView
{
    if(_bottomNumberView == nil)
    {
        _bottomNumberView = [[UIView alloc] init];
        _bottomNumberView.frame = CGRectMake(0, 0, self.width, 40);
        int btnWidth = 45;
//        _bottomNumberView.hidden = YES;

        int y = 5;
        int x = 45;
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"number";
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = kWhiteColor;
        [_bottomNumberView addSubview:lab];
        lab.frame = CGRectMake(5, 5, 60, 40);
        
        NSMutableArray *itemArr = [NSMutableArray array];
        for (int i =0 ; i<[GlobalVariables sharedInstance].giftQuantityModelList.count; i++) {
            GiftQuantityModel *model = [GlobalVariables sharedInstance].giftQuantityModelList[i];
            __weak __typeof(self)weakSelf = self;
            QMUIFillButton *btn = [[QMUIFillButton alloc] init];
            if(i == 0)
            {
                btn.selected = YES;
            }
            btn.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.1];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setTitle:model.num forState:UIControlStateNormal];
            int xx = x + i*(btnWidth + 10);
            btn.frame = CGRectMake(xx, y, btnWidth, 32);
            [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [btn qmui_bindObject:model forKey:@"model"];
            [btn setTitleColor:[UIColor colorWithHexString:@"#C28CF8"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(handleNunberEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomNumberView addSubview:btn];
        }
        
        return _bottomNumberView;
    }
    else
    {
        return _bottomNumberView;
    }
    //
    //    NSMutableArray *itemArr = [NSMutableArray array];
    //    for (int i =0 ; i<[GlobalVariables sharedInstance].giftQuantityModelList.count; i++) {
    //        GiftQuantityModel *model = [GlobalVariables sharedInstance].giftQuantityModelList[i];
    //        __weak __typeof(self)weakSelf = self;
    //        QMUIPopupMenuButtonItem *qmuiItem = [QMUIPopupMenuButtonItem itemWithImage:nil title:model.title handler:^(QMUIPopupMenuButtonItem *aItem) {
    //            weakSelf.numberModel = [GlobalVariables sharedInstance].giftQuantityModelList[i];
    //            [weakSelf resetNumber];
    //            [self.popView hideWithAnimated:NO];
    //        }];
    //
    //        [qmuiItem qmui_bindObject:model forKey:@"model"];
    //
    //        [itemArr addObject:qmuiItem];
    //    }
}


- (void)createGiftSubView:(NSMutableArray *)arrayList
{
    //创建标题数组
    NSMutableArray *titleArray = [NSMutableArray array];
    for (GiftModel *model in arrayList) {
        [titleArray addObject:model.name];
    }
    //创建礼物分类
    int height = kRealValue(53);
    if(self.isVoice)
    {
        height = kRealValue(53) + 44;
    }
    GiftGroupView *groupView = [[GiftGroupView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height) TitleArray:titleArray];
    [groupView setClickGiftGroupBtnBlock:^(NSInteger index) {
        [self.scrollView scrollRectToVisible:CGRectMake(index*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) animated:YES];
    }];

    
//    groupView.height += 44;
//    self.y -= 44;

    [self addSubview:groupView];
    
    
    if(self.isVoice == YES)
    {
        [groupView addSubview:self.peopleCollectionView];
        self.peopleCollectionView.backgroundColor = kClearColor;
        UILabel *lab = [[UILabel alloc] init];
        lab.text = ASLocalizedString(@"送给");
        lab.textColor = kWhiteColor;
        lab.font = [UIFont systemFontOfSize:14];
        [groupView addSubview:lab];

        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(groupView).offset(5);
            make.centerY.equalTo(self.peopleCollectionView);
            
        }];
        [self.peopleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_right).offset(5);
            make.right.equalTo(groupView).offset(-5);
            make.height.equalTo(@44);
//            make.width.equalTo(groupView);
            make.top.equalTo(@(height - 44));
        }];
    }
    
    self.topView = groupView;
    
    [self.topView addSubview:_diamondsImgView];
    [self.topView addSubview:_diamondsLabel];
    [self.topView addSubview:_rechargeImgView];
    [self.topView addSubview:_rechargeBtn];
    
    
//
//    NSMutableArray *itemArr = [NSMutableArray array];
//    for (int i =0 ; i<[GlobalVariables sharedInstance].giftQuantityModelList.count; i++) {
//        GiftQuantityModel *model = [GlobalVariables sharedInstance].giftQuantityModelList[i];
//        __weak __typeof(self)weakSelf = self;
//        QMUIPopupMenuButtonItem *qmuiItem = [QMUIPopupMenuButtonItem itemWithImage:nil title:model.title handler:^(QMUIPopupMenuButtonItem *aItem) {
//            weakSelf.numberModel = [GlobalVariables sharedInstance].giftQuantityModelList[i];
//            [weakSelf resetNumber];
//            [self.popView hideWithAnimated:NO];
//        }];
//
//        [qmuiItem qmui_bindObject:model forKey:@"model"];
//
//        [itemArr addObject:qmuiItem];
//    }
    

    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.diamondsImgView);
        make.right.equalTo(self.topView).priorityHigh();
        make.width.equalTo(@80).priorityHigh();;
        make.height.equalTo(@22);
        make.top.equalTo(self.topView).offset(5);
    }];

    [_diamondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-5);
        make.top.equalTo(self.rechargeBtn.mas_bottom).offset(5);
    }];

    [_diamondsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@18);
        make.right.equalTo(_diamondsLabel.mas_left).offset(-5);
        make.centerY.equalTo(_diamondsLabel);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, groupView.bottom, self.frame.size.width, self.frame.size.height-kSendGiftContrainerHeight - groupView.height)];
    scrollView.contentSize = CGSizeMake(arrayList.count * self.width, scrollView.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    for (NSInteger index = 0; index < arrayList.count; index++) {
        //bottomViewArray重置
        [_bottomViewArray removeAllObjects];
        NSMutableArray *itemSubArray = [NSMutableArray array];
        //得到第一层
        GiftModel *model = arrayList[index];
        //得到第一个分类下的礼物集合
        NSArray *newArrayList = model.list;
        //计算出需要几个轮播图的ImageView
        NSUInteger num = [newArrayList count]/8;
        //有余数加1
        if ([newArrayList count]%8)
        {
            num ++;
        }
        //一共需要创建多少轮播图的子View
        int i= 0;
        for (int k=0; k<num; k++)
        {
            CGFloat btn_x_2 = -1;
            CGFloat btn_y_2 = -1;
            //底部视图
            UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.scrollView.height)];
            bottomView.backgroundColor = [UIColor clearColor];
            //礼物容器视图
            UIView *giftListContrainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height-kDefaultMargin*4)];
            
            giftListContrainerView.backgroundColor = [UIColor clearColor];
            giftListContrainerView.clipsToBounds = YES;
            [bottomView addSubview:giftListContrainerView];
            
            //            if ([newArrayList count]>4)
            //            {
            //                _giftVerticalNum = 2;
            //            }
            //            else if([newArrayList count]>0 && [newArrayList count]<5)
            //            {
            //                _giftVerticalNum = 1;
            //            }
            //纵向个数为2
            _giftVerticalNum = 2;
            
            NSUInteger counttag = 0;
            if (num == 1)
            {
                //如果只有1个礼物,计数就是礼物的数量
                counttag = [newArrayList count];
            }
            else if (k<num-1)
            {
                counttag = k*8+8;
            }
            else
            {
                counttag = [newArrayList count];
            }
            
            for(; i < counttag; i ++)
            {
                NSDictionary *dict = [newArrayList objectAtIndex:i];
                GiftModel * giftModel = [GiftModel mj_objectWithKeyValues:dict];
                GiftSubView *giftSubView = [[GiftSubView alloc]initWithFrame:CGRectMake(btn_x_2, btn_y_2, (giftListContrainerView.frame.size.width+2)/kGiftHorizontalNum, (giftListContrainerView.frame.size.height+2)/_giftVerticalNum)];

                giftSubView.luckBtn.hidden = YES;
                /*if(giftModel.is_bag == 1)
                {
                    giftSubView.labNumber.height = 15;
                    giftSubView.labNumber.hidden = NO;
                    giftSubView.labNumber.text = [NSString stringWithFormat:@"x%@",giftModel.giftnum];
                    giftSubView.diamondsLabel.y += 15;
                    giftSubView.diamondsImgView.y += 15;
                }
                else
                {
                    giftSubView.labNumber.height = 0;
                    giftSubView.labNumber.hidden = YES;

                }*/
                if (giftModel.is_lucky == 1 || giftModel.is_animated == 1) {
                    giftSubView.luckBtn.hidden = NO;
                }

                [giftSubView.luckBtn setTitle:giftModel.is_animated == 1 ? ASLocalizedString(@"动效"): ASLocalizedString(@"幸运") forState:UIControlStateNormal];
                
        
                
                [giftSubView.luckBtn setBackgroundImage:[UIImage imageNamed:giftModel.is_animated == 1 ? @"bogo_gift_list_lucky_gif": @"bogo_gift_list_lucky"] forState:UIControlStateNormal];
                
                /*if(giftModel.max_silver_coin > 0)
                {
                    [giftSubView.luckBtn setTitle:ASLocalizedString(@"银币") forState:UIControlStateNormal];
                    giftSubView.luckBtn.hidden = NO;

                    [giftSubView.luckBtn setBackgroundImage:[UIImage imageNamed:@"bogo_gift_list_lucky"] forState:UIControlStateNormal];
//                    giftSubView.diamondsImgView.image = [UIImage imageNamed:@"6银币"];
                }*/
                
                
                giftSubView.delegate = self;
                giftSubView.tag = i;
                giftSubView.index_x = index;
                giftSubView.index_y = i;
                giftSubView.txtLabel.text = giftModel.name;
                giftSubView.diamondsLabel.text = [NSString stringWithFormat:@"%ld",(long)giftModel.diamonds];
                [giftSubView.imgView sd_setImageWithURL:[NSURL URLWithString:giftModel.icon] placeholderImage:kDefaultPreloadImgSquare];
                [giftSubView resetDiamondsFrame];
                
                UIButton *colorCoin = [[UIButton alloc] init];
                [colorCoin setTitle:ASLocalizedString(@"彩钻")forState:UIControlStateNormal];
                colorCoin.frame = CGRectMake(3, 3, 20, 15);
                colorCoin.titleLabel.font = [UIFont systemFontOfSize:8];
                [colorCoin setTitleColor:kWhiteColor forState:UIControlStateNormal];
                colorCoin.layer.cornerRadius = 3;
                colorCoin.layer.borderColor = kWhiteColor.CGColor;
                colorCoin.layer.masksToBounds = YES;
                colorCoin.layer.borderWidth = 1;
                [giftSubView addSubview:colorCoin];
                if([giftModel.type isEqualToString:@"1"])
                {
                    colorCoin.hidden = NO;
                }
                else
                {
                    colorCoin.hidden = YES;
                }
                
                colorCoin.hidden = YES;
                if (giftModel.is_much == 1)
                {
                    [giftSubView.continueImgView setImage:[UIImage imageNamed:@"lr_gift_list_continue"]];
                }
                else
                {
                    [giftSubView.continueImgView setImage:[UIImage imageNamed:@""]];
                }
                
                [giftListContrainerView addSubview:giftSubView];
                [itemSubArray addObject:giftSubView];
                
                //计算下一个按钮的位置
                if (i < [newArrayList count]-1)
                { //判断是否有下一个按钮
                    //列
                    if (giftSubView.frame.origin.x + giftSubView.frame.size.width >= self.frame.size.width)
                    {
                        //换行
                        btn_x_2 = -1;
                        btn_y_2 = giftSubView.frame.origin.y + giftSubView.frame.size.height;
                    }
                    else
                    {
                        btn_x_2 = giftSubView.frame.origin.x + giftSubView.frame.size.width;
                    }
                }
            }
            
            //            if (num == 1)
            //            {
            //                [self addSubview:bottomView];
            //            }
            //            else
            //            {
            //                [_bottomViewArray addObject:bottomView];
            //            }
            [_bottomViewArray addObject:bottomView];
        }
        [_itemArray addObject:itemSubArray];
        if ([_bottomViewArray count]>0)
        {
//            int offset = 0;
//            if(self.isVoice)
//            {
//                offset = 44;
//            }
            
//            SDCycleScrollView2 *cycleScrollView = [SDCycleScrollView2 cycleScrollViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kSendGiftContrainerHeight - 30 - offset) imagesGroup:_bottomViewArray];

            SDCycleScrollView2 *cycleScrollView = [SDCycleScrollView2 cycleScrollViewWithFrame:CGRectMake(0, 0, self.frame.size.width, scrollView.height) imagesGroup:_bottomViewArray];

         
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.pageControlDotSize = CGSizeMake(kAdvsPageWidth, kAdvsPageWidth);
            cycleScrollView.autoScrollTimeInterval = 0;
            cycleScrollView.dotColor = kWhiteColor;
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.left = index*self.scrollView.width;
            [scrollView addSubview:cycleScrollView];
            NSLog(@"");
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    RoomUserInfo *info = self.newUserArray[indexPath.item];
   
    for (int i=0; i<self.newUserArray.count; i++) {
        ((RoomUserInfo *)(self.newUserArray[i])).selected = NO;
    }
    info.selected = YES;
    
    [GlobalVariables sharedInstance].giftSelecUserId = info.user_id;
    [collectionView reloadData];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating :%f",scrollView.contentOffset.x);
    NSInteger index = scrollView.contentOffset.x/self.scrollView.width;
    [self.topView resetIndexs:index];
//    .indexs = index;
//    [self.topView setIndex:index];
}

#pragma mark GiftSubViewDelegate
- (void)cateBtn:(int)indexTag index_x:(NSInteger)index_x index_y:(NSInteger)index_y
{
    NSLog(@"indexTag:%ld index_x:%ld index_y:%ld",indexTag,index_x,index_y);
    GiftModel *giftModel = _giftMArray[index_x][index_y];
    
    for (int i=0; i<[_itemArray count]; i++)
    {
        NSArray *tempArray = _itemArray[i];
        for (NSInteger j = 0; j < tempArray.count; j++) {
            UIView *view = [tempArray objectAtIndex:j];
            if ([view isKindOfClass:[GiftSubView class]])
            {
                GiftSubView *giftSubView = (GiftSubView *)view;
                
                if (giftSubView.index_x == index_x && giftSubView.index_y == index_y)
                {
                    if (giftModel.isSelected)
                    {
                        [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
                        giftModel.isSelected = NO;
                        giftSubView.bottomBtn.layer.borderWidth = 0.5;
                        giftSubView.bottomBtn.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.6].CGColor;
                        self.selectGiftView = nil;
                    }
                    else
                    {
                        [_sendBtn setBackgroundColor:kBlackColor];
                        giftModel.isSelected = YES;
                        giftSubView.bottomBtn.layer.borderWidth = 2;
                        giftSubView.bottomBtn.layer.borderColor = [UIColor colorWithHexString:@"#C28CF8"].CGColor;
                        giftSubView.bottomBtn.layer.cornerRadius = 5;
                        self.selectGiftView = giftSubView;

                    }
                }
                else
                {
                    GiftModel *giftModel2 = _giftMArray[giftSubView.index_x][giftSubView.index_y];
                    if (giftModel2.isSelected)
                    {
                        giftModel2.isSelected = NO;
                        giftSubView.bottomBtn.layer.borderWidth = 0.5;
                        giftSubView.bottomBtn.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.6].CGColor;
                        self.selectGiftView = nil;

                    }
                }
            }
        }
    }
    if (_upSelectedIndex != indexTag) {
        _sendedTime = 0;
    }
    _upSelectedIndex = indexTag;
}

- (void)senBtnEnabled:(UIButton *)btn
{
    if (btn == _sendBtn)
    {
        _sendBtn.userInteractionEnabled = YES;
    }
    else if(btn == _continueBtn)
    {
        _continueBtn.userInteractionEnabled = YES;
    }
}

- (void)setNumAction:(id)sender{
    [self.popView showWithAnimated:YES];
}



- (QMUIPopupMenuView *)popView{
    if (!_popView) {
        _popView = [[QMUIPopupMenuView alloc] init];
        _popView.borderWidth = 0;
        _popView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _popView.shouldShowItemSeparator = YES;
        _popView.backgroundColor = [UIColor qmui_colorWithHexString:@"#7F000000"];
        _popView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            [aItem.button setTitleColor:[UIColor qmui_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [aItem.button setBackgroundColor:[UIColor qmui_colorWithHexString:@"#7F000000"]];
            aItem.button.titleLabel.font = [UIFont systemFontOfSize:14];
        };
        
        NSMutableArray *itemArr = [NSMutableArray array];
        for (int i =0 ; i<[GlobalVariables sharedInstance].giftQuantityModelList.count; i++) {
            GiftQuantityModel *model = [GlobalVariables sharedInstance].giftQuantityModelList[i];
            __weak __typeof(self)weakSelf = self;
            QMUIPopupMenuButtonItem *qmuiItem = [QMUIPopupMenuButtonItem itemWithImage:nil title:model.title handler:^(QMUIPopupMenuButtonItem *aItem) {
                weakSelf.numberModel = [GlobalVariables sharedInstance].giftQuantityModelList[i];
                [weakSelf resetNumber];
                [self.popView hideWithAnimated:NO];
            }];
            
            [qmuiItem qmui_bindObject:model forKey:@"model"];
            
            [itemArr addObject:qmuiItem];
        }
        
        _popView.items = itemArr;
        _popView.sourceView = self.numberBtn;// 相对于 button4 布局
    }
    return _popView;
}

#pragma mark 点击发送按钮
- (void)senGiftAction:(id)sender
{
    
    
    
    
    UIButton *sendBtn = (UIButton *)sender;
    if (sendBtn == _sendBtn)
    {
//        _sendBtn.userInteractionEnabled = NO;
    }
    else if(sendBtn == _continueBtn)
    {
//        _continueBtn.userInteractionEnabled = NO;
    }
//    [self performSelector:@selector(senBtnEnabled:) withObject:sendBtn afterDelay:0.3];
    
    _selectedGiftTime = [_decTimeCLabel.text integerValue];
    if (_selectedGiftTime == 0)
    {
        _sendedTime = 0;
    }
    
    [self bringSubviewToFront:_continueContainerView];
    
    BOOL haveSelected = NO;
    
    for (int i=0; i<[_itemArray count]; i++)
    {
        NSArray *tempArray = _itemArray[i];
        for (NSInteger j = 0; j < tempArray.count; j ++) {
            GiftModel *giftModel = _giftMArray[i][j];
            
            if (giftModel.isSelected)
            {
                UserModel *model = [GlobalVariables sharedInstance].userModel;
                
//                [GlobalVariables sharedInstance].u
//
                NSLog(@"GlobalVariables sharedInstance].is_guart%@",[GlobalVariables sharedInstance].is_guartian);
                /*if ([giftModel.type isEqualToString:@"2"] &&
                    [GlobalVariables sharedInstance].is_guartian.intValue != 1) {

                    [FanweMessage alertHUD:@"守护专属～您尚未开通守护"];

                    return;
                }*/
                
                if ([giftModel.type isEqualToString:@"3"] && model.is_vip.intValue == 0) {
                    
                    [self showVipRecharge];
                    
                    return;
                }
                
                if ([giftModel.type isEqualToString:@"4"] && model.noble_vip_type.intValue == 0) {
                    
                    [self showNobleNobleVIP];
                    
                    return;
                }
                
//                if(!giftModel.is_bag)
//                {
                    if ((([[IMAPlatform sharedInstance].host getDiamonds] < giftModel.diamonds) && ![giftModel.type  isEqualToString:@"1"]) &&  (([[IMAPlatform sharedInstance].host.colorful intValue] < giftModel.diamonds) && [giftModel.type  isEqualToString:@"1"]))
                    {
                        [FanweMessage alert:[NSString stringWithFormat:ASLocalizedString(@"当前%@不足"),self.BuguLive.appModel.diamond_name]];
                        [[IMAPlatform sharedInstance].host getMyInfo:nil];
                        return;
                    }
//                }
                
               
                
                //如果是贵族专属礼物
//                if ([giftModel.type isEqualToString:@"2"]) {
//                    //需要判断当前是不是有贵族礼物特权
//                    if (self.userPageModel.noble_gift.integerValue != 1) {
//                        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"您当前没有贵族礼物特权,无法发送贵族专属礼物")];
//                        return;
//                    }
//                }
                
                haveSelected = YES;
                if (_delegate && [_delegate respondsToSelector:@selector(senGift:AndGiftModel:)])
                {
                    if (_currentGiftModel == giftModel)
                    {
                        // 判断这个礼物是否可以连发
                        if (giftModel.is_much && _selectedGiftTime>0)
                        {
                            giftModel.is_plus = 1;
                        }
                        else
                        {
                            giftModel.is_plus = 0;
                        }
                    }
                    else
                    {
                        giftModel.is_plus = 0;
                        _currentGiftModel = giftModel;
                    }
                    if (giftModel.is_much)
                    {
                        _sendBtn.hidden = YES;
                        _continueContainerView.hidden = NO;
                        [_decTimeCLabel countFrom:(NSInteger)kGiftViewSendedDescTime*10 to:0 withDuration:(NSInteger)kGiftViewSendedDescTime];
                        __weak GiftView* blockSelf = self;
                        _decTimeCLabel.completionBlock = ^{
                            [blockSelf finishContinue];
                        };
                        _sendedTime ++;
                        _sendedTimeLabel.text = [NSString stringWithFormat:@"X%ld",(long)_sendedTime];
                    }
                    else
                    {
                        _sendBtn.hidden = NO;
                        _continueContainerView.hidden = YES;
                    }
                    
                    giftModel.num = self.numberModel.num;
                    [_delegate senGift:self AndGiftModel:giftModel];
                }
            }
        }
    }
    if (!haveSelected)
    {
        [FanweMessage alert:ASLocalizedString(@"还没选择礼物哦")];
    }
}

-(void)showVipRecharge{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"您当前未开通VIP，需要开通后才能发送此礼物")preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.shop_url;
        
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
//                        tmpController.navTitleStr = ASLocalizedString(@"座驾");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }];
    
    [alertController addAction:actionCacel];
    [alertController addAction:actionConfirm];
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:alertController animated:YES completion:nil];
}

//贵族
-(void)showNobleNobleVIP{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"您当前未开通贵族，需要开通后才能发送此礼物")preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BogoNobleViewController *vc = [BogoNobleViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }];
    
    [alertController addAction:actionCacel];
    [alertController addAction:actionConfirm];
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:alertController animated:YES completion:nil];
}

- (UICollectionView *)peopleCollectionView{
    if (!_peopleCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30,30);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _peopleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _peopleCollectionView.delegate = self;
        _peopleCollectionView.dataSource = self;
        _peopleCollectionView.pagingEnabled = YES;
        _peopleCollectionView.showsHorizontalScrollIndicator = NO;
        [_peopleCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveGiftViewPeopleCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([BogoLiveGiftViewPeopleCell class])];
        _peopleCollectionView.backgroundColor = kClearColor;
    }
    return _peopleCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.newUserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    BogoLiveGiftViewPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoLiveGiftViewPeopleCell class]) forIndexPath:indexPath];
    [cell setDataArray:self.newUserArray];
    RoomUserInfo *info = self.newUserArray[indexPath.item];
//    if (info.user_id) {
        [cell setUser:info];
//    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(30, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
   
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 0);
}

- (NSMutableArray *)newUserArray{
    if (!_newUserArray) {
        _newUserArray = [NSMutableArray array];
    }
    return _newUserArray;
}


@end

