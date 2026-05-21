//
//  BogoDeductionModel.h
//
//
//  Created by JSONConverter on 2020/10/24.
//  Copyright © 2020年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BogoDeductionModelList: NSObject
@property (nonatomic, assign) NSInteger money_sum;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *sa_id;
@property (nonatomic, assign) NSInteger ticket;
@end

@interface BogoDeductionModel: NSObject
@property (nonatomic, strong) NSArray<BogoDeductionModelList *> *list;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *ticket_sum;
@end
