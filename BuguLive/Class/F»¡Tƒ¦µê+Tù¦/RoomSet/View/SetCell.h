//
//  SetCell.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/5.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SetCellType) {
    SetCellTypeSet,
    SetCellTypeRoom,
    SetCellTypeRoomSet
};

@interface SetCell : UITableViewCell

@property(nonatomic, copy) NSString *leftTitle;
@property(nonatomic, copy) NSString *rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;

@property(nonatomic, assign) SetCellType type;


//默认 16
@property(nonatomic, assign) NSInteger leftFont;
//默认 13
@property(nonatomic, assign) NSInteger rightFont;


@property(nonatomic, assign) NSInteger leftMediumFont;



@end

NS_ASSUME_NONNULL_END
