//
//  choseMuiscVC.h
//  BuguLive
//
//  Created by zzl on 16/6/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "baseVC.h"
#import "CustomPlayerView.h"

@protocol MusicPlayerDelegate <NSObject>
- (void)playMusicClicked:(musiceModel *)model;
//停止音乐
- (void)stopMusic;
@end

@interface choseMuiscVC : baseVC

@property (weak, nonatomic) IBOutlet UITextField *msearchbar;

@property (weak, nonatomic) IBOutlet UITableView *mtableview;//下载列表
@property (weak, nonatomic) IBOutlet UITableView *msearchtableview;//搜索列表
@property (weak, nonatomic) IBOutlet UITableView *mhistorytableview;//历史记录列表

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mtopconsth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;

@property (nonatomic, weak) id<MusicPlayerDelegate> delegate;

@property (nonatomic, strong)   void(^mitblock)(musiceModel* chosemusic);

@property(nonatomic, strong) CustomPlayerView *playerView;

@property(nonatomic, strong) NSString *playMusicId;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
