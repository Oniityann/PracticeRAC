//
//  TableViewRACViewModel.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import "TableViewRACViewModel.h"

@interface TableViewRACViewModel ()

@property (copy, nonatomic, readwrite) NSArray *dataSource;
@property (strong, nonatomic, readwrite) NSMutableArray *underTaker;
@property (strong, nonatomic, readwrite) RACCommand *addItemCommand;

@end

@implementation TableViewRACViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.underTaker = [[NSMutableArray alloc] init];
        [self.addItemCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber * _Nullable x) {
            [self.underTaker addObject:x];
            self.dataSource = self.underTaker.copy;
        }];
    }
    return self;
}

- (RACCommand *)addItemCommand {
    if (!_addItemCommand) {
        _addItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _addItemCommand;
}

@end
