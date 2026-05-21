#import "TYTabTitleViewCell.h"
@interface TYTabTitleViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end
@implementation TYTabTitleViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:14];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 15;
    _titleLabel = titleLabel;
    
}

- (void)layoutSubviews
{
    //tabbar title位置
    [super layoutSubviews];
    int x = self.contentView.bounds.origin.x;
    int y = self.contentView.bounds.origin.y;
    int width = self.contentView.bounds.size.width;
    int height = self.contentView.bounds.size.height;
    
    _titleLabel.frame = CGRectMake(x, y+5, width, height);
}

@end
