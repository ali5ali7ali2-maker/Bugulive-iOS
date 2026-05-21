//
//  BogoWardOpenView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoWardOpenView.h"
#import "BogoOpenWardCollectionView.h"
#import "BogoWardModel.h"
#import "BogoOpenWardBottomView.h"

@interface BogoWardOpenView()

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *topBackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *wardImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) QMUIButton *diamondBtn;

@property (nonatomic, copy) clickFAQBtnBlock clickFAQBtnBlock;
@property (nonatomic, copy) clickWardListBtnBlock clickWardListBtnBlock;
@property (nonatomic, copy) clickOpenViewBtnBlock clickOpenViewBtnBlock;
@property (nonatomic, copy) clickPrivilegeBtnBlock clickPrivilegeBtnBlock;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *currentId;
@property (nonatomic, strong) NSArray *privilegeArray;

@property(nonatomic, strong) UILabel *timeL;
@property(nonatomic, strong) UILabel *privilegeL;

@property(nonatomic, strong) BogoOpenWardCollectionView *wardCollectionView;//守护时长
@property(nonatomic, strong) BogoOpenWardCollectionView *timeCollectionView;//守护时长
@property(nonatomic, strong) BogoOpenWardCollectionView *privilegeCollectionView;//守护特权


@property(nonatomic, strong) BogoOpenWardBottomView *bottomView;
@property(nonatomic, strong) UIView *backGroundView;
@end

@implementation BogoWardOpenView

-(instancetype)initWithFrame:(CGRect)frame UserId:(nonnull NSString *)userId{
   if (self = [super initWithFrame:frame]) {
       self.backgroundColor = kWhiteColor;
       
       self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, frame.size.width - 20, frame.size.height)];
       [self addSubview:self.backGroundView];
       self.backGroundView.backgroundColor = kWhiteColor;
       ViewRadius(self.backGroundView, 10);
       
       UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
       CAShapeLayer* shape = [[CAShapeLayer alloc] init];
       [shape setPath:rounded.CGPath];
       self.layer.mask = shape;
       self.userId = userId;
       
       CAGradientLayer *gl = [CAGradientLayer layer];
       gl.frame = self.bounds;
       gl.startPoint = CGPointMake(0, 0);
       gl.endPoint = CGPointMake(1, 1);
       gl.colors = @[(__bridge id)[UIColor colorWithRed:174/255.0 green:44/255.0 blue:241/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:137/255.0 green:106/255.0 blue:255/255.0 alpha:1.0].CGColor];
       gl.locations = @[@(0.0),@(1.0f)];

       [self.layer insertSublayer:gl atIndex:0];
       self.layer.cornerRadius = 20;
       
       [self initSubview];
       [self requestData];
   }
   return self;
}

- (void)initSubview{
   
    UIImageView *zhuanshi = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, self.width, 90)];
    [self addSubview:zhuanshi];
    zhuanshi.contentMode = UIViewContentModeScaleAspectFit;
    
    zhuanshi.image = [UIImage imageNamed:@"守护装饰"];
    
   UIButton *faqBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
   [faqBtn setBackgroundImage:[UIImage imageNamed:@"lr_btn_ward_faq"] forState:UIControlStateNormal];
//   [faqBtn addTarget:self action:@selector(faqBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    faqBtn.hidden = YES;
   [self addSubview:faqBtn];
   
   [self addSubview:self.iconImageView];
   [self addSubview:self.wardImageView];
   
   UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, kRealValue(25), kRealValue(25))];
   closeBtn.right = self.right - kRealValue(10);
    closeBtn.hidden = YES;
   [closeBtn setImage:[UIImage imageNamed:@"lr_btn_ward_close"] forState:UIControlStateNormal];
   [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
   [self addSubview:closeBtn];
   
   CGSize wardListBtnSize = [ASLocalizedString(@"TA的守护")textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
   UIButton *wardListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, wardListBtnSize.width, 20)];
   wardListBtn.right = self.right - kRealValue(10);
   [wardListBtn setTitle:ASLocalizedString(@"TA的守护")forState:UIControlStateNormal];
   [wardListBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
   [wardListBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
   [wardListBtn addTarget:self action:@selector(wardListBtnAction) forControlEvents:UIControlEventTouchUpInside];
   [self addSubview:wardListBtn];
   
   
   
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, kRealValue(50))];
    self.titleL.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.text = ASLocalizedString(@"开通守护");
    self.titleL.centerX = kScreenW / 2;
    [self addSubview:self.titleL];
    [self setUpCollectionView];
    
    closeBtn.centerY = wardListBtn.centerY = self.titleL.centerY;
}


-(void)setUpCollectionView{
    
    [self addSubview:self.timeL];
    [self addSubview:self.privilegeL];
    [self addSubview:self.wardCollectionView];
    [self addSubview:self.timeCollectionView];
    [self addSubview:self.privilegeCollectionView];
    [self addSubview:self.bottomView];
    
    self.wardCollectionView.frame = CGRectMake(10, self.titleL.bottom + 10, kScreenW - 20, kRealValue(80));
    self.timeL.top = self.wardCollectionView.bottom;
    self.timeCollectionView.frame = CGRectMake(10, self.timeL.bottom, kScreenW -20, kRealValue(40));
    self.privilegeL.top =  self.timeCollectionView.bottom;
    self.privilegeCollectionView.frame = CGRectMake(10, self.privilegeL.bottom, kScreenW -20, kRealValue(160));
    
    self.backGroundView.qmui_extendToBottom = self.privilegeCollectionView.bottom + 5;
    
}


- (void)requestData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"guardians" forKey:@"ctl"];
    [dict setValue:@"duardian_index" forKey:@"act"];
    [dict setValue:self.userId forKey:@"host_id"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:responseJson[@"head_image"]] placeholderImage:kDefaultPreloadHeadImg];
            NSString *is_guaritian = responseJson[@"is_guartian"];
            NSString *diamond = responseJson[@"diamonds"];
            NSString *guartian_time = responseJson[@"guartian_time"];
            NSString *guartian_icon = responseJson[@"guartian_icon"];
            
            NSArray *guardianTypeArr = [NSArray modelArrayWithClass:[BogoWardModel class] json:responseJson[@"list"]];
            NSArray *priviteArr = [NSArray modelArrayWithClass:[BogoWardModel class] json:responseJson[@"guardian_effects"]];
//
            [self.wardCollectionView refreshType:BOGO_OPENWARD_Collection_TYPE_GUARDIANS array:guardianTypeArr];
            [self.privilegeCollectionView refreshType:BOGO_OPENWARD_Collection_TYPE_PRIVITE array:priviteArr];
            self.bottomView.is_guartian = is_guaritian;
            self.bottomView.diamondStr = diamond;
            self.bottomView.guartian_icon = guartian_icon;
            self.bottomView.guartian_time = guartian_time;
            
            BogoWardModel *model = guardianTypeArr.firstObject;

            [self.timeCollectionView refreshType:BOGO_OPENWARD_Collection_TYPE_TIME array:model.guardian_pay];
            BogoWardPayTimeModel *timeModel = model.guardian_pay.firstObject;
            if ([timeModel isKindOfClass:[NSDictionary class]]) {
                timeModel = [BogoWardPayTimeModel modelWithDictionary:timeModel];
            }
            self.currentId = timeModel.id;
        }else{
            NSLog(ASLocalizedString(@"守护类型接口请求失败responseJson:%@"),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"守护类型接口请求失败error:%@"),error);
    }];
}



-(void)closeBtn:(UIButton *)sender{
    [self hide];
}

- (void)wardListBtnAction{
    [self hide];
    if (self.clickWardListBtnBlock) {
        self.clickWardListBtnBlock();
    }
}

- (void)openBtnAction{
    NSLog(ASLocalizedString(@"点击了开通守护按钮"));
    [self hide];
    if (self.clickOpenViewBtnBlock) {
        self.clickOpenViewBtnBlock(self.currentId);
    }
}


-(BogoOpenWardCollectionView *)wardCollectionView{
    if (!_wardCollectionView) {
        _wardCollectionView = [[BogoOpenWardCollectionView alloc]initWithFrame:CGRectMake(20, kRealValue(30), kScreenW - 20, kRealValue(78))];
        _wardCollectionView.selectRowBlock = ^(BogoWardModel * _Nonnull model) {
            [self.timeCollectionView refreshType:BOGO_OPENWARD_Collection_TYPE_TIME array:model.guardian_pay];
            [self.privilegeCollectionView refreshTypeNameWithArray:model.type_name];
            BogoWardPayTimeModel *timeModel = model.guardian_pay.firstObject;
            if ([timeModel isKindOfClass:[NSDictionary class]]) {
                timeModel = [BogoWardPayTimeModel modelWithDictionary:timeModel];
            }
            self.currentId = timeModel.id;
        };
    }
    return _wardCollectionView;
}

-(BogoOpenWardCollectionView *)timeCollectionView{
    if (!_timeCollectionView) {
        _timeCollectionView = [[BogoOpenWardCollectionView alloc]initWithFrame:CGRectMake(10, kRealValue(30), kScreenW - 20, kRealValue(40))];
        _timeCollectionView.selectTimeCollectionViewRowBlock = ^(BogoWardPayTimeModel * _Nonnull timeModel) {
            if ([timeModel isKindOfClass:[NSDictionary class]]) {
                timeModel = [BogoWardPayTimeModel modelWithDictionary:timeModel];
            }
            self.currentId = timeModel.id;
        };

    }
    return _timeCollectionView;
}

-(BogoOpenWardCollectionView *)privilegeCollectionView{
    if (!_privilegeCollectionView) {
        _privilegeCollectionView = [[BogoOpenWardCollectionView alloc]initWithFrame:CGRectMake(10, kRealValue(30), kScreenW - 20, kRealValue(150))];
    }
    return _privilegeCollectionView;
}

-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW / 2, kRealValue(30))];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor colorWithHexString:@"#333333"];
        _timeL.text = ASLocalizedString(@"守护时长");
    }
    return _timeL;
}

-(UILabel *)privilegeL{
    if (!_privilegeL) {
        _privilegeL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW / 2, kRealValue(30))];
        _privilegeL.font = [UIFont systemFontOfSize:14];
        _privilegeL.textColor = [UIColor colorWithHexString:@"#333333"];
        _privilegeL.text = ASLocalizedString(@"守护特权");
    }
    return _privilegeL;
}

-(BogoOpenWardBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BogoOpenWardBottomView alloc]initWithFrame:CGRectMake(0, self.height - kRealValue(60) - MG_BOTTOM_MARGIN, kScreenW, kRealValue(60))];
        _bottomView.clickOpenBtnBlock = ^(BOOL isClick) {
            [self openBtnAction];
        };
    }
    return _bottomView;
}

@end
