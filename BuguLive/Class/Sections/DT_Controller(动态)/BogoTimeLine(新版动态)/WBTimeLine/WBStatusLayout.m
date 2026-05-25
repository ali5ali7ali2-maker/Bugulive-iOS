//
//  WBFeedLayout.m
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBStatusLayout.h"
#import "WBUserInfoModel.h"

/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation WBTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    WBTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
//    CGFloat ascent = _font.ascender;
//    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end


/**
 微博的文本中，某些嵌入的图片需要从网上下载，这里简单做个封装
 */
@interface WBTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize size;
@end

@implementation WBTextImageViewAttachment {
    UIImageView *_imageView;
}
- (void)setContent:(id)content {
    _imageView = content;
}
- (id)content {
    /// UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (_imageView) return _imageView;
    
    /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
    /// 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画了
    _imageView = [UIImageView new];
    _imageView.size = _size;
    [_imageView setImageWithURL:_imageURL placeholder:nil];
    return _imageView;
}
@end


@implementation WBStatusLayout

- (instancetype)initWithStatus:(WBModel *)status style:(WBLayoutStyle)style {
    if (!status) return nil;
    self = [super init];
    _status = status;
    _style = style;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}

- (void)updateDate {
    [self _layoutTime];
}

- (void)_layout {
    
    _marginTop = 0;
    _titleHeight = 0;
    _profileHeight = 0;
    _textHeight = 0;
    _retweetHeight = 0;
    _retweetTextHeight = 0;
    _retweetPicHeight = 0;
    _retweetCardHeight = 0;
    _picHeight = 0;
    _cardHeight = 0;
    _toolbarHeight = kWBCellToolbarHeight;
    _marginBottom = -5;
    
    
    // 文本排版，计算布局
    [self _layoutTitle];
    [self _layoutProfile];
    [self _layoutRetweet];
    [self _layoutPics];
    [self _layoutCard];
    [self _layoutLocation];
    [self _layoutText];
    [self _layoutTag];
    [self _layoutToolbar];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    _height += _titleHeight;
    _height += _profileHeight;
    _height += _textHeight;
    _height += self.status.audio.length ? 50 : 0;
    if (_retweetHeight > 0) {
        _height += _retweetHeight;
    } else if (_picHeight > 0) {
        _height += _picHeight;
    }
//    else
    if (_cardHeight > 0) {
        _height += _cardHeight;
        _height -= _picHeight;
    }
    if (_tagHeight > 0) {
        _height += _tagHeight;
    } else {
        if (_picHeight > 0 || _cardHeight > 0) {
            _height += kWBCellPadding;
        }
    }
    
    if (_locationHeight) {
        _height += _locationHeight + kWBCellPadding;
    }
    
    _height += _toolbarHeight;
    _height += 30;//时间
    _height += _marginBottom;
}

- (void)_layoutTitle {
    _titleHeight = 0;
    _titleTextLayout = nil;
}

- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutTime];
    _profileHeight = kWBCellProfileHeight;
}

/// 名字
- (void)_layoutName {
//    WBUserInfoModel *user = _status.userInfo;
    NSString *nameStr = _status.nick_name;
    
    if (_status.no_name.intValue == 1 && ![_status.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        nameStr  = ASLocalizedString(@"匿名用户");
    }
    
    
//    user.user_nickname;
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    nameText.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];// [UIFont systemFontOfSize:kWBCellNameFontSize];
    nameText.color = kWBCellNameNormalColor;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}

/// 时间和来源
- (void)_layoutTime {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = [WBStatusHelper stringWithTimelineDate:[NSDate dateWithTimeIntervalSince1970:_status.addtime.integerValue]];
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:11];//13
        timeText.color = [UIColor colorWithHexString:@"#AAAAAA"];//@"#666666"
        [sourceText appendAttributedString:timeText];
    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}



- (void)_layoutRetweet {
    _retweetHeight = 0;
}

/// 文本
- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithStatus:_status
                                                  isRetweet:NO
                                                   fontSize: 13
                                                  textColor:kWBCellTextNormalColor];//;kWBCellTextFontSize
    if (text.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font =[UIFont systemFontOfSize:13];// [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}


- (void)_layoutRetweetedText {
    _retweetHeight = 0;
    _retweetTextLayout = nil;
}

- (void)_layoutPics {
    [self _layoutPicsWithStatus:_status isRetweet:NO];
}

- (void)_layoutRetweetPics {
    
}

- (void)_layoutPicsWithStatus:(WBModel *)status isRetweet:(BOOL)isRetweet {
    NSArray *pics = status.picUrls;
    if (pics.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (pics.count) {
        case 1: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    _picSize = picSize;
    _picHeight = picHeight;
    NSLog(@"_picHeight:%f",_picHeight);
    
    
}

- (void)_layoutCard {
    [self _layoutCardWithStatus:_status isRetweet:NO];
}

- (void)_layoutLocation {
    _locationHeight = 0;
//    if (_status.address.length) {
//        _locationHeight = 30;
//    }
}

- (void)_layoutRetweetCard {
    
}

- (void)_layoutCardWithStatus:(WBModel *)status isRetweet:(BOOL)isRetweet {
    _cardType = WBStatusCardTypeNone;
    _cardHeight = 0;
    _cardTextLayout = nil;
    _cardTextRect = CGRectZero;
    
    WBStatusCardType cardType = WBStatusCardTypeNone;
    CGFloat cardHeight = 0;
    YYTextLayout *cardTextLayout = nil;
    CGRect textRect = CGRectZero;
    
    if (StrValid(status.video)) {
        // 视频，一个大图片，上面播放按钮
        cardType = WBStatusCardTypeVideo;
        CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
        len1_3 = CGFloatPixelRound(len1_3);
        cardHeight = 184;// kScreenW * 16 / 18;
//        135 184
    }
    _cardType = cardType;
    _cardHeight = cardHeight;
    _cardTextLayout = cardTextLayout;
    _cardTextRect = textRect;
}

- (void)_layoutTag {
    _tagType = WBStatusTagTypeNone;
    _tagHeight = 0;
    
    
}

- (void)_layoutToolbar {
    // should be localized
}




- (NSMutableAttributedString *)_textWithStatus:(WBModel *)status
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!status) return nil;
    
    NSMutableString *string;
    if (status.theme.length) {
        string = [NSString stringWithFormat:@"#%@#%@",status.theme,status.content].mutableCopy;
    }else{
        string = status.content.mutableCopy;
    }
    if (string.length == 0) return nil;
    if (isRetweet) {
        
    }
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.font = font;
    text.color = textColor;
    
    // 根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
    if (status.theme.length) {
        NSString *topicTitle = [NSString stringWithFormat:@"#%@#",status.theme];
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:topicTitle options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;

            if ([text attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                [text setColor:kWBCellTextHighlightColor range:range];

                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkTopicName : status.theme};
                [text setTextHighlight:highlight range:range];
            }
            searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
            if (searchRange.location + 1>= text.length) break;
            searchRange.length = text.length - searchRange.location;
        } while (1);
    }
    
    return text;
}


- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink {
    
    //    CGFloat ascent = YYEmojiGetAscentWithFontSize(fontSize);
    //    CGFloat descent = YYEmojiGetDescentWithFontSize(fontSize);
    //    CGRect bounding = YYEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    // Heiti SC 字体。。
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.content = image;
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        attachment.contentInsets = contentInsets;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize imageURL:(NSString *)imageURL shrink:(BOOL)shrink {
    /*
     微博 URL 嵌入的图片，比临近的字体要小一圈。。
     这里模拟一下 Heiti SC 字体，然后把图片缩小一下。
     */
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    CGSize size = CGSizeMake(fontSize, fontSize);
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        size = CGSizeMake(fontSize - fontSize * scale * 2, fontSize - fontSize * scale * 2);
        size = CGSizePixelRound(size);
    }
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    WBTextImageViewAttachment *attachment = [WBTextImageViewAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.size = size;
    attachment.imageURL = [WBStatusHelper defaultURLForImageURL:imageURL];
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (WBTextLinePositionModifier *)_textlineModifier {
    static WBTextLinePositionModifier *mod;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mod = [WBTextLinePositionModifier new];
        mod.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
        mod.paddingTop = 10;
        mod.paddingBottom = 10;
    });
    return mod;
}

@end
