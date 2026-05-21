//
//  ChatEmojiIcons.m
//  BuguLive
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatEmojiIcons.h"

@implementation ChatEmojiIcons

//获取表情包
+ (NSArray *)emojis {
    static NSArray *_emojis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[[NSBundle mainBundle] resourcePath] 
                          stringByAppendingPathComponent:@"Emoji.plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 1; i < 105; i++) {
            [array addObject:[dic valueForKey:[NSString stringWithFormat:@"[em_%@]", @(i)]]];
        }
        _emojis = array;
    });
    return _emojis;
}

+ (NSInteger)getEmojiPopCount
{
    return [[self class] emojis].count;
}

+ (NSString *)getEmojiNameByTag:(NSInteger)tag
{
    NSArray *emojis = [[self class] emojis];
    if (tag >= emojis.count) return nil;
    return emojis[tag];
}

+ (NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag
{
    NSString *name = [[self class] getEmojiNameByTag:tag];
    return [[self class] imgNameWithName:name];
}

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag
{
    NSString *key = [NSString stringWithFormat:@"%@", [self getEmojiNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+ (NSString *)imgNameWithName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@", name];
}

@end
