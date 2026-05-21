// Copyright (c) 2019 Tencent. All rights reserved.

#ifndef SDKHeader_h
#define SDKHeader_h

#import "TXLiteAVSDK.h"

#define ASLocalizedString(key)  [NSString stringWithFormat:@"%@", [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"ASLocalized"]]



#endif /* SDKHeader_h */
