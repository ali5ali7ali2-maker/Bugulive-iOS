//
//  GuiZuModel.h
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuiZuModel : NSObject

@end


@interface GuiZuRightsModel : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *imageSelected;

@property(nonatomic, assign) BOOL has;

@end


NS_ASSUME_NONNULL_END
