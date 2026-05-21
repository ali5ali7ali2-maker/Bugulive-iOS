//
//  BogoLanguageAlertView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/26.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoLanguageAlertView.h"

@implementation BogoLanguageAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = kWhiteColor;
        self.listArr = @[@"中文简体",@"English",@"Arabic"];
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(20),kRealValue(10), self.width, kRealValue(40))];
    self.titleL.text = ASLocalizedString(@"切换语言");
    self.titleL.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.titleL];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.titleL.bottom + kRealValue(15), self.width, kRealValue(120)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:tableView];
    
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, tableView.bottom, self.width / 2, kRealValue(40));
    [cancleBtn setTitle:ASLocalizedString(@"取消") forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#0091ea"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _cancleBtn = cancleBtn;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(self.width / 2, tableView.bottom, self.width / 2, kRealValue(40));
    [confirmBtn setTitle:ASLocalizedString(@"确定") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#0091ea"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn = confirmBtn;
    
    [self addSubview:self.titleL];
    [self addSubview:self.tableView];
    [self addSubview:self.cancleBtn];
    [self addSubview:self.confirmBtn];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.listArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray  *languages = [NSLocale preferredLanguages];
    NSString *lname = self.listArr[indexPath.row];
    NSString *language = @"en";
    
    if([lname isEqualToString:@"中文简体"])
    {
        
        language = @"zh-Hans";
//        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:KAppLanguageFirst];
//        [[LocalizationSystem sharedLocalSystem] setLanguage:@"zh-Hans"];
        
//
//        // 强制 成 简体中文
//        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans",nil] forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] setObject:preferredLang[0] forKey:KAppLanguage];

   
    }
    else if([lname isEqualToString:@"Arabic"])
    {
        language = @"ar";
    }
    else{
        
        language = @"en";

        
//        [[LocalizationSystem sharedLocalSystem] setLanguage:@"en"];
//
//
//        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en",nil] forKey:@"AppleLanguages"];
        
//        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:KAppLanguageFirst];
    }
    
    
    [[LocalizationSystem sharedLocalSystem] setLanguage:language];
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:KAppLanguage];

    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:language,nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    __weak typeof(self) weakSelf = self;
    [BGHUDHelper alert:ASLocalizedString(@"Language changed. Please restart the app to apply changes.") action:^{
        [weakSelf hide];
    }];
    
    [self.tableView reloadData];
}

-(void)clickCancleBtn:(UIButton *)sender{
    [self hide];
    
}

-(void)clickConfirmBtn:(UIButton *)sender{
    [self hide];
    
}


#pragma mark - Show And Hide

- (void)show:(UIView *)superView{
    
//    [self requestModel];
    
    [superView addSubview:self.shadowView];
    [superView addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = (kScreenH - self.height) / 2;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}


@end
