//
//  NextControllerView.h
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACFuncViewModel;

@interface NextControllerView : UIView

- (instancetype)initWithViewModel:(RACFuncViewModel *)viewModel;

- (void)show;

@end
