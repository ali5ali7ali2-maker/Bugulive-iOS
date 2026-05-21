//
//  GuildCreateViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildCreateViewController.h"
#import <QMUIKIt/QMUIKIt.h>
#import "BogoNetworkKit.h"
#import "FDUIKitObjC.h"
#import "GuildDetailModel.h"

@interface GuildCreateViewController ()

@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet QMUITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *needAgreeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *noNeedAgreeImageView;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;
@property (weak, nonatomic) IBOutlet UILabel *choiceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *isMeAgreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isApplyLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleName;

@end

@implementation GuildCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ASLocalizedString(@"编辑公会资料");
    self.nameTextField.maximumTextLength = 8;
    self.contentTextView.maximumTextLength = 50;
    if (self.model.family_id.integerValue) {
        self.nameTextField.text = self.model.family_name;
        self.contentTextView.text = self.model.family_manifesto;
        self.needAgreeImageView.hidden = self.model.family_type.integerValue == 2;
        self.noNeedAgreeImageView.hidden = self.model.family_type.integerValue == 1;
        [self.createBtn setTitle:ASLocalizedString(@"保存") forState:UIControlStateNormal];
    }
    
    self.contentTextView.placeholder = ASLocalizedString(@"请输入公会宣言，最多50个字");
    self.declarationLabel.text = ASLocalizedString(@"公会宣言");
    self.titleLabel.text = ASLocalizedString(@"完善公会资料");
    self.nameTextField.placeholder = ASLocalizedString(@"请输入公会名称，最多8个字");
    self.choiceTitleLabel.text = ASLocalizedString(@"选择加入公会验证方式");
    self.isMeAgreeLabel.text = ASLocalizedString(@"·申请人需要我同意才能加入");
    self.isApplyLabel.text = ASLocalizedString(@"·申请人只要申请就可以加入");
    [self.createBtn setTitle:ASLocalizedString(@"创建公会") forState:UIControlStateNormal];
    
    [self.titleName setLocalizedString];
}

- (IBAction)needAgreeBtnAction:(UIButton *)sender {
    self.needAgreeImageView.hidden = NO;
    self.noNeedAgreeImageView.hidden = YES;
}

- (IBAction)noNeedAgreeBtnAction:(UIButton *)sender {
    self.needAgreeImageView.hidden = YES;
    self.noNeedAgreeImageView.hidden = NO;
}

- (IBAction)createGuildBtnAction:(UIButton *)sender {
    if (!self.nameTextField.text.length) {
        [[FDHUDManager defaultManager] show:ASLocalizedString(@"未输入公会名称") ToView:self.view];
        return;
    }
    if (!self.contentTextView.text.length) {
        [[FDHUDManager defaultManager] show:ASLocalizedString(@"未输入公会宣言") ToView:self.view];
        return;
    }
//    family_name    是    string    公会名称
//    family_manifesto    是    string    公会宣言
//    type    是    int    加入公会的验证方式【1会长同意；2申请即加入】
    NSString *act = @"create_guild";
    if (self.model.family_id.integerValue) {
        act = @"guild_save";
    }
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"act":act,@"ctl":@"family",@"family_name":self.nameTextField.text,@"family_manifesto":self.contentTextView.text,@"type":self.needAgreeImageView.hidden ? @(2) : @(1),@"family_id":self.model.family_id.integerValue ? self.model.family_id : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        NSString *family_id = [NSString stringWithFormat:@"%@",result.data[@"family_id"]];
        if (family_id.integerValue) {
            if (self.model.family_id.integerValue) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(createVC:didEditFinished:)]) {
                    [self.delegate createVC:self didEditFinished:family_id];
                }
                
                if (self.clickCancleBlock) {
                    self.clickCancleBlock(YES);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(createVC:didCreateFinished:)]) {
                    [self.delegate createVC:self didCreateFinished:family_id];
                }
                if (self.clickCancleBlock) {
                    self.clickCancleBlock(YES);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

@end
