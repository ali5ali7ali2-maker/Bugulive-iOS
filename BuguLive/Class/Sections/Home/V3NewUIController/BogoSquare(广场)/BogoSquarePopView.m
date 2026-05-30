//
//  BogoSquarePopView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/7/31.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSquarePopView.h"
#import "BogoSquarrePopCell.h"

@implementation BogoSquarePopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        [self setUpView];
    }
    return self;
}



-(void)setUpView{
    
    [self addSubview:self.tableView];
    self.tableView.top = kRealValue(10);
    [self addSubview:self.topView];
    
}



- (void)setListArr:(NSArray *)listArr{
    _listArr = listArr;
    self.tableView.height = kRealValue(40 * listArr.count);
    [self.tableView reloadData];
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
//    static NSString *identifier = @"cell";
    BogoSquarrePopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoSquarrePopCell" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[BogoSquarrePopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    
    cell.titleL.text = self.listArr[indexPath.row];
    cell.line.hidden = indexPath.row == 1;
//    cell.textLabel.text = self.listArr[indexPath.row];
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickIndexBlock) {
        self.clickIndexBlock(indexPath.row);
    }
    
    [self hide];
    
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, kRealValue(80)) style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoSquarrePopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoSquarrePopCell"];
//        [_tableView registerClass:[BogoSquarrePopCell class] forCellReuseIdentifier:@"BogoSquarrePopCell"];
        
    }
    return _tableView;
}

-(BogoDrawView *)topView{
    if (!_topView) {
        
        CGFloat viewWidth = kRealValue(25);
        
        _topView = [[BogoDrawView alloc]initStartPoint:CGPointMake(0, kRealValue(10)) middlePoint:CGPointMake(viewWidth / 2,0) endPoint:CGPointMake(viewWidth, kRealValue(10)) color:kWhiteColor];
        
        
        _topView.frame = CGRectMake(self.right - kRealValue(10 + 10) - kRealValue(15), 0, kRealValue(10 + 10 + 10), kRealValue(10));
        
    }
    return _topView;
}

@end
