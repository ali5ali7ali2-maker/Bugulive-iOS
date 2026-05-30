//
//  MGShowLiveWishView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/14.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGShowLiveWishView.h"

@implementation MGShowLiveWishView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isDragging = NO;
        self.isDecelerating = NO;
        self.scrollView.frame = self.bounds;
        [self setUpView];
//        [self requestModel];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollView.frame = self.bounds;
        [self addSubview:self.scrollView];
//        [self setUpView];
//        [self requestModel];
        
        //启动定时器
        self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(aoutScroll) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)setUpView{
    CGFloat viewWidth = self.width;
    CGFloat viewHeight = self.height;
    for (int i = 0; i < 3; i ++) {
        MGShowLiveSubView *view = [[MGShowLiveSubView alloc]initWithFrame:CGRectMake(0, viewHeight * i, viewWidth, viewHeight)];
        view.tag = 100 + i;
        [self.scrollView addSubview:view];
    }
}

-(void)showView{
    
}

-(void)relayoutFrameOfSubViews{
    CGFloat viewWidth = self.width;
    CGFloat viewHeight = self.height;
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(0, self.listArr.count * viewHeight);
    self.contentOffsetP = CGPointMake(viewWidth, viewHeight * 3);
    
    [self.scrollView removeAllSubViews];
    for (int i = 0; i < self.listArr.count; i ++) {
        MGShowLiveSubView *view = [[MGShowLiveSubView alloc]initWithFrame:CGRectMake(0, viewHeight * i, viewWidth, viewHeight)];
        view.tag = 100 + i;
        view.frame = CGRectMake(0, viewHeight * i, viewWidth, viewHeight);
        MGLiveWishModel *model = self.listArr[i];
        view.model.g_now_num = @"30";
        view.model = model;
        [self.scrollView addSubview:view];
        
        if (i == 0) self.topWishView = view;
        if (i == 1) self.middleWishView = view;
        if (i == 2) self.bottomWishView = view;
        
    }
}

-(void)requestModel:(NSString *)roomIDStr{
    self.listArr = [NSMutableArray array];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user_wish" forKey:@"ctl"];
    [mDict setObject:@"wish_list" forKey:@"act"];
    if(roomIDStr.length > 0)
    {
        //4-16 3.心愿单无效。
        [mDict setObject:roomIDStr forKey:@"room_id"];
    }
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            NSArray *arr = [responseJson valueForKey:@"list"];
            [self.listArr removeAllObjects];
            if (arr.count > 0) {
                for (NSDictionary *dic in arr)
                {
                    MGLiveWishModel *model = [MGLiveWishModel mj_objectWithKeyValues:dic];
                    [self.listArr addObject:model];
                }
            }
            self.hidden = self.listArr.count > 0  ?  NO :YES;
            [self relayoutFrameOfSubViews];
        }
    } FailureBlock:^(NSError *error) {

    }];
}





#pragma mark ----   用户翻页后重置数据
- (void)resetContent{
    if (self.listArr.count < 2) {
        return;
    }
    //重置偏移量
    CGPoint offset = CGPointMake(0, self.height);
    [self.scrollView setContentOffset:offset];
    
    //重置图片
    NSInteger leftIndex = (self.currentPageIndex-1+self.listArr.count)%self.listArr.count;
    NSInteger centerIndex = self.currentPageIndex;
    NSInteger rightIndex = (self.currentPageIndex+1+self.listArr.count)%self.listArr.count;
    
    
    
    self.topWishView.model = self.listArr[leftIndex];
    self.middleWishView.model = self.listArr[centerIndex];
    self.bottomWishView.model = self.listArr[rightIndex];
    
    self.isDragging = NO;
    self.isDecelerating = NO;
}

#pragma mark ---  ScrollView代理
//当调用contentoffset方法动画完毕时调用次方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:self];
    NSLog(ASLocalizedString(@"调用方法contentoffset方法动画完毕时调用次方法+++++++++++"));
}

//当用手指拖拽的时候调用次方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(ASLocalizedString(@"正在拖拽视图，所以需要将自动播放暂停掉"));
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    self.isDragging  = YES;
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
}

//当手指拖拽产生的滚动停止滚动时调用此方法。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isDragging = NO;
    //视图静止之后，过4秒在开启定时器
    NSLog(ASLocalizedString(@"开启定时器"));
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]]];
    NSLog(@"scrollViewDidEndDecelerating------------%f",self.contentOffsetP.y);
    //获取滚动视图移动的距离。
    CGFloat userDistance = self.contentOffsetP.y - self.height;
    if (userDistance < 0 ) {
        //往左翻页，将currentPage往上翻页
        self.currentPageIndex = (self.currentPageIndex - 1 + self.listArr.count)% self.listArr.count;
        [self resetContent];
    }else if (userDistance > 0){
        //往右翻页，将currentPage往下翻页
        self.currentPageIndex = (self.currentPageIndex + 1 + self.listArr.count)%self.listArr.count;
        [self resetContent];
    }else{
        //用户未翻页成功，什么都不做。
    }
}

#pragma mark --- 定时器自动翻页方法
- (void)aoutScroll{
    
    if (self.listArr.count < 2) {
        return;
    }
    
    NSLog(ASLocalizedString(@"定时器被调用------------------------"));
//这里需要判断如果用户正在拖动屏幕或者视图正在滚动，是不可以自动翻页的，避免和用户的操作相冲突。
    if (![self isDragging] || ![self isDecelerating]) {
        //这里只对contentOffset进行设置，因为一旦设置了contentOffSet后代理就会自动调用- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView此方法，代码重用，会利用我们上面写好的逻辑帮我们处理剩下的东西。
        [self.scrollView setContentOffset:CGPointMake(0, self.height * 2) animated:YES];
    }
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end

@implementation MGShowLiveSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(6), 0, kRealValue(30), kRealValue(30))];
    self.iconImgView.centerY = self.frame.size.height / 2;
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImgView.right + kRealValue(6), 0, kRealValue(80), kRealValue(20))];
    self.nameL.text = ASLocalizedString(@"七彩火箭");
    self.nameL.font = [UIFont systemFontOfSize:11];
    self.nameL.textColor = kWhiteColor;
    
    self.countL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kRealValue(73), kRealValue(15))];
    self.countL.textColor = kWhiteColor;
    self.countL.textAlignment = NSTextAlignmentCenter;
    self.countL.font = [UIFont systemFontOfSize:(9)];
    
    self.tintLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, kRealValue(15))];
    
//    [UIColor colorWithHexString:@""];
    self.bgLineView = [[UIView alloc]initWithFrame:CGRectMake(self.nameL.left, self.nameL.bottom + kRealValue(2), kRealValue(70), kRealValue(15))];
    self.bgLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    
    self.bgLineView.layer.cornerRadius = kRealValue(15 / 2);
    self.bgLineView.layer.masksToBounds = YES;
    
    [self addSubview:self.iconImgView];
    [self addSubview:self.nameL];
    [self addSubview:self.bgLineView];
    [self.bgLineView addSubview:self.tintLineView];
    [self.bgLineView addSubview:self.countL];

}

- (void)setModel:(MGLiveWishModel *)model{
    
    [self.bgLineView removeAllSubViews];
    self.tintLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, kRealValue(15))];
    [self.bgLineView addSubview:self.tintLineView];
    [self.bgLineView addSubview:self.countL];
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.g_icon] placeholderImage:nil];
    self.nameL.text = model.g_name;
    self.tintLineView.width = [model.g_now_num floatValue] / [model.g_num floatValue] * self.bgLineView.width;
    CAGradientLayer *layer = [self gradientLayerWithColor1:[UIColor colorWithHexString:@"#9D64FF"] AtColor2:[UIColor colorWithHexString:@"#F060F6"] view:self.tintLineView];
    [self.tintLineView.layer addSublayer:layer];
    self.countL.text = [NSString stringWithFormat:@"%@/%@",model.g_now_num,model.g_num];
}


- (CAGradientLayer*)gradientLayerWithColor1:(UIColor*)color1 AtColor2:(UIColor*)color2 view:(UIView *)view
{
    CAGradientLayer* layer = [CAGradientLayer new];
    layer.colors = @[ (__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
    layer.startPoint = CGPointMake(0.5f, -0.5);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = view.bounds;
    return layer;
}



@end
