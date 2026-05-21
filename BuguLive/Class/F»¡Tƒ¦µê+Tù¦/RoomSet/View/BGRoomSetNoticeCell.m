//
//  BGRoomSetNoticeCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomSetNoticeCell.h"
#import "UIFont+Ext.h"

@implementation BGRoomSetNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}



- (void)initUI {

    self.bgImageView = ({
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView;
    });
    ViewRadius(self.bgImageView, 10);
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    self.bgImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
      _titleLabel= ({
                UILabel * label = [[UILabel alloc]init];
                label.textColor = kAppGrayColor1;
                label.font = UIFont.bg_mediumFont16;
                label.text = ASLocalizedString(@"房间公告");
                label.hidden = YES;
    //            label.textAlignment = NSTextAlignmentCenter;
                label;
            });
        
    
    _titleTextView = ({
        QMUITextView * textView = [[QMUITextView alloc]init];
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholder = ASLocalizedString(@"请设置房间公告");
        textView.placeholderColor = [UIColor colorWithHexString:@"#999999"];
        textView.font = [UIFont systemFontOfSize:16];
        
        textView.textColor = kWhiteColor;
        textView.layer.cornerRadius = 8;
                  textView.clipsToBounds = YES;
        textView.textContainerInset = UIEdgeInsetsMake(13, 16, 13, 16);
        //监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:textView];
        textView;
    });
    
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_titleTextView];

}

- (void)textDidChange:(NSNotification *)notification {
    if(self.textChange)
    {
        self.textChange(self.titleTextView.text);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(20);
           make.top.mas_equalTo(10);
       }];
//    [_titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.left.equalTo(_titleLabel);
//           make.top.equalTo(_titleLabel.mas_bottom).offset(10);
//           make.height.mas_equalTo(75);
//        make.centerX.mas_equalTo(0);
//       }];
    [_titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
}

@end
