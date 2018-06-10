//
//  ViewController.m
//  PracticeRAC
//
//  Created by 郑一楠 on 2017/4/4.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ColorPickerController.h"
#import "RACSignalController.h"
#import "QueueViewController.h"
#import "TableViewRACController.h"
#import "RACFuncController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *demos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.demos = @[@"LoginViewController",
                   @"ColorPickerController",
                   @"RACSignalController",
                   @"QueueViewController",
                   @"TextDivisionViewController",
                   @"TableViewRACController",
                   @"RACFuncController"];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleBezel;
    
    RACSignal *enableSignal = [textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 6);
    }];
    
    RACSignal *viewDidAppearSignal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    [viewDidAppearSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

    button.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[[NSDate date] description]];
                [subscriber sendCompleted];
            });
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号被销毁----->%@", [self class]);
            }];
        }];
    }];
    
    
    
#if 0
    [button.rac_command.executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
        }];
    }];
#endif
    
    [button.rac_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Time" message:[NSString stringWithFormat:@"%@", x] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"123");
            }]];
            [self presentViewController:ac animated:YES completion:nil];
        });
    }];
    
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        
//    }];
    
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [self.view addSubview:textField];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(70);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(button.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];

    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:tableView];

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button).offset(100);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    self.tableView = tableView;
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.demos[indexPath.row];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.demos[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = [class new];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

@end
