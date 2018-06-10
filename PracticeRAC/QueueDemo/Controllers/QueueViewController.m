//
//  QueueViewController.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2017/8/14.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "QueueViewController.h"

@interface QueueViewController ()

@end

@implementation QueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self addSignal];
    [self addSequence];
}

- (void)addSignal {
    __block NSInteger a = 5;
    RACSignal *testSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // side effect
    [testSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%ld", a);
    }];
    
    [testSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%ld", a);
    }];
    
    __block NSInteger b = 5;
    RACSignal *testS = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        b += 5;
        [subscriber sendNext:@(b)];
        [subscriber sendCompleted];
        return nil;
    }] replayLast];
    
    [testS subscribeNext:^(id  _Nullable x) {
        NSLog(@"%ld", b);
    }];
    
    [testS subscribeNext:^(id  _Nullable x) {
        NSLog(@"%ld", b);
    }];
}

- (void)addSequence {
    // 初始化的时候内容已经形成
    NSArray *arr = @[@1, @2];
    RACSequence *seq = [arr rac_sequence];
    
    // map
    NSArray *arrSeq = [[seq map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue]);
    }] array];
    NSLog(@"%@", arrSeq);
    
    // filter
    NSArray *filterArr = @[@(1), @(2), @(3), @(4), @(5)];
    RACSequence *filterSeq = [filterArr rac_sequence];
    NSArray *filteredArr = [[filterSeq filter:^BOOL(id  _Nullable value) {
        return [value integerValue] % 2 == 1;
    }] array];
    NSLog(@"%@", filteredArr);
    
    // flattenMap 先 map 再 flatten
    NSArray *fA1 = @[@1, @2];
    NSArray *fA2 = @[@1, @3];
    RACSequence *fA1Seq = [fA1 rac_sequence];
    RACSequence *fA2Seq = [fA2 rac_sequence];
    NSArray *fA3 = @[fA1Seq, fA2Seq];
    RACSequence *flattenMapSeq = [fA3 rac_sequence];
    RACSequence *fS = [flattenMapSeq flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
//        return [value filter:^BOOL(id  _Nullable value) {
//            return [value integerValue] % 2 == 0;
//        }];
        return value;
    }];
    NSLog(@"%@", [fS array]);
    
    // concat
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
