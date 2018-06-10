//
//  RACFuncViewModel.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import "RACFuncViewModel.h"

@interface RACFuncViewModel ()

@property (strong, nonatomic, readwrite) RACSignal *enableLoginSignal;
@property (strong, nonatomic, readwrite) RACSignal *validUserNameSignal;
@property (strong, nonatomic, readwrite) RACSignal *validPasswordSignal;

@property (strong, nonatomic, readwrite) RACCommand *loginCommand;

@property (assign, nonatomic, readwrite) LoginState loginState;

@end

@implementation RACFuncViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.loginState = LoginStateUnlogin;
    
    self.account = [Account accountWithPhone:@"0" password:@"0"];
    
    self.validUserNameSignal = [[RACObserve(self.account, phone) map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidPhone:value]);
    }] distinctUntilChanged];
    
    self.validPasswordSignal = [[RACObserve(self.account, password) map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidPassword:value]);
    }] distinctUntilChanged];
    
    self.enableLoginSignal = [[RACSignal combineLatest:@[RACObserve(self.account, phone), RACObserve(self.account, password)] reduce:^id(NSString *phoneNumber, NSString *password){
        return @([self isValidPhone:phoneNumber] && [self isValidPassword:password]);
    }] distinctUntilChanged];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
            RACTuple *accountTuple = [RACTuple tupleWithObjects:self.account.phone, self.account.password, nil];
            [subscriber sendNext:accountTuple];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple * _Nullable x) {
        if ([x.first isEqualToString:@"18210263188"] &&
            [x.second isEqualToString:@"111111"]) {
            self.loginState = LoginStateSuccess;
        } else {
            self.loginState = LoginStateFailed;
        }
    }];
}

- (BOOL)isValidPhone:(NSString *)phone {
    return phone.length == 11;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 5;
}

@end
