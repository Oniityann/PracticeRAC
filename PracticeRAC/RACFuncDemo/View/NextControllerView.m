//
//  NextControllerView.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import "NextControllerView.h"
#import "RACFuncViewModel.h"

@interface NextControllerView ()

@property (strong, nonatomic) RACFuncViewModel *viewModel;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *passwordLabel;

@end

@implementation NextControllerView

- (instancetype)initWithViewModel:(RACFuncViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        self.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.99];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [self configureSubviews];
        [self bindViewModel];
    }
    return self;
}

- (void)configureSubviews {
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    _nameLabel.textColor = [UIColor colorWithWhite:0.267 alpha:1];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.offset(-30);
    }];
    
    _passwordLabel = [UILabel new];
    _passwordLabel.font = [UIFont boldSystemFontOfSize:17];
    _passwordLabel.textColor = [UIColor colorWithWhite:0.267 alpha:1];
    [self addSubview:_passwordLabel];
    [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.offset(30);
    }];
}

- (void)bindViewModel {
    _nameLabel.text = _viewModel.account.phone;
    _passwordLabel.text = _viewModel.account.password;
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
