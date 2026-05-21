//
//  HMVideoControlView.m
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import "HMVideoControlView.h"
#import "HMVideoSliderView.h"
#import "PersonCenterModel.h"
#import "CommentModel.h"
#import "BogoShopKit.h"

// 判断是否是iPhone X系列
#define IS_iPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)
#define ADAPTATIONRATIO     kScreenW / 750.0f
#define TABBAR_HEIGHT       (IS_iPhoneX ? 83.0f : 49.0f)

@implementation HMVideoItemButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    self.imageView.frame = CGRectMake((width - imgH) / 2, 0, imgW, imgH);
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, height - titleH + 5, titleW, titleH);
}

@end

@interface HMVideoControlView ()

@property (nonatomic, strong) UIImageView           *iconView;
@property (nonatomic, strong) HMVideoItemButton   *praiseBtn;
@property (nonatomic, strong) HMVideoItemButton   *shareBtn;
@property (nonatomic, strong) HMVideoItemButton   *oneOnOneBtn;
@property (nonatomic, strong) HMVideoItemButton   *giftBtn;

@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *contentLabel;
@property (nonatomic, strong) HMVideoSliderView          *sliderView;

@property (nonatomic, strong) UIActivityIndicatorView   *loadingView;
@property (nonatomic, strong) UIButton                  *playBtn;

@property (nonatomic, assign) int currentPage; //当前页数
@property (nonatomic, assign) int has_next; //是否还有下一页1代表有
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *shareDict;
@property (nonatomic, strong) PersonCenterModel *detailModel;
@property (nonatomic, strong) UIButton *focusBtn;

@property(nonatomic, strong) BogoVideoGoodControl *goodControl;

@end

@implementation HMVideoControlView

- (instancetype)initWithIsPushed:(BOOL)isPushed {
    if (self = [super init]) {
        self.isPushed = isPushed;
        [self addSubview:self.coverImgView];
        [self addSubview:self.iconView];
        [self addSubview:self.praiseBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.oneOnOneBtn];
        if (![GlobalVariables sharedInstance].userModel.is_open_young.integerValue) {
            [self addSubview:self.giftBtn];
        }
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.sliderView];
        
        [self addSubview:self.loadingView];
        [self addSubview:self.playBtn];
        [self addSubview:self.commentButton];
        
        
        [self addSubview:self.moreBtn];
        
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(kStatusBarHeight);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(kRealValue(30));
        }];
        
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat bottomM = TABBAR_HEIGHT;
        
        if ([GlobalVariables sharedInstance].appModel.short_video.integerValue && !self.isPushed) {
            bottomM = TABBAR_HEIGHT;
        }
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-bottomM);
            make.height.mas_equalTo(ADAPTATIONRATIO * 1.0f);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ADAPTATIONRATIO * 30.0f);
            make.bottom.equalTo(self.sliderView).offset(-ADAPTATIONRATIO * 30.0f);
            make.width.mas_equalTo(ADAPTATIONRATIO * 504.0f);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.bottom.equalTo(self.contentLabel.mas_top).offset(-ADAPTATIONRATIO * 20.0f);
        }];
        
        [self.oneOnOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 15.0f);
            make.bottom.equalTo(self.contentLabel.mas_bottom).offset(-ADAPTATIONRATIO * 10.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        if (![GlobalVariables sharedInstance].userModel.is_open_young.integerValue) {
            [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-ADAPTATIONRATIO * 25.0f);
                make.bottom.equalTo(self.nameLabel.mas_top).offset(-ADAPTATIONRATIO * 50.0f);
    //            make.centerX.mas_equalTo()
                make.height.mas_equalTo(ADAPTATIONRATIO * 55.0f);
            }];
            
            [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 30.0f);
                make.centerX.mas_equalTo(self.giftBtn.mas_centerX);
                make.bottom.equalTo(self.giftBtn.mas_top).offset(-ADAPTATIONRATIO * 40.0f);
                make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
            }];
        }else{
            [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 30.0f);
                make.right.equalTo(self).offset(-ADAPTATIONRATIO * 25.0f);
                make.bottom.equalTo(self.nameLabel.mas_top).offset(-ADAPTATIONRATIO * 90.0f);
                make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
            }];
        }
        
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-ADAPTATIONRATIO * 45.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.commentBtn.mas_top).offset(-ADAPTATIONRATIO * 45.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.praiseBtn.mas_top).offset(-ADAPTATIONRATIO * 70.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
        }];
        
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.sliderView.mas_bottom).offset(10);
            make.right.equalTo(self);
        }];
        
        [self addSubview:self.focusBtn];
        [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconView);
            make.centerY.equalTo(self.iconView.mas_bottom);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlViewDidClick:)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFocusStatus:) name:@"liveIsShowFollow" object:nil];
        
    }
    return self;
}

- (void)setModel:(SmallVideoListModel *)model {

    _model = model;
    
    if ([model.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]]) {
        self.giftBtn.hidden = YES;
    }else{
        self.giftBtn.hidden = NO;
    }
    
    self.sliderView.value = 0;
    //
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.photo_image] placeholderImage:[UIImage imageNamed:@"placeholderimg"]];
    //
    self.nameLabel.text = [NSString stringWithFormat:@"@%@", model.nick_name];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"placeholderimg"]];
    //
    self.contentLabel.text = model.content;
    //
    [self.praiseBtn setTitle:model.digg_count forState:UIControlStateNormal];
    [self.commentBtn setTitle:model.comment_count forState:UIControlStateNormal];
    //    [self.shareBtn setTitle:model.share_num forState:UIControlStateNormal];
    
    if (![self.model.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]){
        [self.focusBtn setHidden:[model.has_focus isEqualToString:@"1"]];
        self.moreBtn.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
        self.focusBtn.hidden = NO;
    }
    [self loadNetDataWithPage:1];
    if (model.weibo_id.integerValue) {
        [self addPlayNumWithWeiBoId:model.weibo_id];
    }else{
        [self addPlayNumWithWeiBoId:model.id];
    }
    if (![GlobalVariables sharedInstance].userModel.is_open_young.integerValue) {

        if (StrValid(model.shop_id) && model.shop_title.length) {
            [self addSubview:self.goodControl];
            [self.goodControl.titleLabel setText:SafeStr(model.shop_title)];
            [self.goodControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.height.mas_equalTo(@30);
                make.bottom.equalTo(self.nameLabel.mas_top).offset(-30);
                make.right.lessThanOrEqualTo(self).offset(-60);
            }];
        }else{
            [self.goodControl removeFromSuperview];
        }
    }
    
}

- (void)changeFocusStatus:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    NSString *isShowFollow = dict[@"isShowFollow"];
    NSString *userId = dict[@"userId"];
    if ([userId isEqualToString:self.model.user_id]) {
        self.focusBtn.hidden = ![isShowFollow isEqualToString:@"1"];
    }
}

#pragma mark 加载详情数据

-(void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"weibo" forKey:@"ctl"];
    [MDict setObject:@"index" forKey:@"act"];
    [MDict setObject:@"xr" forKey:@"itype"];
    if (self.model.weibo_id.length)
    {
        [MDict setObject:self.model.weibo_id forKey:@"weibo_id"];
    }
    if (self.model.id.length)
    {
        [MDict setObject:self.model.id forKey:@"weibo_id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
        
         FWStrongify(self)
         _has_next = [responseJson toInt:@"has_next"];
         _currentPage = [responseJson toInt:@"page"];
         if (_currentPage == 1)
         {
             [_dataArray removeAllObjects];
         }
         if ([responseJson toInt:@"status"]== 1)
         {
//             self.praiseBtn.selected = [responseJson[@"info"][@"has_digg"] isEqual:@(1)];
             if ([responseJson[@"info"][@"has_digg"] isEqual:@(1)]) {
                 _praiseBtn.selected = YES;
             }else{
                 _praiseBtn.selected = NO;
             }
             
             
             [self.praiseBtn setTitle:responseJson[@"info"][@"digg_count"] forState:UIControlStateNormal];
             [self.commentBtn setTitle:responseJson[@"info"][@"comment_count"] forState:UIControlStateNormal];
             NSDictionary *shareD = [responseJson objectForKey:@"invite_info"];
             if (shareD && [shareD isKindOfClass:[NSDictionary class]]) {
                 if ([shareD count])
                 {
                     if ([[shareD objectForKey:@"clickUrl"] length])
                     {
                         [self.shareDict setObject:[shareD objectForKey:@"clickUrl"] forKey:@"share_url"];
                     }else
                     {
                         [self.shareDict setObject:@"" forKey:@"share_url"];
                     }
                     if ([[shareD objectForKey:@"content"] length])
                     {
                         [self.shareDict setObject:[shareD objectForKey:@"content"] forKey:@"share_content"];
                     }else
                     {
                         [self.shareDict setObject:@"" forKey:@"share_content"];
                     }
                     if ([[shareD objectForKey:@"imageUrl"] length])
                     {
                         [self.shareDict setObject:[shareD objectForKey:@"imageUrl"] forKey:@"share_imageUrl"];
                     }else
                     {
                         [self.shareDict setObject:@"" forKey:@"share_imageUrl"];
                     }
                     if ([[shareD objectForKey:@"title"] length])
                     {
                         [self.shareDict setObject:[shareD objectForKey:@"title"] forKey:@"share_title"];
                     }else
                     {
                         [self.shareDict setObject:@"" forKey:@"share_title"];
                     }
                 }
             }
             _detailModel = [PersonCenterModel mj_objectWithKeyValues:responseJson];
             
//             [self.focusBtn setHidden:_detailModel.has_focus == 1];
             
             //动态
             NSArray *comment_listArray = [responseJson objectForKey:@"comment_list"];
             if (comment_listArray && [comment_listArray isKindOfClass:[NSArray class]])
             {
                 if (comment_listArray.count)
                 {
                     for (NSDictionary *dict in comment_listArray)
                     {
                         CommentModel *CModel = [CommentModel mj_objectWithKeyValues:dict];
                         [self.dataArray addObject:CModel];
                     }
                 }
             }
         }else
         {
             [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark 播放视频加1
- (void)addPlayNumWithWeiBoId:(NSString *)weiBoId
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"weibo" forKey:@"ctl"];
    [MDict setObject:@"add_video_count" forKey:@"act"];
    [MDict setObject:@"xr" forKey:@"itype"];
    if (weiBoId.length)
    {
        [MDict setObject:weiBoId forKey:@"weibo_id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             _detailModel.info.video_count = [responseJson toString:@"video_count"];
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             [postDict setObject:@"video" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%d",[responseJson toInt:@"video_count"]] forKey:@"count"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
         }else{
             [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark - Public Methods
- (void)setProgress:(float)progress {
    self.sliderView.value = progress;
}

- (void)startLoading {
    [self.loadingView startAnimating];
}

- (void)stopLoading {
    [self.loadingView stopAnimating];
}

- (void)showPlayBtn {
    self.playBtn.hidden = NO;
}

- (void)hidePlayBtn {
    self.playBtn.hidden = YES;
}

#pragma mark - Action
- (void)controlViewDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)iconDidClick:(id)sender {
    if (![GlobalVariables sharedInstance].userModel.is_open_young.integerValue) {
        if ([self.delegate respondsToSelector:@selector(controlViewDidClickIcon:)]) {
            [self.delegate controlViewDidClickIcon:self];
        }
    }
    
}

- (void)praiseBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPriase:)]) {
        [self.delegate controlViewDidClickPriase:self];
    }
}

- (void)commentBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickComment:DataArray:)]) {
        [self.delegate controlViewDidClickComment:self DataArray:self.dataArray];
    }
}

- (void)oneOnOneBtnClick:(UIButton *)sender{
    [self showPlayBtn];
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickOneOnOne:)]) {
        [self.delegate controlViewDidClickOneOnOne:self];
    }
}

- (void)shareBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickShare:ShareDict:)]) {
        [self.delegate controlViewDidClickShare:self ShareDict:self.shareDict];
    }
}

-(void)giftBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickGift:)]) {
        [self.delegate controlViewDidClickGift:self];
    }
}

- (void)setiIsPraise:(BOOL)isPraise diggcount:(nonnull NSString *)diggcount{
    
//    if (isPraise) {
//        [_praiseBtn setImage:[UIImage imageNamed:@"me_icon_star_selected"] forState:UIControlStateNormal];
//    }else{
//        [_praiseBtn setImage:[UIImage imageNamed:@"me_icon_star_normal"] forState:UIControlStateNormal];
//    }
    _praiseBtn.selected = isPraise;


//    self.praiseBtn.selected = isPraise;
    [self.praiseBtn setTitle:diggcount forState:UIControlStateNormal];
}

- (void)commentBtnAction{
    //点击了想撩TA按钮
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickBottomComment:)]) {
        [self.delegate controlViewDidClickBottomComment:self];
    }
}

- (void)focusBtnAction{
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:[NSString stringWithFormat:@"%@",self.model.user_id] forKey:@"to_user_id"];
    
    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             int has_focus = [responseJson toInt:@"has_focus"];
             if ([responseJson toInt:@"status"] == 1)
             {
                 if (has_focus == 1)//已关注
                 {
                     self.focusBtn.hidden = YES;
                     
                 }else if (has_focus == 0)//关注
                 {
                     self.focusBtn.hidden = NO;
                 }
                 self.model.has_focus = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"has_focus"]];
             }
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

#pragma mark - 懒加载
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.layer.cornerRadius = ADAPTATIONRATIO * 50.0f;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconView.layer.borderWidth = 1.0f;
        _iconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_iconView addGestureRecognizer:iconTap];
    }
    return _iconView;
}

- (HMVideoItemButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = [HMVideoItemButton new];
        [_praiseBtn setImage:[UIImage imageNamed:@"me_icon_star_normal"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"me_icon_star_selected"] forState:UIControlStateSelected];
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}

- (HMVideoItemButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [HMVideoItemButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"me_icon_comment"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (HMVideoItemButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [HMVideoItemButton new];
        [_shareBtn setImage:[UIImage imageNamed:@"me_icon_share"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

-(HMVideoItemButton *)giftBtn{
    if (!_giftBtn) {
        _giftBtn = [HMVideoItemButton new];
        [_giftBtn setImage:[UIImage imageNamed:@"mg_video_gift"] forState:UIControlStateNormal];
        _giftBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_giftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(giftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
        {
            _giftBtn.hidden = YES;
        }
    }
    return _giftBtn;
}

- (HMVideoItemButton *)oneOnOneBtn {
    if (!_oneOnOneBtn) {
        _oneOnOneBtn = [HMVideoItemButton new];
        [_oneOnOneBtn setImage:[UIImage imageNamed:@"me_icon_im_video"] forState:UIControlStateNormal];
        _oneOnOneBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_oneOnOneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oneOnOneBtn addTarget:self action:@selector(oneOnOneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneOnOneBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_nameLabel addGestureRecognizer:nameTap];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _contentLabel;
}

- (HMVideoSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [HMVideoSliderView new];
        _sliderView.isHideSliderBlock = YES;
        _sliderView.sliderHeight = ADAPTATIONRATIO * 1.0f;
        _sliderView.maximumTrackTintColor = [UIColor grayColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
    }
    return _sliderView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"me_icon_pause"] forState:UIControlStateNormal];
        _playBtn.userInteractionEnabled = NO;
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

- (UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_commentButton setBackgroundColor:kClearColor];
        [_commentButton setTitle:ASLocalizedString(@"想撩TA，先评论")forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_commentButton.titleLabel setTextColor:[kWhiteColor colorWithAlphaComponent:0.5]];
        _commentButton.hidden = YES;
        [_commentButton addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(kScreenW - kRealValue(10) - 64, kStatusBarHeight, kRealValue(44), kRealValue(44));
        [_moreBtn setImage:[UIImage imageNamed:@"video_more_Btn"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.hidden = YES;
    }
    return _moreBtn;
}


-(void)clickMoreBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickMoreBtn:)]) {
        [self.delegate controlViewDidClickMoreBtn:self];
    }
}

- (UIButton *)focusBtn{
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_focusBtn setImage:[UIImage imageNamed:@"me_icon_focus"] forState:UIControlStateNormal];
        [_focusBtn addTarget:self action:@selector(focusBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusBtn;
}

- (NSMutableDictionary *)shareDict{
    if (!_shareDict) {
        _shareDict = [NSMutableDictionary dictionary];
    }
    return _shareDict;
}

- (BogoVideoGoodControl *)goodControl{
    if (!_goodControl) {
//        _goodControl = [kShopKitBundle loadNibNamed:@"BogoVideoGoodControl" owner:self options:nil].firstObject;
        _goodControl = [kShopKitBundle loadNibNamed:@"BogoVideoGoodControl" owner:nil options:nil].lastObject;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toGoodDetailVC)];
        _goodControl.userInteractionEnabled = YES;
        [_goodControl addGestureRecognizer:tap];
    }
    return _goodControl;
}

- (void)toGoodDetailVC{
    if (self.model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = self.model.shop_id;
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC animated:YES];
    }
}

@end
