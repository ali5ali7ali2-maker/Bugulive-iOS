//
//  MultipleFileUploads.m
//  BuguLive
//
//  Created by 志刚杨 on 2020/6/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MultipleFileUploads.h"
@implementation MultipleFileUploadsModel

@end
@implementation MultipleFileUploads

-(void)uploadFile:(NSArray<MultipleFileUploadsModel *> *)fileArr done:(uploadsDone)block;
{
    
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *urlArr = [NSMutableArray array];
    for (MultipleFileUploadsModel *model in fileArr) {
        
        dispatch_group_enter(group);

        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];

            [parmDict setObject:@"upload_file" forKey:@"ctl"];
            [parmDict setObject:@"upload_video_file" forKey:@"act"];
            
            [[NetHttpsManager manager] POSTWithDict:parmDict andFileData:model.data AndFileName:model.fileName SuccessBlock:^(NSDictionary *responseJson) {
                dispatch_group_leave(group);
                NSLog(ASLocalizedString(@"id %@  上传成功，信息 %@"),model.fileName,responseJson);
                if([responseJson toInt:@"status"] == 0)
                {
                    
                }
                else
                {
                    [urlArr addObject:responseJson[@"server_full_path"]];
                }
            } FailureBlock:^(NSError *error) {
                NSLog(ASLocalizedString(@"id %@  上传失败，信息 %@"),model.fileName,error);
                dispatch_group_leave(group);
            }];

        });
                
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(ASLocalizedString(@"任务均完成，刷新界面"));
      
        block(urlArr);

    });
}

@end
