//
//  VideoCateVC.m
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "VideoCateVC.h"
#import "DTTopicModel.h"

@interface VideoCateVC ()
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation VideoCateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.title = ASLocalizedString(@"分类");
    [self backBtnWithBlock];
    self.dataArray = [NSMutableArray arrayWithArray:[GlobalVariables sharedInstance].appModel.video_cate];
    [self createLabelUI];
//    [self requestData];

    // Do any additional setup after loading the view.
}
- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}


- (void)requestData{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"dynamic_cate" forKey:@"act"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray * array = responseJson[@"data"];
        for (id obj in array)
        {
            DTTopicModel *model =[DTTopicModel mj_objectWithKeyValues:obj];
            [self.dataArray addObject:model];
        }
//        [self.tableView reloadData];
        [self createLabelUI];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
//创建标签流UI
-(void)createLabelUI{

#pragma mark ============== 标签流布局 S====================
    //父视图
    UIView * labelContentView = [[UIView alloc]init];
    [self.view addSubview:labelContentView];
    
    //标签相对父视图左边距
    CGFloat leftMarginLabel = 10;
    //标签相对父视图顶部距离
    CGFloat topMarginLabel =  0;
    //标签左右间距
    CGFloat horizontalSpace = 10;
    //标签上下间距
    CGFloat verticalSpace = 10;
    //标签的高度
     CGFloat labelHeight = 55;
    

    //下面这几个值不需要做修改
    //最大宽度，超过这个宽度就要换行
    CGFloat windthMax = SCREEN_WIDTH - leftMarginLabel * 2;
    //标签的起始X坐标（下面动态变化）
    CGFloat labelMinX = leftMarginLabel;
    //标签的起始Y坐标（下面动态变化）
    CGFloat labelMimY = topMarginLabel;
    //记录最后一个标签的最大Y，用来布局父视图
    CGFloat lastLabelMaxY = topMarginLabel;

    for (int i = 0; i < self.dataArray.count; i++) {
        DTTopicModel * model = self.dataArray[i];
        NSString * title = model.name;
        QMUIButton* labelButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [labelButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [labelButton setImage:[UIImage imageNamed:@"添加短视频分类"] forState:UIControlStateNormal];
        labelButton.imagePosition = QMUIButtonImagePositionLeft;
        labelButton.spacingBetweenImageAndTitle = 4;
        
//        [labelButton setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        //根据文字计算标签的宽度，后面会多加上一点宽度，视情况而定
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGFloat labelWidth = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 30;
        //为标签赋值
        [labelButton setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
        //设置标签的frame
        labelButton.frame = CGRectMake(labelMinX, labelMimY, labelWidth, labelHeight);
        
        //当标签的位置超出屏幕边缘时换行（超出限制的最大宽度）
        if(labelMinX + labelWidth + horizontalSpace > windthMax){
            //换行时将w置为起始坐标
            labelMinX = leftMarginLabel;
            //距离父视图也变化
            labelMimY = labelMimY + labelButton.frame.size.height + verticalSpace;
            //重设button的frame
            labelButton.frame = CGRectMake(labelMinX, labelMimY, labelWidth, labelHeight);
        }
        //多加的是两个标签之间的水平距离
        labelMinX = labelButton.frame.size.width + labelButton.frame.origin.x + horizontalSpace;
        labelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        labelButton.tag = i+100;
        //标签的点击事件
        [labelButton addTarget:self action:@selector(labelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [labelContentView addSubview:labelButton];
      
        if (i==self.dataArray.count-1) {
            //拿到最后一个标签的位置
            lastLabelMaxY = labelButton.bottom;
        }
        labelButton.backgroundColor = kWhiteColor;
        
        labelButton.layer.cornerRadius = 3;
        labelButton.layer.shadowColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:0.5].CGColor;
        labelButton.layer.shadowOffset = CGSizeMake(0,0);
        labelButton.layer.shadowOpacity = 1;
        labelButton.layer.shadowRadius = 5;
        
    }
    
    //布局
    [labelContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(lastLabelMaxY);
    }];
#pragma mark ============== 标签流布局 E====================
}

-(void)labelButtonAction:(UIButton *)button{
    
    NSInteger index = button.tag -100;
    DTTopicModel * model = self.dataArray[index];
    
    !self.releaseTopicBlock?:self.releaseTopicBlock(model);
    [self.navigationController popViewControllerAnimated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
