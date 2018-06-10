//
//  RACFuncViewModel.h
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

typedef NS_ENUM(NSUInteger, LoginState) {
    LoginStateUnlogin,
    LoginStateSuccess,
    LoginStateFailed,
};

@interface RACFuncViewModel : NSObject

@property (strong, nonatomic, readonly) RACSignal *enableLoginSignal;
@property (strong, nonatomic, readonly) RACSignal *validUserNameSignal;
@property (strong, nonatomic, readonly) RACSignal *validPasswordSignal;

@property (strong, nonatomic, readonly) RACCommand *loginCommand;

@property (assign, nonatomic, readonly) LoginState loginState;

@property (strong, nonatomic) Account *account;

@end
