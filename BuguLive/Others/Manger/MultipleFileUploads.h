//
//  MultipleFileUploads.h
//  BuguLive
//
//  Created by 志刚杨 on 2020/6/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MultipleFileUploadsModel :NSObject
@property(nonatomic, strong) NSString *fileName;
@property(nonatomic, strong) NSData *data;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MultipleFileUploads : NSObject
typedef void (^uploadsDone)(NSArray<NSString *> *urlArr);
-(void)uploadFile:(NSArray<MultipleFileUploadsModel *> *)fileArr done:(uploadsDone)block;
//@property(nonatomic, copy) uploadsDone *block;
@end

NS_ASSUME_NONNULL_END
