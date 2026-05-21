//
//  VoiceMoreView.m
//  BuguLive
//
//  Created by voidcat on 2024/5/25.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "VoiceMoreView.h"
#import "BogoGameListHeadView.h"
#import "BGRedPackSendView.h"
@interface VoiceMoreView ()
@property (weak, nonatomic) IBOutlet UILabel *labGame;
@property (weak, nonatomic) IBOutlet UILabel *labTool;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation VoiceMoreView

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
    self.redPackButton.imagePosition = QMUIButtonImagePositionTop;
    self.redPackButton.spacingBetweenImageAndTitle = 7;
    
    self.wishListButton.imagePosition = QMUIButtonImagePositionTop;
    self.wishListButton.spacingBetweenImageAndTitle = 7;
    
    
    self.managementButton.imagePosition = QMUIButtonImagePositionTop;
    self.managementButton.spacingBetweenImageAndTitle = 7;
    
    [self.redPackButton setTitle:ASLocalizedString(@"红包") forState:UIControlStateNormal];
    [self.wishListButton setTitle:ASLocalizedString(@"心愿单") forState:UIControlStateNormal];
    [self.managementButton setTitle:ASLocalizedString(@"房间管理") forState:UIControlStateNormal];

}
- (void)setUser_role:(int)user_role
{
    _user_role = user_role;
    //如果不是房主则把心愿单删除
    if(self.user_role != 1)
    {
        [self.wishListButton removeFromSuperview];
    }
    
    if(self.user_role != 1 && self.user_role != 2)
    {
        [self.managementButton removeFromSuperview];
    }
}
#pragma mark - View
- (void)setupView {
    self.labGame.text = ASLocalizedString(@"游戏");
    self.labTool.text = ASLocalizedString(@"工具");
    BogoGameListHeadView *gameView = [[[NSBundle mainBundle]loadNibNamed:@"BogoGameListHeadView" owner:self options:nil]lastObject];
    [self.gameViewContent addSubview:gameView];
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameViewContent.mas_top);
        make.left.mas_equalTo(self.gameViewContent.mas_left);
        make.right.mas_equalTo(self.gameViewContent.mas_right);
        make.bottom.mas_equalTo(self.gameViewContent.mas_bottom);
    }];
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
- (IBAction)clickWish:(id)sender {
    if(self.clickWishListBlock)
    {
        self.clickWishListBlock();
    }
}


- (IBAction)clickRed:(id)sender {
    BGRedPackSendView *readView = [[BGRedPackSendView alloc] init];
//            readView.video_id = self.video_id;
//            readView.userModel = user;
    readView.video_id = SafeStr(self.liveId);
    readView.frame = CGRectMake(40, 0, kRealValue(266), kRealValue(338));
    readView.centerX = self.centerX;
    readView.centerY = self.centerY;
//            readView.userModel = user;
//    readView.backgroundColor = kRedColor;
//        readView.diamonds = [NSString stringWithFormat:@"%@",responseJson[@"diamonds"]];

    [readView show:[UIApplication sharedApplication].keyWindow type:FDPopTypeCenter];
}
- (IBAction)clickManage:(id)sender {
    if(self.clickManagementBlock)
    {
        self.clickManagementBlock();
    }
}



#pragma mark - Setter


#pragma mark - Getter


@end
