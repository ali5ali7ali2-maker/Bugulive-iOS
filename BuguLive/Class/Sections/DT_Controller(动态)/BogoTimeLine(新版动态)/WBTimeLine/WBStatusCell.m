//
//  WBFeedCell.m
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBStatusCell.h"
#import "YYControl.h"
#import "WBUserInfoModel.h"



@implementation WBStatusProfileView {
    BOOL _trackingTouch;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenW;
        frame.size.height = kWBCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _avatarView = [UIImageView new];
    _avatarView.size = CGSizeMake(40, 40);
    _avatarView.origin = CGPointMake(kWBCellPadding, kWBCellPadding + 3);
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = 20;
    [self addSubview:_avatarView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kWBCellNameWidth, 20);
    _nameLabel.left = _avatarView.right + kWBCellNamePaddingLeft;
    _nameLabel.top = _avatarView.top;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _nameLabel.centerY = _avatarView.centerY;
    [self addSubview:_nameLabel];
    
    //把self.topBtn放到_nameLabel后面
    _topBtn = [UIButton new];
    _topBtn.size = CGSizeMake(28, 18);
    ViewRadius(_topBtn, 3);
    [_topBtn setTitle:ASLocalizedString(@"置顶") forState:UIControlStateNormal];
    _topBtn.right = self.width - kWBCellPadding;
    _topBtn.centerY = _nameLabel.centerY;
    _topBtn.backgroundColor = [UIColor colorWithHexString:@"#C03E53"];
    _topBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    _topBtn.hidden = YES;
    [self addSubview:_topBtn];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.frame = CGRectMake(0, 0, 1, 20);
    _sourceLabel.right = self.width - kWBCellPadding;
    _sourceLabel.centerY = _nameLabel.centerY;
    _sourceLabel.textAlignment = NSTextAlignmentRight;
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    _sourceLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    _sourceLabel.hidden = YES;
    [self addSubview:_sourceLabel];
    
    _timeLabel = [YYLabel new];
    _timeLabel.frame = CGRectMake(0, 0, 1, 20);
    _timeLabel.left = _nameLabel.left;
    _timeLabel.top = _nameLabel.bottom + 5;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.displaysAsynchronously = YES;
    _timeLabel.ignoreCommonProperties = YES;
    _timeLabel.fadeOnAsynchronouslyDisplay = NO;
    _timeLabel.fadeOnHighlight = NO;
    _timeLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    _timeLabel.hidden = YES;
    [self addSubview:_timeLabel];
    
//    _sexView = [[CommonSexView alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 5, 15, 15)];
//    _levelView = [[CommonLevelView alloc]initWithFrame:CGRectMake(_sexView.right+5, _nameLabel.bottom + 5-0.5, 38, 16)];
//
//    _locationView = [[CommonLocationView alloc]initWithFrame:CGRectMake(_sexView.right + 5, _nameLabel.bottom + 5, 60, 20)];
//    _statusView = [[CommonStatusView alloc]initWithFrame:CGRectMake(_locationView.right + 5, _nameLabel.bottom + 5, 55, 20)];
    
    //关注按钮
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    ViewRadius(_moreBtn, 15);
    _moreBtn.right = self.width - kWBCellPadding;
    _moreBtn.centerY = _avatarView.centerY;
    [_moreBtn setTitle:ASLocalizedString(@"关注") forState:UIControlStateNormal];
    [_moreBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"dy_list_follow"] forState:UIControlStateNormal];
    __weak __typeof(self)weakSelf = self;
    [_moreBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.cell.delegate && [strongSelf.cell.delegate respondsToSelector:@selector(cell:didClickMore:)]) {
            [strongSelf.cell.delegate cell:strongSelf.cell didClickMore:sender];
        }
    }];
    _moreBtn.hidden = YES;
    [self addSubview:_moreBtn];

    
//    [self addSubview:_sexView];
//    [self addSubview:_levelView];

//    [self addSubview:_locationView];
//    [self addSubview:_statusView];
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _trackingTouch = NO;
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:_avatarView];
    if (CGRectContainsPoint(_avatarView.bounds, p)) {
        _trackingTouch = YES;
    }
    p = [t locationInView:_nameLabel];
    if (CGRectContainsPoint(_nameLabel.bounds, p) && _nameLabel.textLayout.textBoundingRect.size.width > p.x) {
        _trackingTouch = YES;
    }
    if (!_trackingTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesEnded:touches withEvent:event];
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.status];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end


@implementation WBStatusCardView {
    BOOL _isRetweet;
    WBStatusLayout *_layout;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0){
        frame.size.width = kScreenW;
        frame.origin.x = kWBCellPadding;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _badgeImageView = [UIImageView new];
    _badgeImageView.clipsToBounds = YES;
    _badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    _label = [YYLabel new];
    _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _label.numberOfLines = 3;
    _label.ignoreCommonProperties = YES;
    _label.displaysAsynchronously = YES;
    _label.fadeOnAsynchronouslyDisplay = NO;
    _label.fadeOnHighlight = NO;
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _playerView = [[CLPlayerView alloc] init];
    _playerView.backgroundColor = kClearColor;
    _playerView.layer.cornerRadius = 4;
    _playerView.layer.masksToBounds = YES;
    if ([_playerView.maskView respondsToSelector:NSSelectorFromString(@"playButton")]) {
        UIButton *playButton = [_playerView.maskView valueForKey:@"playButton"];
        playButton.hidden = YES;
    }
    _playerView.isFullScreen = NO;
    [_playerView updateWithConfigure:^(CLPlayerViewConfigure *configure) {
        configure.mute = YES;
        configure.repeatPlay = YES;
        configure.isLandscape = YES;
        configure.videoFillMode = VideoFillModeResizeAspectFill;
    }];
    
    
    [self addSubview:_imageView];
    [self addSubview:_badgeImageView];
    [self addSubview:_label];
    [self addSubview:_playerView];
    
    [self addSubview:_button];
    
    self.backgroundColor = kWBCellInnerViewColor;
    self.layer.borderWidth = CGFloatFromPixel(1);
    self.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.070].CGColor;
    return self;
}

- (void)setWithLayout:(WBStatusLayout *)layout isRetweet:(BOOL)isRetweet {
    _layout = layout;
    if (!StrValid(layout.status.video)) return;
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    self.height = 184;// kScreenW * 16 / 18;
    
    /*
     badge: 25,25 左上角 (42)
     image: 70,70 方形
     100, 70 矩形
     btn:  60,70
     
     lineheight 20
     padding 10
     */
    
    self.width = 135;// kScreenW / 2;
    _badgeImageView.hidden = YES;
    _label.hidden = YES;
    _imageView.frame = self.bounds;
    [_imageView setImageWithURL:[NSURL URLWithString:layout.status.cover_url] options:kNilOptions];
    _button.hidden = YES;
    _button.frame = self.bounds;
    [_button setTitle:nil forState:UIControlStateNormal];
    [_button cancelImageRequestForState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"aio_record_play_nor"] forState:UIControlStateNormal];
    //[WBStatusHelper imageNamed:@"multimedia_videocard_play"]
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = isRetweet ? [UIColor whiteColor] : kWBCellInnerViewColor;
    
    _playerView.url =[NSURL URLWithString:layout.status.video];
    _playerView.frame = self.bounds;
    [_playerView updateWithConfigure:^(CLPlayerViewConfigure *configure) {
        
        UITapGestureRecognizer *tapPlayerView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        [_playerView.maskView addGestureRecognizer:tapPlayerView];
        
        
        //播放
        [_playerView playVideo];
    }];
}

- (void)buttonAction:(UIButton *)sender{
    
//    [_playerView playVideo];

    if ([_cell.delegate respondsToSelector:@selector(cell:didClickVideo:)]) {
        [_cell.delegate cell:_cell didClickVideo:_layout.status.video];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = kWBCellInnerViewHighlightColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = _isRetweet ? [UIColor whiteColor] : kWBCellInnerViewColor;
    if ([_cell.delegate respondsToSelector:@selector(cellDidClickCard:)]) {
        [_cell.delegate cellDidClickCard:_cell];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = _isRetweet ? [UIColor whiteColor] : kWBCellInnerViewColor;
}

@end

@interface WBStatusLocationView ()

@property(nonatomic, strong) QMUIButton *locationBtn;
@property(nonatomic, strong) UIButton *topicBtn;

@end

@implementation WBStatusLocationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.exclusiveTouch = YES;
        [self addSubview:self.locationBtn];
        [self addSubview:self.topicBtn];
    }
    return self;
}

- (QMUIButton *)locationBtn{
    if (!_locationBtn) {
        _locationBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        _locationBtn.imagePosition = QMUIButtonImagePositionLeft;
//        [_locationBtn setImage:[UIImage imageNamed:@"位置_icon"] forState:UIControlStateNormal];
        _locationBtn.spacingBetweenImageAndTitle = 5;
        [_locationBtn sizeToFit];
        _locationBtn.height = 20;
        [_locationBtn setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
        [_locationBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    }
    return _locationBtn;
}

- (UIButton *)topicBtn{
    if (!_topicBtn) {
        _topicBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.locationBtn.right + 10, 0, 100, 30)];
        [_topicBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _topicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        __weak __typeof(self)weakSelf = self;
        [_topicBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.cell.delegate && [strongSelf.cell.delegate respondsToSelector:@selector(cell:didClickTopic:)]) {
                [strongSelf.cell.delegate cell:strongSelf.cell didClickTopic:strongSelf.cell.statusView.layout.status.theme];
            }
        }];
    }
    return _topicBtn;
}

- (void)setWithLayout:(WBStatusLayout *)layout{
    self.locationBtn.hidden = !layout.status.address.length;
    self.topicBtn.hidden = !layout.status.theme.length;
    if (layout.status.address.length) {
        [self.locationBtn setTitle:SafeStr(layout.status.address) forState:UIControlStateNormal];
        [self.locationBtn sizeToFit];
        self.locationBtn.height = 20;
    }
    if (layout.status.theme.length) {
        [self.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",layout.status.theme] forState:UIControlStateNormal];
        [self.topicBtn sizeToFit];
        if (layout.status.address.length) {
            self.topicBtn.left = self.locationBtn.right + 10;
        }else{
            self.topicBtn.left = 10;
        }
        self.topicBtn.width = self.topicBtn.width + 10;
        self.topicBtn.height = 30;
    }
    
    self.topicBtn.hidden = YES;
}

@end

@implementation WBStatusCommentBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
//        self.backgroundColor = kWhiteColor;
        self.layer.cornerRadius = 20;
        self.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.layer.borderWidth = 1;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.text = NSLocalizedString(@"感觉不错，评论一下",nil);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
        [self addSubview:titleLabel];
        UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        sendLabel.text = NSLocalizedString(@"发送",nil);
        sendLabel.textAlignment = NSTextAlignmentRight;
        sendLabel.font = [UIFont systemFontOfSize:15];
        sendLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
        [self addSubview:sendLabel];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.right = self.width - 100;
        lineView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        [self addSubview:lineView];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
        [sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.right.equalTo(self).offset(-20);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.width.mas_equalTo(@(1));
            make.right.equalTo(self).offset(-70);
            make.top.equalTo(self);
        }];
    }
    return self;
}

@end

@implementation WBStatusTimeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _timeLabel = [YYLabel new];
        _timeLabel.frame = CGRectMake(0, 0, 1, 20);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.displaysAsynchronously = YES;
        _timeLabel.ignoreCommonProperties = YES;
        _timeLabel.fadeOnAsynchronouslyDisplay = NO;
        _timeLabel.fadeOnHighlight = NO;
        [self addSubview:_timeLabel];
    }
    return self;
}

@end

@implementation WBStatusToolbarView
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.width = kScreenW;
    frame.size.height = kWBCellToolbarHeight;
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _likeSubviews = [NSMutableArray array];
    
    _praiseBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 1, 40)];
    _praiseBtn.left = 15;
    [_praiseBtn setImagePosition:QMUIButtonImagePositionLeft];
    [_praiseBtn setSpacingBetweenImageAndTitle:7];
    [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_praiseBtn setImage:[UIImage imageNamed:@"mg_dy_likes"] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    
    _commentBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(0, 0, 1, 40)];
    _commentBtn.left = _praiseBtn.right + 15;
    [_commentBtn setImagePosition:QMUIButtonImagePositionLeft];
    [_commentBtn setSpacingBetweenImageAndTitle:7];
    [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_commentBtn setImage:[UIImage imageNamed:@"mg_dy_comment"] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"0" forState:UIControlStateNormal];
    @weakify(self);
    
    [_commentBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        WBStatusCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
            [cell.delegate cellDidClickComment:cell];
        }
    }];
    
    [_praiseBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        WBStatusCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
            [cell.delegate cellDidClickLike:cell];
        }
    }];
    
    [self addSubview:_praiseBtn];
    [self addSubview:_commentBtn];
    return self;
}

- (void)setWithLayout:(WBStatusLayout *)layout {
    [_praiseBtn setImage:layout.status.is_like.integerValue ? [self likeImage] : [self unlikeImage] forState:UIControlStateNormal];
    [_praiseBtn setTitle:[NSString stringWithFormat:@"%@",layout.status.praise] forState:UIControlStateNormal];
    [_commentBtn setTitle:layout.status.comments forState:UIControlStateNormal];
    [_praiseBtn setSize:[_praiseBtn sizeThatFits:CGSizeMake(MAXFLOAT, 40)]];
    _praiseBtn.height = 40;
    _praiseBtn.width = _praiseBtn.width + 10;
    _praiseBtn.left = 15;
    _praiseBtn.centerY = self.height / 2;
    [_commentBtn setSize:[_commentBtn sizeThatFits:CGSizeMake(MAXFLOAT, 40)]];
    _commentBtn.height = 40;
    _commentBtn.width = _commentBtn.width + 10;
    _commentBtn.left = _praiseBtn.right + 15;
    _commentBtn.centerY = self.height / 2;
    _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
}

- (UIImage *)likeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"mg_dy_likes_select"];
    });
    return img;
}

- (UIImage *)unlikeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"mg_dy_likes"];
    });
    return img;
}

- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation {
    WBStatusLayout *layout = _cell.statusView.layout;

    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
    int newCount = [layout.status.praise intValue];
//    like_count.intValue;
    newCount = liked ? newCount + 1 : newCount - 1;
    if (newCount < 0) newCount = 0;
    if (liked && newCount < 1) newCount = 1;
    NSString *newCountDesc = newCount > 0 ? [WBStatusHelper shortedNumberDesc:newCount] : @"0";

    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenW, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:newCountDesc];
    likeText.font = font;
    likeText.color = liked ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:likeText];

    layout.status.is_like = liked ? @"1" : @"0";
    layout.status.praise = [NSString stringWithFormat:@"%d",newCount];
    layout.toolbarLikeTextLayout = textLayout;
    [_praiseBtn setTitle:[NSString stringWithFormat:@"%@",layout.status.praise] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _praiseBtn.imageView.layer.transformScale = 1.7;
    } completion:^(BOOL finished) {
        [_praiseBtn setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            _praiseBtn.imageView.layer.transformScale = 0.9;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _praiseBtn.imageView.layer.transformScale = 1;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

@end


@implementation WBStatusView {
    BOOL _touchRetweetView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenW;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _contentView = [UIView new];
    _contentView.width = kScreenW;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    static UIImage *topLineBG, *bottomLineBG;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        bottomLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
    });
    UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
    
    topLine.left = 12;
    topLine.width = _contentView.width - 12 * 2;
    topLine.bottom = 0;
    topLine.height = 1;
//    topLine.hidden = YES;
    topLine.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:topLine];
    
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
    bottomLine.top = _contentView.height;
    bottomLine.left = 12;
    bottomLine.width = _contentView.width - 12 * 2;
    
    bottomLine.height = 2;
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:bottomLine];
    [self addSubview:_contentView];
    
    _profileView = [WBStatusProfileView new];
    [_contentView addSubview:_profileView];
    
    _textLabel = [YYLabel new];
    _textLabel.left = kWBCellPadding;
    _textLabel.width = kWBCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textLabel];
    
//    _audioBtn = [[NSBundle mainBundle] loadNibNamed:@"BogoDynamicAudioButton" owner:nil options:nil].lastObject;
//    _audioBtn.frame = CGRectMake(10, 0, 148, 40);
//    _audioBtn.hidden = YES;
//    _audioBtn.deleteBtn.hidden = YES;
//    [_audioBtn addTapBlock:^(UIButton *btn) {
//        if (weak_self.cell.delegate && [weak_self.cell.delegate respondsToSelector:@selector(cell:didClickAudio:)]) {
//            [weak_self.cell.delegate cell:self didClickAudio:btn];
//        }
//    }];
//    [self addSubview:_audioBtn];
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5;
        imageView.backgroundColor = kWBCellHighlightColor;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:i];
                }
            }
        };
        
        UIView *badge = [UIImageView new];
        badge.userInteractionEnabled = NO;
        badge.contentMode = UIViewContentModeScaleAspectFit;
        badge.size = CGSizeMake(56 / 2, 36 / 2);
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.right = imageView.width;
        badge.bottom = imageView.height;
        badge.hidden = YES;
        [imageView addSubview:badge];
        
        [picViews addObject:imageView];
        [_contentView addSubview:imageView];
    }
    _picViews = picViews;
    
    _locationView = [WBStatusLocationView new];
    [_contentView addSubview:_locationView];
    
    _cardView = [WBStatusCardView new];
    _cardView.tag = 100;
    _cardView.hidden = YES;
    _cardView.layer.cornerRadius = 4;
    _cardView.layer.masksToBounds = YES;
    [_contentView addSubview:_cardView];
    
    _timeView = [WBStatusTimeView new];
    [_contentView addSubview:_timeView];
    
    _toolbarView = [WBStatusToolbarView new];
    [_contentView addSubview:_toolbarView];
    
//    _commentBtn = [WBStatusCommentBtn new];
//    [_contentView addSubview:_commentBtn];
    
    //删除按钮

    _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    _deleteBtn.right = self.width - kWBCellPadding;
    
    [_deleteBtn setTitle:ASLocalizedString(@"删除") forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#8C90E9"] forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
//    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"img_dynamic_focus_bg"] forState:UIControlStateNormal];
    __weak __typeof(self)weakSelf = self;
    
    [_deleteBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
    
        
        if (strongSelf.cell.delegate && [strongSelf.cell.delegate respondsToSelector:@selector(cell:didClickDeleteBtn:)]) {
            [strongSelf.cell.delegate cell:strongSelf.cell didClickDeleteBtn:sender];
        }
    }];
    _deleteBtn.hidden = YES;
    [_contentView addSubview:_deleteBtn];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
//    [_contentView addSubview:_lineView];
    
    return self;
}

- (void)setIsfollow:(BOOL)isfollow{
    _isfollow=isfollow;
//    _profileView.moreBtn.hidden=isfollow;
    _profileView.moreBtn.hidden = YES;
}

- (void)setLayout:(WBStatusLayout *)layout {
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    
    
    

    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    [_profileView.nameLabel sizeToFit];
    _profileView.topBtn.left = _profileView.nameLabel.right + 3;
    _profileView.topBtn.hidden = layout.status.is_top.intValue == 0;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    _profileView.timeLabel.textLayout = layout.sourceTextLayout;
//    _profileView.sexView.hidden = self.cell.isShowMore;
//    _profileView.levelView.hidden = self.cell.isShowMore;
//    _profileView.locationView.hidden = self.cell.isShowMore;
//    if (![layout.status.userInfo.id isEqualToString:[IMAPlatform sharedInstance].host.userId]) {
        _profileView.sourceLabel.hidden = YES;
        [_profileView.sourceLabel setSize:[_profileView.sourceLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]];
        _profileView.sourceLabel.right = self.width - kWBCellPadding;
        _profileView.sourceLabel.centerY = _profileView.nameLabel.centerY;
//    }else{
//        _profileView.sourceLabel.hidden = YES;
//        [_profileView.timeLabel setSize:[_profileView.timeLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]];
//        _profileView.timeLabel.left = _profileView.nameLabel.left;
//        _profileView.timeLabel.top = _profileView.nameLabel.bottom + 5;
//    }
    _timeView.timeLabel.textLayout = layout.sourceTextLayout;
    [_timeView.timeLabel setSize:[_profileView.timeLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]];
    [_timeView setSize:[_profileView.timeLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]];
    
    [_profileView.sexView setSex:BogoMale age:@16];
    
    _profileView.statusView.left = _profileView.sexView.right + 10;
    
    _profileView.statusView.hidden = YES;

    

    

    _profileView.height = layout.profileHeight;
    _profileView.top = top;
    top += layout.profileHeight;

//    _audioBtn.top = top + 15;
//    _audioBtn.height = 40;

//    top += layout.status.audio.length ? 55 : 5;
//    _audioBtn.hidden = YES;
//    !layout.status.audio.length;
//    _audioBtn.timeLabel.text = [NSString stringWithFormat:@"%@s",layout.status.audio_duration];
//    _audioBtn.imgView.animationRepeatCount = layout.status.audio_duration.integerValue * 2;

    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;

    if (_textLabel.height == 0) {
        top += kWBCellPadding;
    }

    _retweetBackgroundView.hidden = YES;
    _retweetTextLabel.hidden = YES;
//    _cardView.hidden = YES;
    if (layout.picHeight == 0) {
        [self _hideImageViews];
    }
    
    
    if (layout.picHeight > 0) {
        [self _setImageViewWithTop:top isRetweet:NO];
    }
    if (layout.cardHeight > 0) {
        _cardView.top = top;
        _cardView.hidden = NO;
        [_cardView setWithLayout:layout isRetweet:NO];
    }else{
        _cardView.hidden = YES;
    }
    

    [_locationView setWithLayout:layout];
    if (StrValid(layout.status.address)) {
        CGSize locationSize = [_locationView sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        [_locationView setSize:CGSizeMake(locationSize.width, 20)];
        _locationView.hidden = NO;
    }else{
        _locationView.hidden = YES;
    }

    
    /// 圆角头像
    if (layout.status.no_name.intValue == 1 && ![layout.status.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        _profileView.avatarView.image = [UIImage imageNamed:@"匿名头像"];
        
        _profileView.moreBtn.hidden = YES;
        
    }else{
        
        if (layout.status.is_focus.integerValue != 1 && ![layout.status.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
            _profileView.moreBtn.hidden = NO;
        }else{
            _profileView.moreBtn.hidden = YES;
        }
        
        
        [_profileView.avatarView setImageWithURL:[NSURL URLWithString:layout.status.head_image] //profileImageURL
                                     placeholder:nil
                                         options:kNilOptions
                                         manager:nil
                                        progress:nil
                                       transform:nil
                                      completion:nil];// 圆角头像manager，内置圆角处理
    }
    
    if ([layout.status.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    
    
    _toolbarView.bottom = _contentView.height - 10;
  
    _timeView.bottom = _toolbarView.top;
    _timeView.left = 15;
    _locationView.centerY = _timeView.centerY;
    _deleteBtn.centerY = _toolbarView.centerY;
    _locationView.left = _timeView.right;
    
    [_toolbarView setWithLayout:layout];
    
   
    
}

- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop isRetweet:(BOOL)isRetweet {
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    CGSize picSize = CGSizeMake(len1_3, len1_3);
    NSArray *pics = _layout.status.picUrls;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kWBCellPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kWBCellPadding + (i % 2) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kWBCellPaddingPic);
                } break;
                default: {
                    origin.x = kWBCellPadding + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            NSString *pic = pics[i];
            
//            UIView *badge = imageView.subviews.firstObject;
//            switch (pic.largest.badgeType) {
//                case WBPictureBadgeTypeNone: {
//                    if (badge.layer.contents) {
//                        badge.layer.contents = nil;
//                        badge.hidden = YES;
//                    }
//                } break;
//                case WBPictureBadgeTypeLong: {
//                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_longimage"].CGImage);
//                    badge.hidden = NO;
//                } break;
//                case WBPictureBadgeTypeGIF: {
//                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_gif"].CGImage);
//                    badge.hidden = NO;
//                } break;
//            }
            @weakify(imageView);
            [imageView.layer setImageWithURL:[NSURL URLWithString:pic]
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                @strongify(imageView);
                if (!imageView) return;
                if (image && stage == YYWebImageStageFinished) {
                    int width = len1_3;
                    int height = len1_3;
                    CGFloat scale = (height / width) / (imageView.height / imageView.width);
                    if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                    } else { // 高图只保留顶部
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                    }
                    ((YYControl *)imageView).image = image;
                    if (from != YYWebImageFromMemoryCacheFast) {
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.15;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                        transition.type = kCATransitionFade;
                        [imageView.layer addAnimation:transition forKey:@"contents"];
                    }
                }
            }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:_retweetBackgroundView];
    BOOL insideRetweet = CGRectContainsPoint(_retweetBackgroundView.bounds, p);
    
    if (!_retweetBackgroundView.hidden && insideRetweet) {
        [(_retweetBackgroundView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = YES;
    } else {
        [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    if (_touchRetweetView) {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClickRetweet:)]) {
            [_cell.delegate cellDidClickRetweet:_cell];
        }
    } else {
        UITouch *touch = touches.anyObject;
        
        if (CGRectContainsPoint(self.locationView.topicBtn.frame, [touch locationInView:self.locationView])) {
            if (self.cell.delegate && [self.cell.delegate respondsToSelector:@selector(cell:didClickTopic:)]) {
                [self.cell.delegate cell:self.cell didClickTopic:self.cell.statusView.layout.status.theme];
            }
        }else{
            if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
                [_cell.delegate cellDidClick:_cell];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_retweetBackgroundView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    
    _contentView.backgroundColor = [UIColor whiteColor];
    _retweetBackgroundView.backgroundColor = kWBCellInnerViewColor;
}

@end






@implementation WBStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _statusView = [WBStatusView new];
    _statusView.cell = self;
    _statusView.profileView.cell = self;
    _statusView.cardView.cell = self;
    _statusView.toolbarView.cell = self;
    _statusView.locationView.cell = self;
    [self.contentView addSubview:_statusView];
    return self;
}

- (void)prepareForReuse {
    // ignore
}

- (void)setLayout:(WBStatusLayout *)layout {
    _layout = layout;
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}
- (void)setIsfollow:(BOOL)isfollow{
    _isfollow=isfollow;
    _statusView.isfollow=isfollow;
}
@end
