//
//  LoginViewController.m
//  PracticeRAC
//
//  Created by 郑一楠 on 2017/4/9.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"LoginDemo";
    
    RACSignal *validNameSignal = [self.nameField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 5);
    }];
    RACSignal *validPasswordSignal = [self.passwordField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 5);
    }];
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.nameField.rac_textSignal, self.passwordField.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return @([value[0] length] > 5 && [value[1] length] > 5);
    }];
    
    RAC(self.nameField, textColor) = [validNameSignal map:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@", value);
        return [value boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    
    RAC(self.passwordField, textColor) = [validPasswordSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    
    RAC(self.loginButton, backgroundColor) = [enableSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor blueColor] : [UIColor grayColor];
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"enable");
        return [RACSignal empty];
        // 真实操作
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            return nil;
//        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
