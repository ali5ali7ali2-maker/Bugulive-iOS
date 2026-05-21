//
//  VoicePeopleTagView.h
//  BuguLive
//
//  Created by voidcat on 2024/9/24.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoicePeopleTagView : UICollectionViewCell

@property(nonatomic, strong) NSString *peopleName;
@property(nonatomic, assign) BOOL cellSelected;

@end

NS_ASSUME_NONNULL_END
