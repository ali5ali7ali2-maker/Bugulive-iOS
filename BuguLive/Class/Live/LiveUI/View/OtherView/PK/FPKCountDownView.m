//
//  FPKCountDownView.m
//  BuguLive
//
//  Created by bogokj on 2019/4/2.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "FPKCountDownView.h"

@implementation FPKCountDownView{
    UILabel *labTimer;//定时器
    NSTimer *timer;
    UIImageView *pkImage;
    UIImageView *pkDdate;
    //2020-1-3 修改倒计时
    UIButton *timeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame liveItem:(nonnull id<FWShowLiveRoomAble>)liveItem{
    if (self = [super initWithFrame:frame]) {
        _liveItem = liveItem;
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    timeBtn=[[UIButton alloc]init];
    [timeBtn setImage:[UIImage imageNamed:@"PK中"] forState:UIControlStateNormal];
    timeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [timeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    timeBtn.frame=CGRectMake(kScreenW/2-40, 0, 80, 20);
    [self addSubview:timeBtn];
    
    timeBtn.backgroundColor=[kBlackColor colorWithAlphaComponent:0.8];
    timeBtn.layer.cornerRadius=10;
    timeBtn.layer.masksToBounds=YES;
    labTimer = [[UILabel alloc] init];
    labTimer.textColor = kWhiteColor;
    labTimer.text = @"";
    labTimer.font = [UIFont systemFontOfSize:12];
    //    _countDown = 60;
    FWWeakify(self)
    timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        FWStrongify(self)
        if(_countDown == 0)
        {
            [timer invalidate];
            timer = nil;
            [timeBtn setTitle:@"00:00" forState:UIControlStateNormal];
            labTimer.text = [NSString stringWithFormat:ASLocalizedString(@"0秒")];
            if (_liveItem.liveHost.imUserId.integerValue == [IMAPlatform sharedInstance].host.userId.integerValue) {
                //主播
                //            ctl=pk&act=punishment_time
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];

                if(![GlobalVariables sharedInstance].openAgora)
                {
                    [dict setObject:@"pk_tencent" forKey:@"ctl"];
                }
                else
                {
                    [dict setObject:@"pk_agora" forKey:@"ctl"];
                }
                
                [dict setObject:@"punishment_time_user" forKey:@"act"];
                [dict setObject:_pkid.length ? _pkid : @"" forKey:@"pk_id"];
                [dict setObject:[IMAPlatform sharedInstance].host.imUserId forKey:@"user_id"];
                [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                    if ([responseJson toInt:@"status"] == 1) {
                        NSLog(@"%s\n%@",__func__,responseJson);
                        //自己进入惩罚时间
                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:kPKChangeToPunish object:responseJson];
                        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                        if(![GlobalVariables sharedInstance].openAgora)
                        {
                            [mDict setObject:@"pk_tencent" forKey:@"ctl"];
                        }
                        else
                        {
                            [mDict setObject:@"pk_agora" forKey:@"ctl"];
                        }
                        
                        [mDict setObject:@"request_get_pk_info2" forKey:@"act"];
                        [mDict setObject:_pkid.length ? _pkid : @""  forKey:@"pk_id"];
                        NSDictionary *dic1 = responseJson;
                        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                            if ([responseJson toInt:@"status"] == 1 || [responseJson toInt:@"status"] == 2) {
                                NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:responseJson];
                                [dic2 addEntriesFromDictionary:dic1];
                                [[NSNotificationCenter defaultCenter] postNotificationName:kPKChangeToPunish object:dic2];
                                NSLog(ASLocalizedString(@"主播request_get_pk_info2:%@"),responseJson);
                            }
                        } FailureBlock:^(NSError *error) {
                            //do nothing;
                        }];
                        //发送给观众消息
                        //                    "status": 1,
                        //                    "error": "",
                        //                    "win_user_id": '获胜者',
                        //                    "time": '惩罚时间',
                        //                    "act": "punishment_time_user",
                        //                    "ctl": "pk_new"
                        //                    SendCustomMsgModel *model = [[SendCustomMsgModel alloc]init];
                        //                    model.status = 3;
                        //                    model.win_user_id = responseJson[@"win_user_id"];
                        //                    model.time = responseJson[@"time"];
                        //                    model.pk_ticket1 = responseJson[@"pk_ticket1"];
                        //                    model.pk_ticket2 = responseJson[@"pk_ticket2"];
                        //
                        //                    model.msgType = MSG_END_PK;
                        //                    model.chatGroupID = [_liveItem liveIMChatRoomId];
                        //                    [[BGIMMsgHandler sharedInstance] sendCustomGroupMsg:model succ:^{
                        //                        NSLog(ASLocalizedString(@"punishment_time_user 消息发送成功"));
                        //                    } fail:^(int code, NSString *msg) {
                        //                        NSLog(ASLocalizedString(@"punishment_time_user 消息发送失败"));
                        //                    }];
                    }
                } FailureBlock:^(NSError *error) {
                    //do nothing
                }];
            }else{
                //                act = "request_get_pk_info2";
                //                "create_time" = 1555728928;
                //                ctl = "pk_new";
                //                "emcee_user_id1" = 10109;
                //                "emcee_user_id2" = 10103;
                //                "group_id1" = 32388;
                //                "group_id2" = 32379;
                //                "has_focus1" = 0;
                //                "has_focus2" = 0;
                //                "head_image1" = "";
                //                "head_image2" = "";
                //                id = 46;
                //                "pk_ticket1" = 0;
                //                "pk_ticket2" = 0;
                //                "pk_time" = 60;
                //                "play_url1" = "rtmp://pull.70tr9.com/live/43062_32388b10109_d62a84db30401e6f63cd";
                //                "play_url2" = "rtmp://pull.70tr9.com/live/43062_32379b10103_97bf911fb3060b08ef10";
                //                status = 1;
                //                time = 1;
                //观众
                
                //            ctl=pk&act=punishment_time
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                if(![GlobalVariables sharedInstance].openAgora)
                {
                    [dict setObject:@"pk_tencent" forKey:@"ctl"];
                }
                else
                {
                    [dict setObject:@"pk_agora" forKey:@"ctl"];
                }
                

                [dict setObject:@"punishment_time_user" forKey:@"act"];
                [dict setObject:_pkid.length ? _pkid : @""  forKey:@"pk_id"];
                
                [dict setObject:[IMAPlatform sharedInstance].host.imUserId forKey:@"user_id"];
                [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                    if ([responseJson toInt:@"status"] == 1) {
                        NSLog(@"%s\n%@",__func__,responseJson);
                        //自己进入惩罚时间
                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:kPKChangeToPunish object:responseJson];
                        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                        if(![GlobalVariables sharedInstance].openAgora)
                        {
                            [mDict setObject:@"pk_tencent" forKey:@"ctl"];
                        }
                        else
                        {
                            [mDict setObject:@"pk_agora" forKey:@"ctl"];
                        }
                        
                        [mDict setObject:@"request_get_pk_info2" forKey:@"act"];
                        [mDict setObject:_pkid.length ? _pkid : @""  forKey:@"pk_id"];
                        NSDictionary *dic1 = responseJson;
                  
                        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                            if ([responseJson toInt:@"status"] == 1 || [responseJson toInt:@"status"] == 2) {
                                
                                NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:responseJson];
                                [dic2 addEntriesFromDictionary:dic1];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:kPKChangeToPunish object:dic2];
                                NSLog(ASLocalizedString(@"观众request_get_pk_info2:%@"),dic2);
                            }
                        } FailureBlock:^(NSError *error) {
                            //do nothing;
                        }];
                        
                 
                    }
                } FailureBlock:^(NSError *error) {
                    //do nothing
                }];
  
            }
        }
        else
        {
            _countDown--;
            [timeBtn setTitle:[self timeFormatted:_countDown] forState:UIControlStateNormal];
            labTimer.text = [NSString stringWithFormat:ASLocalizedString(@"%d秒"),_countDown];
        }
    } repeats:YES];
 
//    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@60);
//        make.height.equalTo(@20);
//        make.top.equalTo(self);
//        make.centerX.equalTo(self);
//    }];
    pkDdate = [[UIImageView alloc] init];
    pkDdate.image = [UIImage imageNamed:@"pkda"];
    pkDdate.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:pkDdate];
    
    [pkDdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@38);
        make.height.equalTo(@38);
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];

    [pkDdate addSubview:labTimer];

    [labTimer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pkDdate);
        make.bottom.equalTo(pkDdate).offset(-3);
    }];
    if ([_pktype isEqualToString:@"cf"]) {
        pkDdate.hidden=NO;
        labTimer.hidden=NO;
        timeBtn.hidden=YES;
    }else{
        pkDdate.hidden=YES;
        labTimer.hidden=YES;
        timeBtn.hidden=NO;
    }
}
-(void)setPktype:(NSString *)pktype{
    _pktype=pktype;
    if ([_pktype isEqualToString:@"cf"]) {
        pkDdate.hidden=NO;
        labTimer.hidden=NO;
        timeBtn.hidden=YES;
    }else{
        pkDdate.hidden=YES;
        labTimer.hidden=YES;
        timeBtn.hidden=NO;
    }
}

- (void)switchToPunish:(int)time{
    _countDown = time;
    [self startTimer];
}

- (void)stopTimer {
    [timer invalidate];
    timer = nil;
}

- (void)startTimer{
    [timer invalidate];
    timer = nil;
    FWWeakify(self)
    timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        FWStrongify(self)
        if(_countDown == 0)
        {
            [timer invalidate];
            timer = nil;
            [timeBtn setTitle:ASLocalizedString(@"结束")forState:UIControlStateNormal];

            labTimer.text = [NSString stringWithFormat:ASLocalizedString(@"结束")];
            if ([_pktype isEqualToString:@"cf"]) {
                pkDdate.hidden=NO;
                labTimer.hidden=NO;
                timeBtn.hidden=YES;
            }else{
                pkDdate.hidden=YES;
                labTimer.hidden=YES;
                timeBtn.hidden=NO;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endPunish" object:nil];
        }
        else
        {
            _countDown--;
            [timeBtn setTitle:[self timeFormatted:_countDown] forState:UIControlStateNormal];
            [timeBtn setImage:[UIImage imageNamed:@"PK中"] forState:UIControlStateNormal];
            labTimer.text = [NSString stringWithFormat:ASLocalizedString(@"%d秒"),_countDown];
            [pkDdate setImage:[UIImage imageNamed:@"bg_pk_punish_time"]];
        }
    } repeats:YES];
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([FPKCountDownView class]));
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (NSString *)timeFormatted:(int)totalSeconds

{

int seconds = totalSeconds % 60;

int minutes = (totalSeconds / 60) % 60;

return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

}

@end
