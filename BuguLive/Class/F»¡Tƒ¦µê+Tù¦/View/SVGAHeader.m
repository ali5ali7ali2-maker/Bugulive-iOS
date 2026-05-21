//
//  SVGAHeader.m
//  UniversalApp
//
//  Created by 志刚杨 on 2022/5/19.
//  Copyright © 2022 voidcat. All rights reserved.
//

#import "SVGAHeader.h"
#import "SVGA.h"

static SVGAParser *parser;

@interface SVGAHeader ()
@property (nonatomic, strong) SVGAPlayer *aPlayer;
@end

@implementation SVGAHeader
{
    NSString *lastFace;
}
#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        //设置view
        [self setupView];

        //请求数据
        [self requestData];

        //添加通知
        [self addNotificationObserver];
    }
    return self;
}



#pragma mark - View
- (void)setupView {
    self.aPlayer = [[SVGAPlayer alloc] init];
    self.aPlayer.userInteractionEnabled = NO;
//    self.aPlayer.backgroundColor = KRedColor;
    [self addSubview:self.aPlayer];

    [self.aPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);

              }];
    
}

- (void)setHeaderUrl:(NSString *)headerUrl
{
    _headerUrl = headerUrl;
    
    if (headerUrl.length) {
        self.aPlayer.hidden = NO;
        if([headerUrl containsString:@".svga"])
        {
            if(lastFace != headerUrl || lastFace == nil)
            {
                lastFace = headerUrl;
            
                
                parser = [[SVGAParser alloc] init];
                [parser parseWithURL:[NSURL URLWithString:headerUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                    self.aPlayer.videoItem = videoItem;
                    [self.aPlayer startAnimation];
               

                } failureBlock:^(NSError * _Nullable error) {
                }];
          

            }
     
            
        }
    }
    else
    {
        self.aPlayer.hidden = YES;
    }

    
}

#pragma mark - Network
- (void)requestData {
    
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


@end
