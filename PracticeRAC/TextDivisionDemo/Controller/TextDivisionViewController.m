//
//  TextDivisionViewController.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/1/2.
//  Copyright © 2018年 zyn. All rights reserved.
//

#import "TextDivisionViewController.h"

@interface TextDivisionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

NSInteger i = 0;

@implementation TextDivisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (self.textField.text.length > i) {
            if (self.textField.text.length % 5 == 4) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:x];
                [str insertString:@" " atIndex:(self.textField.text.length)];
                self.textField.text = str;
            }
            
            i = self.textField.text.length;

        }else if (self.textField.text.length < i){//删除
            if (self.textField.text.length % 5 == 4) {
                self.textField.text = [self.textField.text substringToIndex:(self.textField.text.length-1)];
            }
            i = self.textField.text.length;
        }
        self.label.text = x;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
