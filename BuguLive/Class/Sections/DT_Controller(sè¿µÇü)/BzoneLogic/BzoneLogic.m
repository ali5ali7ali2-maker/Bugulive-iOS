//
//  BzoneLogic.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/4/22.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BzoneLogic.h"
//#import "YHWorkGroup.h"

#import "MGGroupUserInfo.h"
#import "BGSystemMsgModel.h"

@implementation BzoneLogic

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 0;
        _dataArray = [NSMutableArray array];
        _topicArr = [NSMutableArray array];
    }
    return self;
}

-(void)loadListDataWithAct:(MGDTHOMETYPE)act
{
//    if (_page == 1) {
//        [_dataArray removeAllObjects];
//    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    
    NSString *actStr = @"";
    if (act == MGDTHOMETYPE_CONCERT) {
        actStr = @"follow_index";
    }else if (act == MGDTHOMETYPE_NEARBY) {
        actStr = @"index";
        [parmDict setObject:@"fujin" forKey:@"list_type"];
    }else if (act == MGDTHOMETYPE_RECOMMAND) {
        actStr = @"index";
        [parmDict setObject:@"" forKey:@"list_type"];
    }else if (act == MGDTHOMETYPE_MY) {
        actStr = @"my_index";
        [parmDict setObject:self.to_uid forKey:@"touid"];
    }else if (act == MGDTHOMETYPE_VIDEO){
        actStr = @"index";
        [parmDict setObject:@"video" forKey:@"list_type"];
    }
    [parmDict setObject:actStr forKey:@"act"];
    
    [parmDict setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"p"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if (_page == 1) {
            [_dataArray removeAllObjects];
            _noHasMore = NO;
        }
        
        NSArray *arr = responseJson[@"list"];
        if ([arr isKindOfClass:[NSArray class]])
        {
            if (arr.count > 0)
            {
                for (NSDictionary *dic in arr)
                {
                    MGGroupUserInfo *model = [MGGroupUserInfo mj_objectWithKeyValues:dic];
                    model.bottomViewSelect = YES;
                    [self.dataArray addObject:model];
                }
            }
        }
        
        
        
//        NSArray *list = [NSArray modelArrayWithClass:[YHWorkGroup class] json:[[responseJson valueForKey:@"data"] valueForKey:@"list"]];
//        [_dataArray addObjectsFromArray:list];
        if(_dataArray.count == 0)
        {
            _noHasMore = YES;
        }
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestZoneListDataCompleted)]) {
            [self.delegagte requestZoneListDataCompleted];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)loadListDataWiththeme:(NSString *)theme{
       if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"dynamic" forKey:@"ctl"];
      
        [parmDict setObject:@"index" forKey:@"act"];

        [parmDict setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"p"];
    
        [parmDict setObject:theme forKey:@"theme"];

        
        FWWeakify(self)
        
        [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if (_page == 1) {
                [_dataArray removeAllObjects];
                _noHasMore = NO;
            }
            
            NSArray *arr = responseJson[@"list"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (arr.count > 0)
                {
                    for (NSDictionary *dic in arr)
                    {
                        MGGroupUserInfo *model = [MGGroupUserInfo mj_objectWithKeyValues:dic];
                        model.bottomViewSelect = YES;
                        [self.dataArray addObject:model];
                    }
                }
            }
            
            
            
    //        NSArray *list = [NSArray modelArrayWithClass:[YHWorkGroup class] json:[[responseJson valueForKey:@"data"] valueForKey:@"list"]];
    //        [_dataArray addObjectsFromArray:list];
            if(_dataArray.count == 0)
            {
                _noHasMore = YES;
            }
            if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestZoneListDataCompleted)]) {
                [self.delegagte requestZoneListDataCompleted];
            }
        } FailureBlock:^(NSError *error) {
            
        }];
}

-(void)loadListData2With:(BOOL)isgz
{
//    if (_page == 1) {
//        [_dataArray removeAllObjects];
//    }
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@(_page) forKey:@"page"];
//    [param setObject:SafeStr(self.to_uid) forKey:@"cid"];
//    
//    //获取推荐列表one_api/get_list;获取关注列表one_api/get_attention_list
//    NSString *url ;
//    url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"bzone_api" A:@"get_list_3x"];
//    if (isgz)
//    {
//        [param setObject:@"att" forKey:@"action"];
//    }else{
//        [param setObject:@"out" forKey:@"action"];
//    }
//    
//    UserInfo *infoModel = curUser;
//    [param setObject:infoModel.id forKey:@"uid"];
//    
//    [CYNET POSTv3:url parameters:param responseCache:^(id responseObject) {
//        
//    } success:^(id responseObject) {
//        if (_page == 1) {
//            [_dataArray removeAllObjects];
//            _noHasMore = NO;
//        }
//        NSArray *list = [NSArray modelArrayWithClass:[YHWorkGroup class] json:[[responseObject valueForKey:@"data"] valueForKey:@"list"]];
//        [_dataArray addObjectsFromArray:list];
//        if(_dataArray.count == 0)
//        {
//            _noHasMore = YES;
//        }
//        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestZoneListDataCompleted)]) {
//            [self.delegagte requestZoneListDataCompleted];
//        }
//    } failure:^(NSString *error, NSInteger code) {
//        [[HUDHelper sharedInstance] tipMessage:error];
//        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestZoneListDataCompleted)]) {
//            [self.delegagte requestZoneListDataCompleted];
//        }
//    } hasCache:YES];
    
}

-(void)addDolikeID:(NSString *)rid isLike:(BOOL)isLike Success:(CommonCompletionBlock)block{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"praise" forKey:@"act"];
    
    [parmDict setObject:rid forKey:@"dynamic_id"];
    NSString *like = isLike ? @"1" : @"2";
    [parmDict setObject:like forKey:@"is_praise"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
//        [self.logic.dataArray replaceObjectAtIndex:cell.indexPath.row withObject:model];
        if ([[responseJson valueForKey:@"is_like"]integerValue] == 1) {
            block([responseJson valueForKey:@"count"],YES);
        }else if ([[responseJson valueForKey:@"is_like"]integerValue] == 0) {
             block([responseJson valueForKey:@"count"],NO);
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(void)loadReplyListWhidZoneID:(NSString *)zone_id{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"get_comments" forKey:@"act"];
    
    [parmDict setObject:zone_id forKey:@"dynamic_id"];

    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray *list = responseJson[@"list"];
        NSMutableArray *arr = [NSMutableArray array];
        
        if ([list isKindOfClass:[NSArray class]])
        {
            if (list.count > 0)
            {
                for (NSDictionary *dic in list)
                {
                    MGGroupUserInfo *model = [MGGroupUserInfo mj_objectWithKeyValues:dic];
                    [arr addObject:model];
                }
            }
        }

        
        if([self.delegagte respondsToSelector:@selector(requestZoneReplyListDataCompletedWhih:)])
        {
            [self.delegagte requestZoneReplyListDataCompletedWhih:arr];
        }
    
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

//发布动态

-(void)addDynamicContent:(NSString *)content WithImage:(NSArray *)imageArr andVideoPaht:(NSString *)path cover_url:(NSString *)cover_url audio:(NSString *)audio audio_seconds:(NSString *)audio_seconds Success:(CommonBoolCompletionBlock)block
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"release" forKey:@"act"];
    
    [parmDict setObject:content forKey:@"content"];
    [parmDict setObject:audio forKey:@"audio"];
    [parmDict setObject:path forKey:@"video"];
    [parmDict setObject:cover_url forKey:@"cover_url"];//视频封面地址
    if (imageArr.count > 0) {
        [parmDict setObject:[imageArr componentsJoinedByString:@","] forKey:@"img"];
    }else{
        [parmDict setObject:@"" forKey:@"img"];
    }
    
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        //        [self.logic.dataArray replaceObjectAtIndex:cell.indexPath.row withObject:model];
        if ([[responseJson valueForKey:@"status"] integerValue] == 0) {
            [[BGHUDHelper sharedInstance]tipMessage:[responseJson valueForKey:@"error"]];
            block(NO);
        }else if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"发布成功")];
            block(YES);
        }
        
        
    } FailureBlock:^(NSError *error) {
        block(NO);
    }];
}
-(void)addDynamicType:(NSInteger)type content:(NSString *)content media:(NSArray *)mediaArr cover_url:(NSString *)cover_url no_name:(NSInteger)no_name themeID:(NSString *)themeID address:(NSString *)address media_attr:(NSString *)media_attr at:(NSString *)at  shop_id:(NSString *)shop_id shop_title:(NSString *)shop_title Success:(CommonBoolCompletionBlock)block{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"release" forKey:@"act"];
    
    [parmDict setObject:@(type) forKey:@"type"];
    [parmDict setObject:content forKey:@"content"];
    if (mediaArr.count > 0) {
        [parmDict setObject:[mediaArr componentsJoinedByString:@","] forKey:@"media"];
    }else{
        [parmDict setObject:@"" forKey:@"media"];
    }
    [parmDict setObject:cover_url forKey:@"cover_url"];//视频封面地址
    [parmDict setObject:@(no_name) forKey:@"no_name"];
    if ([BGUtils isBlankString:themeID]) themeID = @"";
    [parmDict setObject:themeID forKey:@"theme"];
    [parmDict setObject:address forKey:@"address"];
    [parmDict setObject:media_attr forKey:@"media_attr"];
    [parmDict setObject:at forKey:@"at"];
    [parmDict setObject:shop_id forKey:@"shop_id"];
    [parmDict setObject:shop_title forKey:@"shop_title"];
    
    

    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        //        [self.logic.dataArray replaceObjectAtIndex:cell.indexPath.row withObject:model];
        if ([[responseJson valueForKey:@"status"] integerValue] == 0) {
            [[BGHUDHelper sharedInstance]tipMessage:[responseJson valueForKey:@"error"]];
            block(NO);
        }else if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"发布成功")];
            block(YES);
        }
    } FailureBlock:^(NSError *error) {
        block(NO);
    }];
}

//发表评论
-(void)addDynamicReplyID:(NSString *)rid WihtiContent:(NSString *)content adnAudio:(NSString *)audioPath Success:(CommonVoidBlock)block{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"set_comments" forKey:@"act"];
    
    [parmDict setObject:rid forKey:@"dynamic_id"];
    [parmDict setObject:content forKey:@"content"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            block();
        }else{
            [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

//转发动态

-(void)dynamicForwardWithDynamic_id:(NSString *)dynamic_id Success:(CommonVoidBlock)block{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"dynamic_forwarding" forKey:@"act"];
    
    [parmDict setObject:dynamic_id forKey:@"dynamic_id"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            block();
        }else{
            [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
        }
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

//删除动态

-(void)delZone:(NSString *)rid Success:(CommonVoidBlock)block{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"del_dynamic" forKey:@"act"];
    
    [parmDict setObject:rid forKey:@"dynamic_id"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            block();
        }else{
            [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)addFollowUID:(NSString *)uid Success:(CommonVoidDicBlock)block{
   
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
      [parmDict setObject:@"user" forKey:@"ctl"];
      [parmDict setObject:@"follow" forKey:@"act"];
      [parmDict setObject:uid forKey:@"to_user_id"];
          
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
                   block(responseJson);
               }else{
                   [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
               }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
//获取话题接口
-(void)dynamicGetTopicModelWithUID:(NSString *)uid Success:(CommonVoidDicBlock)block
{
    self.topicArr = [NSMutableArray array];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"dynamic_theme" forKey:@"act"];
    [parmDict setObject:@"lib" forKey:@"itype"];
    [parmDict setObject:uid forKey:@"uid"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            block(responseJson);
        }else{
            [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}



-(void)loadMsg_ListData
{
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"msg_list" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"p"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if (_page == 1) {
            [_dataArray removeAllObjects];
            _noHasMore = NO;
        }
        
        NSArray *arr = responseJson[@"list"];
        if ([arr isKindOfClass:[NSArray class]])
        {
            if (arr.count > 0)
            {
                for (NSDictionary *dic in arr)
                {
                    BGSystemMsgModel *model = [BGSystemMsgModel mj_objectWithKeyValues:dic];
                    [self.dataArray addObject:model];
                }
            }
        }
        
        
        
//        NSArray *list = [NSArray modelArrayWithClass:[YHWorkGroup class] json:[[responseJson valueForKey:@"data"] valueForKey:@"list"]];
//        [_dataArray addObjectsFromArray:list];
        if(_dataArray.count == 0)
        {
            _noHasMore = YES;
        }
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestZoneListDataCompleted)]) {
            [self.delegagte requestZoneListDataCompleted];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}


-(void)fetchUnRead_MsgSuccess:(CommonVoidDicBlock)block{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    
      [parmDict setObject:@"dynamic" forKey:@"ctl"];
               
                 
    [parmDict setObject:@"index" forKey:@"act"];

                 
    [parmDict setObject:@"1" forKey:@"p"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
                   block(responseJson);
               }else{
                   [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
               }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

@end
