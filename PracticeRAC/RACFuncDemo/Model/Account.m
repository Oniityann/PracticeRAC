//
//  Account.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)accountWithPhone:(NSString *)phone password:(NSString *)password {
    Account *account = [[Account alloc] init];
    account.phone = phone;
    account.password = password;
    return account;
}

@end
