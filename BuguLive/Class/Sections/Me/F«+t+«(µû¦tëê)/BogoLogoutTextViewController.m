//
//  BogoLogoutTextViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/28.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoLogoutTextViewController.h"
#import "BogoLogoutTextItmeCell.h"
#import "BogoSetAccountModel.h"

#import "BogoLogoutViewController.h"



@interface BogoLogoutTextViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, strong) BogoSetAccountModel *model;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextView *agreeT;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property(nonatomic, assign) BOOL isSelect;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BogoLogoutTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isSelect = NO;
    self.itemView.layer.cornerRadius = 4;
    self.itemView.layer.masksToBounds = YES;
    [self.itemView addSubview:self.tableView];
    
    self.tableView.frame = self.itemView.bounds;
    [self setModel];
    self.topConstraint.constant = kStatusBarHeight;
    
    self.confirmBtn.enabled = NO;
    
    [self setAgreeTextView];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)setModel{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"cancellation" forKey:@"act"];
    [paramDic setObject:@"login" forKey:@"ctl"];
    [paramDic setObject:[BGIMLoginManager sharedInstance].loginParam.identifier forKey:@"uid"];
    self.listArr = [NSMutableArray array];
    [[NetHttpsManager manager] POSTWithParameters:paramDic SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            self.model = [BogoSetAccountModel modelWithDictionary:[responseJson valueForKey:@"data"]];
            
            [self.listArr addObject:ASLocalizedString(@"账户信息、会员、贵族等权限")];
            [self.listArr addObject:[NSString stringWithFormat:ASLocalizedString(@"账户剩余钻石数量:%@"),self.model.diamonds]];
            [self.listArr addObject:[NSString stringWithFormat:ASLocalizedString(@"账户剩余可提现布谷票:%@"),self.model.ticket]];
            [self.listArr addObject:ASLocalizedString(@"交易记录及其他个人上传信息")];
            
            [self.tableView reloadData];
        }else{
            
            [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
        }
        
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kRealValue(35);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoLogoutTextItmeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoLogoutTextItmeCell" forIndexPath:indexPath];
    
    cell.contentL.text = self.listArr[indexPath.row];
    cell.contentL.backgroundColor = kClearColor;
    cell.contentView.backgroundColor = kClearColor;
    cell.backgroundColor = kClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (IBAction)clickCancleBtn:(QMUIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickLogoutBtn:(UIButton *)sender {
    
    BogoLogoutViewController *vc = [BogoLogoutViewController new];
    vc.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoLogoutTextItmeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoLogoutTextItmeCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (IBAction)clickSelectBtn:(UIButton *)sender {
    self.isSelect = !self.isSelect;
    
    if (self.isSelect) {
        [self.selectBtn setImage:[UIImage imageNamed:@"bogo_regiset_select"] forState:UIControlStateNormal];
        self.confirmBtn.enabled = YES;
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"bogo_regiset_normal"] forState:UIControlStateNormal];
        self.confirmBtn.enabled = NO;
    }
}
    
   

//我已阅读并同意《用户服务协议》、《隐私权政策》
-(void)setAgreeTextView{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.agreeT.text];
        //设置行间距以及字体大小、颜色
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11.0],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"action1://"
                             range:[[attributedString string] rangeOfString:ASLocalizedString(@"《注销协议》")]];
   
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9152F8"]};
    self.agreeT.backgroundColor = [UIColor clearColor];
    self.agreeT.linkTextAttributes = linkAttributes;
    self.agreeT.attributedText = attributedString;
    self.agreeT.scrollEnabled = NO;
    self.agreeT.font = [UIFont systemFontOfSize:12.0];
    self.agreeT.textAlignment = NSTextAlignmentCenter;
    self.agreeT.editable = NO;
    self.agreeT.delegate = self;
//    [self.view addSubview:self.agreeT];
    
    
    
    
    
 

    
//    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
//    container.maximumNumberOfRows = 1;
//    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
}


#pragma mark -
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.user_unsubscribe isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
    
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    tmpController.navigationController.navigationBar.hidden = NO;
    return YES;
}

@end
