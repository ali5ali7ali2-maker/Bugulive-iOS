//
//  SVGAAnimationView.m
//  SVGADemo
//
//  Created by bogokj on 2020/10/11.
//

#import "SVGAAnimationView.h"
#import "SVGA.h"
#import "SVGAVideoEntity.h"
#import "GiftModel.h"

@interface SVGAAnimationView ()<SVGAPlayerDelegate>

@property(nonatomic, strong) SVGAPlayer *player;
@property(nonatomic, strong) SVGAParser *parser;
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation SVGAAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:NO];
        [self addSubview:self.player];
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(- MG_BOTTOM_SAFE_HEIGHT - 49 - 20);
        }];
    }
    return self;
}

- (void)setGiftModel:(GiftModel *)giftModel{
    _giftModel = giftModel;
    NSString *url;
    
    url = giftModel.animated_url;
    
    [self.parser parseWithURL:[NSURL URLWithString:url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize newSize = CGSizeMake(kScreenW, kScreenW * videoItem.videoSize.height / videoItem.videoSize.width);
                self.player.frame = CGRectMake(0, (kScreenHeight - newSize.height ) / 2, newSize.width, newSize.height);
                [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.player.mas_bottom).offset(10);
                }];
                self.player.videoItem = videoItem;
                [self.player startAnimation];
            });
        }
    } failureBlock:nil];
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    if (self.delegate && [self.delegate respondsToSelector:@selector(svgaAnimationView:didFinishAnimation:)]) {
        [self.delegate svgaAnimationView:self didFinishAnimation:self.giftModel];
    }
}

- (SVGAPlayer *)player{
    if (!_player) {
        _player = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        _player.delegate = self;
        _player.loops = 1;
        _player.clearsAfterStop = YES;
    }
    return _player;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (SVGAParser *)parser{
    if (!_parser) {
        _parser = [[SVGAParser alloc] init];
    }
    return _parser;
}

@end
