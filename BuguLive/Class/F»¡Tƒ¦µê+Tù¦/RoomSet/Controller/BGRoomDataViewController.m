//
//  BGRoomDataViewController.m
//  UniversalApp
//
//  Created by 志刚杨 on 2022/3/21.
//  Copyright © 2022 voidcat. All rights reserved.
//

#import "BGRoomDataViewController.h"

@interface RoomDataModel :NSObject
@property (nonatomic , copy) NSString              * coin_number;
@property (nonatomic , copy) NSString              * day_coin;

@end

@implementation RoomDataModel

@end

@interface BGRoomDataViewController ()

@end

@implementation BGRoomDataViewController

#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavBar];
    
    //设置view
    [self setupView];
   
    //请求数据
    [self requestData];
    
    //添加通知
    [self addNotificationObserver];
}

#pragma mark - View
- (void)setupNavBar {
    
}

- (void)setupView {
    
}

#pragma mark - Network
- (void)requestData {
    
//    ViewRadius(self.avatar, self.avatar.width/2);
//    [self.avatar sd_setImageWithURL:safeurl(self.model.user.avatar)];
//    self.labNickname.text = self.model.voice.title;
//    self.labId.text = self.model.voice.user_id;
//    
//    ///voice/voice_additional_api/voice_earnings
//    
//    NSMutableDictionary *param=[NSMutableDictionary dictionary];
//    [param setObject:self.model.voice.user_id forKey:@"voice_id"];
//   
//    [CYNET POST:[[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"voice_additional_api" A:@"voice_earnings"] parameters:param responseCache:^(id responseObject) {
//
//    } success:^(id responseObject) {
//        
//        RoomDataModel *model = [RoomDataModel modelWithJSON:responseObject];
//        self.labToday.text = model.day_coin;
//        self.labTotal.text = model.coin_number;
//        
//        
//    } failure:^(NSString *error) {
//        [[BGHUDHelper sharedInstance] tipMessage:error];
//    } hasCache:NO];
    
    
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


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    
}

@end
