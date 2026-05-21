//
//  UserView.m
//  BuguLive
//
//  Created by 志刚杨 on 2023/1/3.
//  Copyright © 2023 xfg. All rights reserved.
//

#import "UserView.h"

@interface UserView ()


@end

@implementation UserView
{
    YYAnimatedImageView *yyimg;
}
+(instancetype)getView
{
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}
-(void)frontView
{
    [self bringSubviewToFront:self.userName];
    [self bringSubviewToFront:self.giftButton];
    [self bringSubviewToFront:self.numberLab];
}
#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)awakeFromNib {
    [super awakeFromNib];
     //设置view
     [self setupView];
    
     //请求数据
     [self requestData];
     
     //设置通知
     [self addNotificationObserver];
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
//    [self setSelect:YES];
    
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
   
    self.muteVideoView.userInteractionEnabled = YES;
    
    yyimg = [[YYAnimatedImageView alloc] init];
    yyimg.image = [YYImage imageNamed:@"mic_pppp.webp"];
    self.breathView.hidden = NO;
    [self.breathView addSubview:yyimg];
    [yyimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.breathView);
        make.size.equalTo(self.breathView);
    }];
    
    
}

- (void)setUid:(NSString *)uid
{
    _uid = uid;
    if([_uid isEqualToString:[IMAPlatform sharedInstance].host.userId])
    {
        self.videoBtn.hidden = NO;
        self.voiceBtn.hidden = NO;
    }
    else
    {
        self.videoBtn.hidden = YES;
        self.voiceBtn.hidden = YES;
    }
    
    [self requestData];
}
- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"点击了userview");
    if([self.delegate respondsToSelector:@selector(clickUserView:)])
    {
        [self.delegate clickUserView:self];
    }
}
- (void)setSelect:(BOOL)select
{
    _select = select;
    if(select)
    {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithHex:0x891DC1].CGColor;
    }
    else
    {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

#pragma mark - View
- (void)setupView {
    
}

#pragma mark - Network
- (void)requestData {
    //之前代码太过臃肿，这里为了解耦，独立请求数据
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"userinfo" forKey:@"act"];
    [parmDict setObject:SafeStr(self.uid) forKey:@"to_user_id"];

    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             UserModel *model = [UserModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];

             [self.avatar sd_setImageWithURL:[NSURL URLWithString:SafeStr(model.head_image)] placeholderImage:kDefaultPreloadHeadImg];
             
             self.avatar.layer.borderColor = [UIColor colorWithHexString:@"#F95B4D"].CGColor;
             self.avatar.layer.borderWidth = 0.5;
         }else
         {
         }
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         
     }];
}

#pragma mark- Delegate
#pragma mark UITableDatasource & UITableviewDelegate


#pragma mark - Private


#pragma mark - Event


#pragma mark - Public


#pragma mark - NSNotificationCenter
- (void)addNotificationObserver {
    
}

- (void)removeNotificationObserver {
    
}

#pragma mark - Setter


#pragma mark - Getter

- (IBAction)clickVideo:(id)sender {
    self.videoBtn.selected = !self.videoBtn.selected;
    self.muteVideoView.hidden = !self.muteVideoView.hidden;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickVideoBtn:)])
    {
        [self.delegate clickVideoBtn:self];
    }
}
- (IBAction)clickVoice:(id)sender {
    self.voiceBtn.selected = !self.voiceBtn.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickVoiceBtn:)])
    {
        [self.delegate clickVoiceBtn:self];
    }
}

- (void)setTotalVolume:(int)totalVolume
{
    _totalVolume = totalVolume;
    if(totalVolume > 5)
    {
        self.breathView.hidden = NO;
    }
    else
    {
        self.breathView.hidden = YES;
    }
}

- (IBAction)closeVideo:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickCloseBtn:)])
    {
        [self.delegate clickCloseBtn:self];
    }
}

@end
