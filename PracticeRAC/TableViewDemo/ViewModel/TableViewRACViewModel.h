//
//  TableViewRACViewModel.h
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewRACViewModel : NSObject

@property (copy, nonatomic, readonly) NSArray *dataSource;
@property (strong, nonatomic, readonly) NSMutableArray *underTaker;
@property (strong, nonatomic, readonly) RACCommand *addItemCommand;

@end
