//
//  RoomSetViewController.m
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "RoomSetViewController.h"

#import "BGRoomSetHeadCell.h"
#import "BGRoomSetNoticeCell.h"

#import "BGRoomSetChannelCell.h"
#import "BGRoomSetPwdCell.h"
#import "SetCell.h"
#import "RoomModel.h"

#import "CYImagePickerViewController.h"

#import "BGRoomManagerViewController.h"
#import "BGRoomBGImageViewController.h"

#import "RoomBGImageModel.h"
#import "BGRoomDataViewController.h"
#import "VoiceRoomSetInfoModel.h"
@interface RoomSetViewController ()<QMUITableViewDelegate,QMUITableViewDataSource>


@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *voice_avatar;

@property(nonatomic, strong) NSMutableArray *channelDataArray;

@property(nonatomic, strong) QMUITextField *textField;

@property(nonatomic, strong) QMUITextView *textView;

@property(nonatomic, strong) VideoClassifiedModel *channelModel;

@property(nonatomic, assign) BOOL onPwd;

@property(nonatomic, strong) QMUITextField *pwdTextField;

@property(nonatomic, strong) RoomBGImageModel *selectModel;
@property(nonatomic, copy) NSString *voice_bg;//id
@property(nonatomic, copy) NSString *voice_bg_image;//url

//房间头像
@property(nonatomic, strong) NSIndexPath * imageIndexPath;

@property(nonatomic, strong) VoiceRoomSetInfoModel *infoModel;

@property(nonatomic, strong) UIButton *postButton;

@end

@implementation RoomSetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    

}

- (void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ASLocalizedString(@"房间设置");
    
    [self setUpView];
}

-(void)setUpView{
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.image = [UIImage imageNamed:@"背景 (5)"];
    [self.view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //添加返回按钮与标题
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.left.mas_equalTo(13.5);
        make.width.and.height.mas_equalTo(44);
    }];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = ASLocalizedString(@"管理");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn);
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:titleLabel];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.view).offset(-11);
        make.left.and.right.equalTo(self.view);
    }];
    self.tableView.frame = self.view.bounds;
    self.tableView.height = kScreenH - kTopHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[BGRoomSetHeadCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomSetHeadCell class])];
    [self.tableView registerClass:[BGRoomSetNoticeCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomSetNoticeCell class])];
    [self.tableView registerClass:[BGRoomSetChannelCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomSetChannelCell class])];
    [self.tableView registerClass:[BGRoomSetPwdCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomSetPwdCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SetCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SetCell class])];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.postButton.backgroundColor = [UIColor qmui_colorWithHexString:@"#AE2CF1"];
    self.postButton.layer.cornerRadius = 22;
    self.postButton.layer.masksToBounds = YES;
    self.postButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.postButton setTitle:ASLocalizedString(@"保存") forState:UIControlStateNormal];
    [self.postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.postButton.backgroundColor = [UIColor qmui_colorWithHexString:@"#AE2CF1"];
    [self.view addSubview:self.postButton];
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-20);
    }];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"get_manage_voice" forKey:@"act"];
    [dict setValue:self.model.room_id forKey:@"room_id"];

    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        self.infoModel = [VoiceRoomSetInfoModel modelWithJSON:responseJson[@"data"]];
        
        self.onPwd = self.infoModel.password.length > 0;

            //不是房主，是管理员
            //is_room_administrator 房主是2，管理员是1
            if (self.infoModel.is_room_administrator == 2) {
                [self.dataArray addObject:@{@"leftTitle":ASLocalizedString(@"管理员"),@"rightTitle":@""}];
                [self.dataArray addObject:@{@"leftTitle":ASLocalizedString(@"房间背景"),@"rightTitle":@""}];
                [self.dataArray addObject:@{@"leftTitle":ASLocalizedString(@"房间数据"),@"rightTitle":@""}];
            } else {

                [self.dataArray addObject:@{@"leftTitle":ASLocalizedString(@"房间背景"),@"rightTitle":@""}];
                [self.dataArray addObject:@{@"leftTitle":ASLocalizedString(@"房间数据"),@"rightTitle":@""}];
            }
        

        
        [self.tableView reloadData];
            [self requestData];
        
    } FailureBlock:^(NSError *error) {
    }];
    
    //    [self.dataArray addObject:@{@"leftTitle":@"",@"rightTitle":@""}];
    //    [self.dataArray addObject:@{@"leftTitle":@"房间名称",@"rightTitle":self.model.voice.title}];

      
//        [self addNavigationItemWithTitles:@[ASLocalizedString(@"保存")] isLeft:NO target:self action:@selector(saveBtnAction) tags:@[@(1001)] colors:@[]];
    
//    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[GlobalVariable sharedGlobalVariable].hallTypeList];
//    [tempArray removeObjectAtIndex:0];
//    [tempArray removeObjectAtIndex:0];
//
//    [self.channelDataArray setArray:tempArray];
    
    
}


- (void)startBtnAction {
    
    [self submitData];

}


- (void)saveBtnAction{
    [self.view endEditing:YES];
    [self updateData];

    
}


- (void)submitData {
    
    
   //开启直播设置接口
    
    if (!self.textField.text.length) {
        [[BGHUDHelper sharedInstance] tipMessage:self.textField.placeholder];
        return;
    }

    
//    NSString *url=[[CYURLUtils sharedCYURLUtils]makeVoiceURLWithC:@"voice_api" A:@"start_voice"];
//
//    
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    
//    if (StrValid(self.textField.text)) {
//        [param setObject:self.textField.text forKey:@"voice_title"];
//
//    }
//    
//    if (self.voice_avatar) {
//        [param setObject:self.voice_avatar forKey:@"voice_img"];
//
//    }
//    
//    if (StrValid(self.textView.text)) {
//        [param setObject:self.textView.text forKey:@"announcement"];
//
//    }
//    
//    if (self.voice_bg) {
//        [param setObject:self.voice_bg forKey:@"voice_bg"];
//
//    }
//
//
//    if (self.channelModel) {
//        [param setObject:self.channelModel.id forKey:@"voice_theme_id"];
//
//    }
//    
//    
//    [CYNET POST:url parameters:param responseCache:^(id responseObject) {
//        
//    } success:^(id responseObject) {
//       
//        
//
//
//        
//        
//        
//    } failure:^(NSString *error) {
//        
//        [[BGHUDHelper sharedInstance] tipMessage:error];
//
//    } hasCache:NO];
    
    
    
    
}
- (void)updateData {
    
    
//    if (!self.textField.text.length) {
//        [[BGHUDHelper sharedInstance] tipMessage:@"未输入标题"];
//        return;
//    }
    
//    if ([self.textField.text isEqualToString:self.model.voice.title]) {
//        return;
//    }

    if (!self.textField.text.length) {
        [[BGHUDHelper sharedInstance] tipMessage:self.textField.placeholder];
        return;
    }

//    [NSString verify_dirty_word:self.textField.text];
    
//    
//    if (self.textView.text.length) {
//        
//        [NSString verify_dirty_word:self.textView.text];
//
//    }
    
    if (self.onPwd) {
        
        if (self.pwdTextField.text.length != 6) {
            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"请输入完整密码")];;
            return;
        }
        
    }
    
//    NSString *url=[[CYURLUtils sharedCYURLUtils]makeVoiceURLWithC:@"voice_api" A:@"save_voice"];

    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
//    [param setObject:self.model.voice.id forKey:@"id"];

    if (StrValid(self.textField.text)) {
        [param setObject:SafeStr(self.textField.text) forKey:@"voice_title"];

    }
    
    if (self.voice_avatar) {
        [param setObject:self.voice_avatar forKey:@"voice_img"];

    }
    
    if (StrValid(self.textView.text)) {
        [param setObject:self.textView.text forKey:@"announcement"];

    }
    
//    if (self.voice_bg) {
//        [param setObject:self.voice_bg forKey:@"voice_bg"];
//    }else{
//        [param setObject:self.set forKey:@"voice_bg"];
//    }
//
//
//    if (self.channelModel) {
//        [param setObject:self.channelModel.id forKey:@"voice_theme_id"];
//
//    }else{
//        
//        [param setObject:self.model.voice.voice_type forKey:@"voice_theme_id"];
//
//    }
    if (self.onPwd) {
        [param setObject:@(self.onPwd) forKey:@"voice_status"];
        [param setObject:self.pwdTextField.text forKey:@"voice_psd"];

    } else {
        [param setObject:@(-1) forKey:@"voice_status"];
        [param setObject:@"" forKey:@"voice_psd"];

    }

    @weakify(self)
    
//    [CYNET POST:url parameters:param responseCache:^(id responseObject) {
//        
//    } success:^(id responseObject) {
//       
//        @strongify(self)
//        
//        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"设置成功")];
//
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//        kAppDelegate.containerVC.roomVc.model.voice.title = self.textField.text;
//        
//        if (StrValid(self.textView.text)) {
//            kAppDelegate.containerVC.roomVc.model.voice.announcement = self.textView.text;
//
//        }
//        if (self.channelModel) {
//            kAppDelegate.containerVC.roomVc.model.voice.voice_type = self.channelModel.id;
//
//        }
//        if (self.voice_bg) {
//            kAppDelegate.containerVC.roomVc.model.voice.voice_bg_image = self.voice_bg_image;
//
//        }
//        kAppDelegate.containerVC.roomVc.model.voice.voice_status = [NSString stringWithFormat:@"%@",@(self.onPwd)];
//        
//        if (self.onPwd) {
//            kAppDelegate.containerVC.roomVc.model.voice.voice_psd = self.pwdTextField.text;
//
//
//        } else {
//            kAppDelegate.containerVC.roomVc.model.voice.voice_psd = @"";
//
//        }
//        
//
//        
//    } failure:^(NSString *error) {
//       
//        [[BGHUDHelper sharedInstance] tipMessage:error];
//
//        
//    } hasCache:NO];
    
    
    
    
}
/*
- (void)saveAvatar {
    
    if (!StrValid(self.voice_avatar)) {
        
        
        
        return;
    }
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/save_voice
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"save_voice"];
    __weak __typeof(self)weakSelf = self;
    [CYNET POSTv2:url parameters:@{@"avatar":self.voice_avatar.length ? self.voice_avatar : @"",@"id":self.model.voice.id} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            [[BGHUDHelper sharedInstance] tipMessage:@"更新成功"];
            //            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSString *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];
    
    
}



- (void)saveTitle {
    if (!self.textField.text.length) {
        [[BGHUDHelper sharedInstance] tipMessage:@"未输入标题"];
        return;
    }
    
    if ([self.textField.text isEqualToString:self.model.voice.title]) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/upd_voice_title
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"save_voice"];
    [CYNET POSTv2:url parameters:@{@"id":self.model.voice.id,@"title":self.textField.text} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [[BGHUDHelper sharedInstance] tipMessage:@"标题修改成功"];
            kAppDelegate.containerVC.roomVc.model.voice.title = strongSelf.textField.text;
            //            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSString *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];
    
    
}

- (void)saveAnnouncement{
    if (!self.textView.text.length) {
        [[BGHUDHelper sharedInstance] tipMessage:@"未输入公告"];
        return;
    }
    if ([self.textView.text isEqualToString:self.model.voice.announcement]) {
        return;
    } //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_Additional_api/upd_announcement
    __weak __typeof(self)weakSelf = self;
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_Additional_api" A:@"upd_announcement"];
    [CYNET POSTv2:url parameters:@{@"id":self.model.voice.id,@"announcement":self.textView.text} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [[BGHUDHelper sharedInstance] tipMessage:@"公告设置成功"];
            kAppDelegate.containerVC.roomVc.model.voice.announcement = self.textView.text;
            
            //            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSString *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];
}
- (void)saveChannel{
    
    if ([self.channelModel.id isEqualToString:self.model.voice.voice_type]) {
        return;
    }
    if (!self.channelModel) {
        return;
    } //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/selected_voice_type
    __weak __typeof(self)weakSelf = self;
    
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"selected_voice_type"];
    [CYNET POSTv2:url parameters:@{@"id":self.model.voice.id,@"voice_type":self.channelModel.id} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            //更换成功
            kAppDelegate.containerVC.roomVc.model.voice.voice_type = self.channelModel.id;
            
        }
    } failure:^(NSString *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];
    
    
}

- (void)savePwd{
    
    __weak __typeof(self)weakSelf = self;
    
    //    if (self.model.voice.voice_status.intValue == self.onPwd && [[self.pwdTextField.text md5] isEqualToString:self.model.voice.voice_psd]) {
    //
    //        return;
    //    }
#warning 后台保存的md5，所以就不判断状态了
    
    //
    
    if (self.onPwd) {
        
        if (self.pwdTextField.text.length < 6) {
            return;
        }
        //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/voice_psd
        NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"voice_psd"];
        [CYNET POSTv2:url parameters:@{@"voice_psd":self.pwdTextField.text,@"id":self.model.voice.id} responseCache:^(id responseObject) {
            //do nothing
        } success:^(id responseObject) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [[BGHUDHelper sharedInstance] tipMessage:@"密码设置成功"];
                //                strongSelf.model.voice.voice_psd = [passwordView.inputView.textValue md5String];
                strongSelf.model.voice.voice_status = @"1";
                //                [passwordView hide];
            }
        } failure:^(NSString *error) {
            //            [[BGHUDHelper sharedInstance] tipMessage:error];
        } hasCache:NO];
        
        
        
        
        
        
    } else {
        
        //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/voice_psd
        NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"voice_psd"];
        [CYNET POSTv2:url parameters:@{@"voice_psd":@"-1",@"id":self.model.voice.id} responseCache:^(id responseObject) {
            //do nothing
        } success:^(id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
                [[BGHUDHelper sharedInstance] tipMessage:@"解除房间锁成功"];
                strongSelf.model.voice.voice_psd = @"";
                strongSelf.model.voice.voice_status = @"0";
            }
        } failure:^(NSString *error) {
            //            [[BGHUDHelper sharedInstance] tipMessage:error];
        } hasCache:NO];
    }
    
    
}

*/
#pragma mark - QMUITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 6;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 120;
        }
        if (indexPath.row == 2 || indexPath.row == 4) {
            return 0.1;
        }
        if (indexPath.row == 3) {
            return 97;
        }
        if (indexPath.row == 1) {
            return  ceil(self.channelDataArray.count/3.0)*65+10*3;
        }
        if (indexPath.row == 5) {
            return 60;
        }
        return 35;
        
    }
    
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            BGRoomSetHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRoomSetHeadCell class]) forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.selectImgBlock = ^{
                
                [self onAlbumAction];
                
            };
            
            if (self.infoModel.live_image) {

                
                
                [cell.iconBtn sd_setImageWithURL:[NSURL URLWithString:SafeStr(self.infoModel.live_image)] forState:UIControlStateNormal];
                cell.iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.iconTipLabel.text = ASLocalizedString(@"更改房间头像");
            }

            self.textField = cell.titleTextField;
            
            if (self.isOpen) {
                
            }else{
                
                if (!StrValid(cell.titleTextField.text)) {
                    cell.titleTextField.text = self.infoModel.title;

                }
                

            }
            
            
            return cell;
            
            
        }
            else  if (indexPath.row == 2 || indexPath.row == 4) {
                SetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SetCell class]) forIndexPath:indexPath];
                cell.hidden = YES;
                return cell;

            }
            else  if (indexPath.row == 3) {
            BGRoomSetNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRoomSetNoticeCell class]) forIndexPath:indexPath];
                cell.textChange = ^(NSString * _Nonnull text) {
                    self.infoModel.announcement = text;
                };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.textView = cell.titleTextView;
            
            if (self.isOpen) {
                
            }else{
                
                if (!StrValid(cell.titleTextView.text)) {
                    cell.titleTextView.text = self.model.announcement;

                }

            }
            
            return cell;
            
        }else  if (indexPath.row == 1) {
            BGRoomSetChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRoomSetChannelCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.channelDataArray = self.channelDataArray;
            
            cell.selectedChannel = ^(VideoClassifiedModel * _Nonnull model) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.channelModel = model;
                self.infoModel.classified_id = [NSString stringWithFormat:@"%ld",(long)model.classified_id];
                NSLog(@"点击的 infoModel %@",self.infoModel.classified_id);
            };
            
            
            cell.voice_type = self.infoModel.classified_id;
 
            return cell;
            
        }else  if (indexPath.row == 5) {
            BGRoomSetPwdCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRoomSetPwdCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.passwordView.txtPassword.text = self.infoModel.password;
            cell.titleTextField.text = self.infoModel.password;
            cell.openBtn.selected = self.infoModel.password.length > 0;
            cell.pwdTextChangeBlock = ^(NSString * _Nonnull text) {
                self.infoModel.password = text;
            };
            cell.pwdStatusBlock = ^(UIButton * _Nonnull sender) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.onPwd = sender.selected;
            };
            self.pwdTextField = cell.titleTextField;

            return cell;
            
        }
        
        
        SetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SetCell class]) forIndexPath:indexPath];
        if (indexPath.row == 2) {
            [cell setLeftTitle:ASLocalizedString(@"Mic mode")];
            
        } else {
            [cell setLeftTitle:ASLocalizedString(@"房间上锁")];
            
        }
        //            [cell setRightTitle:@""];
        [cell setType:SetCellTypeRoomSet];
        
        cell.leftMediumFont = 16;
        
        cell.rightImageView.hidden = YES;
        cell.nextBtn.hidden = YES;
        return cell;
        
        
        
        
        
        
    } else {
        
        
        SetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SetCell class]) forIndexPath:indexPath];
        NSDictionary *dict = self.dataArray[indexPath.row];
        [cell setLeftTitle:dict[@"leftTitle"]];
        [cell setRightTitle:dict[@"rightTitle"]];
        [cell setType:SetCellTypeRoomSet];
        cell.leftMediumFont = 16;

        
        cell.rightImageView.hidden = YES;
        cell.nextBtn.hidden = NO;
        return cell;
        
        
        
    }
    
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0){
            
        }
        
        
        
        
    } else {
        
        
        NSDictionary *dict = self.dataArray[indexPath.row];
        NSString * leftTitle = dict[@"leftTitle"];
        
        if ([leftTitle isEqualToString:ASLocalizedString(@"主持人")]) {
            
            BGRoomManagerViewController * vc = [[BGRoomManagerViewController alloc]init];
            vc.model = self.model;
            vc.name = @"主持人";
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([leftTitle isEqualToString:ASLocalizedString(@"管理员")]){
            BGRoomManagerViewController * vc = [[BGRoomManagerViewController alloc]init];
            vc.model = self.model;
            vc.name = @"管理员";
            BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:vc];
            if (@available(iOS 13.0, *)) {
                UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
                appearance.backgroundColor = [UIColor whiteColor];
                appearance.shadowColor = [UIColor clearColor];
                nav.navigationBar.standardAppearance = appearance;
                nav.navigationBar.scrollEdgeAppearance = appearance;
            }
            [self presentViewController:nav animated:YES completion:nil];
            
        }else if ([leftTitle isEqualToString:ASLocalizedString(@"房间背景")]){
            SetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            BGRoomBGImageViewController * vc = [[BGRoomBGImageViewController alloc]init];
            vc.model = self.model;
            vc.room_id = self.model.room_id;
            if (self.selectModel) {
                vc.selectModel = self.selectModel;
            }
            vc.editRoomBGChangedCallBack = ^(RoomBGImageModel *selectModel) {
                self.selectModel = selectModel;
                self.voice_bg = selectModel.id;
                self.voice_bg_image = selectModel.image;
                if (StrValid(selectModel.name)) {
                    [cell setRightTitle:selectModel.name];

                } else {
                    [cell setRightTitle:ASLocalizedString(@"已选择")];

                }
            };
    
            BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:vc];
            //返回按钮
            
            if (@available(iOS 13.0, *)) {
                UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
                appearance.shadowImage = [UIImage imageWithColor:kWhiteColor];
                [appearance configureWithOpaqueBackground];
                appearance.backgroundColor =  kWhiteColor;
                
                nav.navigationBar.standardAppearance = appearance;
                nav.navigationBar.scrollEdgeAppearance = appearance;
                [nav.navigationBar setShadowImage:nil];
                [nav.navigationBar setShadowImage:[UIImage imageWithColor:kWhiteColor]];
                
                [nav.navigationBar setBackgroundImage:       [UIImage imageWithColor:kWhiteColor] forBarMetrics:UIBarMetricsDefault];
                
                
            } else {
                // Fallback on earlier versions
            }
            
            [self presentViewController:nav animated:NO completion:nil];
            
            
            
            
        }else if ([leftTitle isEqualToString:ASLocalizedString(@"房间数据")]){
            NSString *tmpUrlStr = [NSString stringWithFormat:@"%@?room_id=%@",[GlobalVariables sharedInstance].appModel.h5_url.room_flow,self.model.room_id];
            BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
            BGNavigationController *tmpNav = [[BGNavigationController alloc] initWithRootViewController:tmpController];
            [self presentViewController:tmpNav animated:NO completion:nil];
        }

        
        
        
        
    }
    
    
    
}

- (void)selectImgAtIndexPath:(NSIndexPath *)indexPath {

    self.imageIndexPath = indexPath;
//    [self addPhotoAction];
    
}

- (void)onAlbumAction {
    CYImagePickerViewController *imagePickerVc=[[CYImagePickerViewController alloc]initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:NO];
    [imagePickerVc.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    // 图片
    imagePickerVc.allowPickingVideo = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 0;
    NSInteger widthHeight = self.view.width;
    NSInteger top = (self.view.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.allowCrop = YES;
    __block typeof(self)blockself =self;
    // 你可以通过block或者代理，来得到用户选择的照片.
    @weakify(self)

    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if(photos.count >0){
            @strongify(self)
            [self addImageDone:photos.firstObject];
        }
    }];
    imagePickerVc.naviTitleColor = [UIColor blackColor];;
    imagePickerVc.barItemTextColor = [UIColor blackColor];
    [blockself presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhotoAction{
    
   

    
}

- (void)addImageDone:(UIImage *)image {
    
 

    
    [[FDHUDManager defaultManager] showLoading:@"正在上传" ToView:self.view];
    [[FDOSSManager defaultManager] setup:^{
        [[FDOSSManager defaultManager] UPLOAD:UIImagePNGRepresentation(image) progress:^(float percent) {
            NSLog(@"上传进度:%f",percent);
        } success:^(NSString * _Nonnull resultStr) {
            self.infoModel.live_image = resultStr;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];

                [[FDHUDManager defaultManager] hideLoading];
                
            });
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FDHUDManager defaultManager] show:error.localizedDescription ToView:self.view];
            });
        }];
    }];
    return;
    

    @weakify(self)
    
//    if (KGlobalVariable.appmodel.upload_type.intValue == 1) {
//        [QiNiuLogic QiNiuUplaodImage:image WithQiuNiuInfo:_qiniuInfo Block:^(id selfPtr) {
//            NSLog(@"selfPtr:%@",selfPtr);
//            @strongify(self)
//            self.voice_avatar = [NSString stringWithFormat:@"%@/%@",self.qiniuInfo.domain,((QiNiuInfoModel *)selfPtr).fileKey];
//        }];
//    } else if (KGlobalVariable.appmodel.upload_type.intValue == 2){
//        [QCloudCOSLogic getQCloudCOSTokenSuccess:^(id object) {
//            QCloudCOSInfoModel *qInfo = object;
//            
//            [QCloudCOSLogic QCloudCOSUploadImage:image WithQCloudCOSInfo:qInfo Block:^(id object) {
//                @strongify(self)
//                QCloudUploadObjectResult * uploadResult = object;
//                self.voice_avatar = uploadResult.location;
//                
//            }];
//            
//            
//        }];
//    }
    
    

}
- (void)requestData{
    
    
//    NSDictionary *dict = self.dataArray[2];
//    NSString * leftTitle = dict[@"leftTitle"];
    
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/get_voice_bg
//    NSString *url = [[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"Voice_api" A:@"get_voice_bg"];
//    [CYNET POSTv2:url parameters:@{@"id":StrValid(self.model.voice.id)?self.model.voice.id : [IMAPlatform sharedInstance].host.userId} responseCache:^(id responseObject) {
//        //do nothing
//    } success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            for (NSDictionary *dict in responseObject[@"voice_bg_list"]) {
//                RoomBGImageModel *model = [RoomBGImageModel mj_objectWithKeyValues:dict];
//                if ([model.image isEqualToString:SafeStr(self.model.voice.voice_bg_image)]) {
//                    model.selected = YES;
//                    strongSelf.selectModel = model;
//                    
//                    [strongSelf.dataArray replaceObjectAtIndex:2 withObject:@{@"leftTitle":ASLocalizedString(@"房间背景"),@"rightTitle":model.name ? model.name :ASLocalizedString(@"已选择")}];
//                    
//                }
//            }
//            [strongSelf.tableView reloadData];
//        }
//    } failure:^(NSString *error) {
//        [[BGHUDHelper sharedInstance] tipMessage:error];
//    } hasCache:NO];
}

/*
- (void)selectImgAtIndexPathdddd:(NSIndexPath *)indexPath {
    
    
    CYImagePickerViewController *imagePickerVc = [[CYImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    imagePickerVc.naviBgColor = [UIColor blackColor];
    imagePickerVc.allowPickingVideo = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 0;
    NSInteger widthHeight = self.view.width;
    NSInteger top = (self.view.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.allowCrop = YES;
    __weak __typeof(self)weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        BGRoomSetHeadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //                [cell.middleImageView setImage:photos.firstObject];
        [cell.iconBtn setBackgroundImage:photos.firstObject forState:UIControlStateNormal];
        [cell.iconBtn setImage:nil forState:UIControlStateNormal];

        __strong __typeof(weakSelf)strongSelf = weakSelf;
        __weak __typeof(strongSelf)weakSelf2 = strongSelf;
        [QiNiuLogic QiNiuUplaodImage:photos.firstObject WithQiuNiuInfo:_qiniuInfo Block:^(id selfPtr) {
            NSLog(@"selfPtr:%@",selfPtr);
            __strong __typeof(weakSelf2)strongSelf2 = weakSelf2;
            strongSelf2.voice_avatar = [NSString stringWithFormat:@"%@/%@",self.qiniuInfo.domain,((QiNiuInfoModel *)selfPtr).fileKey];
        }];
    }];
    imagePickerVc.naviTitleColor = [UIColor blackColor];
    imagePickerVc.barItemTextColor =  [UIColor blackColor];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor blackColor];
    imagePickerVc.showSelectBtn = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
    
}
*/

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)channelDataArray{
    _channelDataArray = [NSMutableArray array];
    for (VideoClassifiedModel *model in self.BuguLive.appModel.video_classified) {
        if(model.classified_id == self.infoModel.classified_id.intValue)
        {
            model.isSelected = YES;
        }
        else
        {
            model.isSelected = NO;
        }
        [_channelDataArray addObject:model];
    }
    return _channelDataArray;
}

- (void)postButtonAction {
    NSDictionary *info = [self.infoModel mj_JSONObject];
    NSLog(@"提交信息");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"save_voice" forKey:@"act"];
    [dict setValue:self.model.room_id forKey:@"room_id"];
    [dict addEntriesFromDictionary:info];
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"保存成功")];
        
    } FailureBlock:^(NSError *error) {
    }];
}
@end
