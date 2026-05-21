//
//  RedPacketView.h
//  UniversalApp
//
//  Created by voidcat on 2024/10/11.
//  Copyright © 2024 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//openButtonTapped
@protocol RedPacketViewDelegate <NSObject>
- (void)openButtonTapped;
@end
@interface RedPacketView : UIView
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *openButton;
- (instancetype)initWithAvatarImage:(NSString *)avatarImage nickname:(NSString *)nickname;
- (void)showInView:(UIView *)view;
@property(nonatomic, strong) CustomMessageModel *customMessageModel;
@property (nonatomic, weak) id<RedPacketViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
