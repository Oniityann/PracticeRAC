//
//  RACSignalController.m
//  PracticeRAC
//
//  Created by 郑一楠 on 2017/6/15.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "RACSignalController.h"

@interface RACSignalController ()

@property (strong, nonatomic) RACCommand *command;
@property (strong, nonatomic) RACCommand *playCommand;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *playArray;
@property (strong, nonatomic) RACSubject *subject;

@end

@implementation RACSignalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self learnBind];
//    [self learnBindMore];
//    [self learnRACSubject];
//    [self learnRACCommand];
    [self PlayRACCommand];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - bind method

- (void)learnBind {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendNext:@4];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *bindSignal = [signal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSNumber *value, BOOL *stop) {
            value = @(value.integerValue * value.integerValue);
            return [RACSignal return:value];
        };
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)learnBindMore {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendNext:@4];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *bindSignal = [signal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSNumber *value, BOOL *stop) {
            NSNumber *returnValue = @(value.integerValue * value.integerValue);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (NSInteger i = 0; i < value.integerValue; i++) {
                    [subscriber sendNext:returnValue];
                    [subscriber sendCompleted];
                }
                return nil;
            }];
        };
    }];
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - RACCommnad

- (void)learnRACCommand {
    self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [self.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [self.array addObject:x];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.subject sendNext:nil];
        });
    }];
    
    [self.command execute:nil];
    
    [[self.subject skip:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", self.array);
    }];
}

- (void)PlayRACCommand {
    self.playCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber * _Nullable input) {
        [self.playArray addObject:input];
        return [RACSignal empty];
    }];
    
//    [[[self.playCommand execute:@3] doNext:^(id  _Nullable x) {
//        NSLog(@"in doNext: %@", self.playArray);
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"in subscrib doNext: %@", self.playArray);
//    }];
    
    [self.playCommand execute:@3];
    
    NSLog(@"after excute: %@", self.playArray);
}

#pragma mark - RACSubject

- (void)learnRACSubject {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1st Subscription: %@", x);
    }];

    [subject sendNext:@1];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2nd Subscription: %@", x);
    }];
    
    [subject sendNext:@2];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"3rd Subscription: %@", x);
    }];
    
    [subject sendNext:@3];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"4rd Subscription: %@", x);
    }];
    
    [subject sendCompleted];
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)playArray {
    if (!_playArray) {
        _playArray = @[@1, @2].mutableCopy;
    }
    return _playArray;
}

- (RACSubject *)subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

@end
