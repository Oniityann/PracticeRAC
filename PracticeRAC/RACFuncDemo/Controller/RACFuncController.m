//
//  RACFuncController.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import "RACFuncController.h"
#import "RACFuncViewModel.h"
#import "NextControllerView.h"
#import "Account.h"

#import <YYModel/YYModel.h>

@interface RACFuncController ()

@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *multiResponseLabel;

@property (strong, nonatomic) RACFuncViewModel *viewModel;

@end

@implementation RACFuncController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self _flattenMap];
//    [self _map];
//    [self _concat];
//    [self _then];
//    [self _merge];
//    [self _combineLatest];
    [self _sequence];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_flattenMap {
    RAC(self, responseLabel.text) =
    [self.textFiled.rac_textSignal
     flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"Flatten map: %@", value]];
            [subscriber sendCompleted];
            return nil;
        }] distinctUntilChanged]
                doNext:^(id  _Nullable x) {
            NSLog(@"Flatten map do next: %@", x);
        }];
    }];
}

- (void)_map {
    RAC(self.responseLabel, text) =
    [self.textFiled.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"%ld", value.integerValue * value.integerValue];
    }];
}

- (void)_concat {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat: %@", x);
    }];
}

- (void)_then {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 注意使用then，之前信号的值会被忽略掉.
    [[signalA then:^RACSignal * _Nonnull{
        return signalB;
    }] subscribeNext:^(id  _Nullable x) {
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"then: %@", x);
    }];
    
    [[signalB doCompleted:^{
        NSLog(@"signal B completed, code line: %d", __LINE__);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal B: %@, code line: %d", x, __LINE__);
    }];
    
    [[signalA doCompleted:^{
        NSLog(@"signal A completed, code line: %d", __LINE__);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal A: %@, code line: %d", x, __LINE__);
    }];
}

- (void)_merge {
    RACSignal *signalA = self.userNameField.rac_textSignal;
    RACSignal *signalB = self.passwordField.rac_textSignal;
    
    RACSignal *mergedSinal = [signalA merge:signalB];
    
    [mergedSinal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)_combineLatest {
    
    /// User name: 18210263188
    /// password: 111111
    RAC(self.viewModel.account, phone) = self.userNameField.rac_textSignal;
    RAC(self.viewModel.account, password) = self.passwordField.rac_textSignal;
    
    RAC(self.userNameField, textColor) =
    [self.viewModel.validUserNameSignal
     map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor whiteColor] : [UIColor redColor];
    }];
    
    RAC(self.passwordField, textColor) =
    [self.viewModel.validPasswordSignal
     map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor whiteColor] : [UIColor redColor];
    }];
    
    RAC(self.loginButton, enabled) = self.viewModel.enableLoginSignal;
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.viewModel.loginCommand execute:nil];
    }];
    
    [RACObserve(self.viewModel, loginState) subscribeNext:^(id  _Nullable x) {
        
        switch ([x unsignedIntegerValue]) {
            case LoginStateSuccess: {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Login Success" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NextControllerView *view = [[NextControllerView alloc] initWithViewModel:self.viewModel];
                    [self.view addSubview:view];
                    [view show];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:NULL];
            }
                break;
                
            case LoginStateFailed: {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Login Failed" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:NULL];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)_sequence {
    NSArray *numbers = @[@1, @2, @3, @4];
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"Number array sequence signal: %@", x);
    }];
    
    NSDictionary *profile = @{@"name": @"Oniityann", @"age": @26};
    [profile.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"Profile dict sequence signal: %@", x);
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"Profile key: %@, profile value: %@", key, value);
    }];
    
    NSArray *fakeData = @[@{@"phone": @"18210263188", @"password": @"111111"},
                          @{@"phone": @"18210281732", @"password": @"111111"},
                          @{@"phone": @"18210263411", @"password": @"111111"},
                          @{@"phone": @"13352489469", @"password": @"111111"},
                          @{@"phone": @"13212311231", @"password": @"111111"},
                          @{@"phone": @"13810111011", @"password": @"111111"}];
    /// map:映射的意思，目的：把原始值value映射成一个新值
    NSArray<Account *> *tableViewData = [fakeData.rac_sequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"Sequence mapped value: %@", value);
        return [Account yy_modelWithDictionary:value];
    }].array;
    
    NSLog(@"Table view data source data: %@", tableViewData);
    NSLog(@"Phone number of the third row of the table view: %@", tableViewData[2].phone);
}

- (RACFuncViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RACFuncViewModel alloc] init];
    }
    return _viewModel;
}

@end
