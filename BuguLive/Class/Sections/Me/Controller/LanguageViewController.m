//
//  LanguageViewController.m
//  UniversalApp
//
//  Created by 志刚杨 on 2018/10/8.
//  Copyright © 2018年 voidcat. All rights reserved.
//

#import "LanguageViewController.h"
#import "LanguageTableViewCell.h"
@interface LanguageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //2-22 修改切换语言
    self.view.backgroundColor= kWhiteColor;
    //2-17 加切换语言标题
    self.title = ASLocalizedString(@"切换语言") ;
    _dataSource = @[@"中文简体",@"English",@"Arabic"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    self.tableView.frame = self.view.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    self.tableView.backgroundColor=kWhiteColor;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    LanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LanguageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.backgroundColor=MainColorBK;
    NSString *lname = self.dataSource[indexPath.row];
    cell.textLabel.text = lname;
    cell.textLabel.textColor=kBlackColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSArray  *languages = [NSLocale preferredLanguages];
    NSString *lname = self.dataSource[indexPath.row];
    if([lname isEqualToString:@"中文简体"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:KAppLanguage];
        
        // 强制 成 简体中文
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans",nil] forKey:@"AppleLanguages"];
   
    }else if ([lname isEqualToString:@"中文繁體"]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hant",nil] forKey:@"AppleLanguages"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:KAppLanguage];
    }
    else if ([lname isEqualToString:@"Arabic"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar",nil] forKey:@"AppleLanguages"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"ar" forKey:KAppLanguage];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en",nil] forKey:@"AppleLanguages"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:KAppLanguage];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [BGHUDHelper alert:ASLocalizedString(@"Language changed. Please restart the app to apply changes.") action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.tableView reloadData];
}



@end
