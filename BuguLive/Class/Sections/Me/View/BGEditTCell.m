#import "BGEditTCell.h"
#import "UserModel.h"
#import "BGEditInfoController.h"
@implementation BGEditTCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.leftLabel.textColor = kAppGrayColor1;
    self.rightLabel.textColor = kAppGrayColor3;
    
    self.headImgView.layer.cornerRadius = 17;
    self.headImgView.layer.masksToBounds = YES;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 45*kAppRowHScale -1, kScreenW-10, 1)];
    self.lineView.backgroundColor = kAppSpaceColor4;
    [self addSubview:self.lineView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameArray = [[NSMutableArray alloc]initWithObjects:ASLocalizedString(@"头像"),ASLocalizedString(@"昵称"),ASLocalizedString(@"账号"),ASLocalizedString(@"性别"),ASLocalizedString(@"个性签名"),ASLocalizedString(@"国家"),ASLocalizedString(@"认证"),ASLocalizedString(@"生日"),ASLocalizedString(@"情感状态"),ASLocalizedString(@"家乡"),ASLocalizedString(@"职业"), nil];
}

- (void)creatCellWithStr:(NSString *)rightStr andSection:(EditTableView)section
{
    self.leftLabel.text = self.nameArray[section];
    self.headImgView.hidden = YES;
    self.sexImgView.hidden = YES;
    self.lineView.hidden = NO;
    switch (section) {
        case ETXSection:
        {
            self.headImgView.hidden = NO;
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:rightStr] placeholderImage:kDefaultPreloadHeadImg];
            self.lineView.hidden = YES;
        }
            break;
        case ENCSection:
        {
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = RGB(118, 59, 243);
            self.nextImgView.hidden = NO;
            self.lineView.hidden = NO;
        }
            break;
        case EZHSection:
        {
            self.lineView.hidden = NO;
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = RGB(118, 59, 243);
        }
            break;
        case EXBSection:
        {
            self.lineView.hidden = NO;
            self.sexImgView.hidden = NO;
            if ([rightStr isEqualToString:@"1"])
            {
                _sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }else if ([rightStr isEqualToString:@"2"])
            {
                _sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
            }else
            {
                // 默认显示男性图标
                _sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }
        }
            break;
        case EGXQMSection:
        {
            self.lineView.hidden = YES;
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor2;
            self.nextImgView.hidden = NO;
        }
            break;
        case EGJSection: // 新增国家选项
        {
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor2;
            self.nextImgView.hidden = NO;
        }
            break;
        case ERZSection:
        {
            // 认证暂不处理
        }
            break;
        case ESRSection:
        case EQGZTSection:
        case EJXSection:
        case EZYSection:
        {
            self.rightLabel.hidden = NO;
            self.rightLabel.text = rightStr;
            self.rightLabel.textColor = kAppGrayColor2;
            self.nextImgView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

@end
