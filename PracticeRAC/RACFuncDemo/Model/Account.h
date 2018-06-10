//
//  Account.h
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *password;

+ (instancetype)accountWithPhone:(NSString *)phone password:(NSString *)password;

@end
