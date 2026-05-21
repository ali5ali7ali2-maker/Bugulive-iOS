//
//  CountryPopupView.h
//  BuguLive
//
//  Created by voidcat on 2024/9/21.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountryPopupView;

@protocol CountryPopupViewDelegate <NSObject>

- (void)countryPopupView:(CountryPopupView *)popupView didSelectCountry:(NSDictionary *)country;

@end

@interface CountryPopupView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id<CountryPopupViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame countries:(NSArray *)countries;

@end
