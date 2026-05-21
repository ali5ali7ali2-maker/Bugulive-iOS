//
//  DistanceModel.m
//  BuguLive
//
//  Created by fanwe2014 on 16/10/24.
//  Copyright © 2016年 xfg. All rights reserved.


#import "DistanceModel.h"
#import "LivingModel.h"

@implementation DistanceModel

- (NSMutableArray *)CalculateDistanceWithArray:(NSMutableArray *)DisArray andPoint:(QMapPoint )point
{

    self.distanceArray = [[NSMutableArray alloc]init];
    //计算距离
    for (int i = 0; i < DisArray.count; i ++)
    {
        LivingModel *model = DisArray[i];
        float distance;
        if (model.xponit== 0 && model.yponit== 0)
        {
            distance = 10000000000;
        }else
        {
            QMapPoint point2 = QMapPointForCoordinate(CLLocationCoordinate2DMake(model.xponit,model.yponit));
            distance = QMetersBetweenMapPoints(point, point2);
        }
        model.distance = distance;
        DisArray[i] = model;
    }
    
    //距离的排序
    [DisArray sortUsingComparator:^NSComparisonResult(LivingModel *m1, LivingModel *m2) {
        return m1.distance < m2.distance ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    return DisArray;
}

@end
