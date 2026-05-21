//
//  BogoGuideView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/19.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoGuideFirstView.h"

@implementation BogoGuideFirstView

- (void)awakeFromNib{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
     
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    self.appIcon.image = [UIImage imageNamed:icon];

}

@end
