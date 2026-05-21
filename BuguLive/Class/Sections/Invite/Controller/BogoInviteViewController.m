//
//  BogoInviteViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/6/9.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteViewController.h"
#import "BogoInviteResponseModel.h"
#import "BogoInviteListCell.h"
#import "BogoInviteDetailViewController.h"
#import "CommonShareView.h"
#import "BogoInviteRuleViewController.h"
#import "BogoShareViewController.h"
#import "BogoNetworkKit.h"

#import "UITableView+XY.h"

@interface BogoInviteViewController ()<UITableViewDelegate,UITableViewDataSource,CommonShareViewDelegate>

@property (weak, nonatomic) IBOutlet QMUIButton *logBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet QMUIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UILabel *total_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *two_countLabel;

@property (weak, nonatomic) IBOutlet UILabel *man_oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *man_twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *wman_oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *wman_twoLabel;

@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property(nonatomic, strong) BogoInviteResponseModel *model;

@property(nonatomic, strong) CommonShareView *shareView;
@property (weak, nonatomic) IBOutlet UIView *logView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;


@property (nonatomic,strong) UIImageView* noDataView;
@property (nonatomic,strong) UILabel* noDataLabel;


@end

@implementation BogoInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =ASLocalizedString( @"邀请好友");
    
    self.logBtn.imagePosition = QMUIButtonImagePositionRight;
    self.logBtn.spacingBetweenImageAndTitle = 5;
    self.logBtn.layer.borderWidth = 1;
    self.logBtn.layer.borderColor = [UIColor colorWithHexString:@"F42416"].CGColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoInviteListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoInviteListCell"];
    
    self.moreBtn.imagePosition = QMUIButtonImagePositionRight;
    self.moreBtn.spacingBetweenImageAndTitle = 5;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.inviteBtn.bounds;
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF9D45"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#F4491F"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.inviteBtn.layer insertSublayer:gl atIndex:0];
    [self setUpLocalizationString];
    [self requestData];
}

- (IBAction)ruleBtnAction:(UIButton *)sender {
    BogoInviteRuleViewController *ruleVC = [[BogoInviteRuleViewController alloc]init];
    ruleVC.content = self.model.protal;
    [self.navigationController pushViewController:ruleVC animated:YES];
}

- (IBAction)logBtnAction:(QMUIButton *)sender {
    BogoInviteDetailViewController *detailVC = [[BogoInviteDetailViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)requestData{
//    /mapi/index.php?ctl=invite_vue&act=invite_index_new
    [[BogoNetwork shareInstance] POSTV4:@"" param:@{@"ctl":@"invite_vue",@"act":@"invite_index_new"} success:^(id _Nonnull result) {
        self.model = [BogoInviteResponseModel mj_objectWithKeyValues:result];
        
        self.moreBtn.hidden = self.model.lists.count < 3;
        self.logView.hidden = NO;
//        !self.model.lists.count;
//        if (self.model.lists.count) {
            self.contentHeight.constant = 773;
        if (self.model.lists.count < 1) {
//            [self xy_noDataViewImage];
//            [self xy_noDataViewMessage];
            [self showNoDataImage];
        }else{
            [self removeNoDataImage];
        }
        [self.tableView reloadData];
        
//        }else{
//            self.contentHeight.constant = 508;
//        }
        self.total_moneyLabel.text = self.model.data.total_money;
        self.countLabel.text = self.model.data.count;
        self.two_countLabel.text = self.model.data.two_count;
        self.man_oneLabel.text = [NSString stringWithFormat:@"%@%%",self.model.reward.one];
        self.man_twoLabel.text = [NSString stringWithFormat:@"%@%%",self.model.reward.two];
    } failure:^(NSString * _Nonnull error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    }];
}

- (IBAction)inviteBtnAction:(UIButton *)sender {
//    [self.shareView show:self.view];
    BogoShareViewController *shareVC = [[BogoShareViewController alloc]init];
    [self.navigationController pushViewController:shareVC animated:YES];
}

#pragma mark - CommonShareViewDelegate
- (void)shareView:(CommonShareView *)shareView didClickBtn:(QMUIButton *)sender{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject =  [UMShareWebpageObject shareObjectWithTitle:@"" descr:@"" thumImage:nil];
//    shareObject.webpageUrl = [NSString stringWithFormat:@"%@?invite_code=%@",[GlobalVariable sharedGlobalVariable].appmodel.app_h5.download_url,[IMAPlatform sharedInstance].host.userId];
    [UIPasteboard generalPasteboard].string = shareObject.webpageUrl;
    messageObject.shareObject = shareObject;
    
    if (sender.tag - kRoomShareViewBaseBtnTag == UMSocialPlatformType_WechatSession) {
        if (![WXApi isWXAppInstalled]) {
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"未安装微信")];
            return;
        }
        
    }
    
    
    
    [[UMSocialManager defaultManager] shareToPlatform:sender.tag - kRoomShareViewBaseBtnTag messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [[BGHUDHelper sharedInstance] tipMessage:error.localizedDescription];
        }else{
            [[BGHUDHelper sharedInstance] tipMessage:NSLocalizedString(@"分享成功",nil)];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.lists.count > 3 ? 3 : self.model.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoInviteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoInviteListCell" forIndexPath:indexPath];
    if (indexPath.row < self.model.lists.count) {
        cell.model = self.model.lists[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CommonShareView *)shareView{
    if (!_shareView) {
        _shareView = [[CommonShareView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenW, 190+FD_Bottom_SafeArea_Height)];
        _shareView.delegate = self;
    }
    return _shareView;
}


- (UIImage *)xy_noDataViewImage{
    return imageNamed(@"暂无数据");
}

- (NSString *)xy_noDataViewMessage{
    return ASLocalizedString( @"暂无记录");
}

-(void)showNoDataImage
{
    UIImage *image=[UIImage imageNamed:@"bogo_common_empty"];
    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.tableView.width;
    CGFloat cX = sW / 2;
    CGFloat cY = self.tableView.height * (1 - 0.618) + 0;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //  图片
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:image];
    _noDataView.contentMode = UIViewContentModeScaleAspectFit;
    _noDataView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);

    //  文字
    _noDataLabel       = [[UILabel alloc] init];
    _noDataLabel.font           = [UIFont systemFontOfSize:17];
    _noDataLabel.textColor      = [UIColor lightGrayColor];;
    _noDataLabel.text           =ASLocalizedString( @"暂无数据");
    _noDataLabel.textAlignment  = NSTextAlignmentCenter;
    _noDataLabel.frame          = CGRectMake(0, CGRectGetMaxY(_noDataView.frame) + 24, sW, _noDataLabel.font.lineHeight);
    
    [self.tableView addSubview:_noDataView];
    [self.tableView addSubview:_noDataLabel];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
        [_noDataLabel removeAllSubviews];
        _noDataLabel=nil;
    }
}

@end
