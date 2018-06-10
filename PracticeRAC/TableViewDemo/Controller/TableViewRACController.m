//
//  TableViewRACController.m
//  PracticeRAC
//
//  Created by Yinan Zheng on 2018/6/10.
//  Copyright © 2018 zyn. All rights reserved.
//

#import "TableViewRACController.h"
#import "TableViewRACViewModel.h"

@interface TableViewRACController () <UITableViewDataSource>

@property (strong, nonatomic) TableViewRACViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewRACController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [RACObserve(self, viewModel.dataSource) subscribeNext:^(id _Nullable x) {
        NSLog(@"data source: %@", x);
        [self.tableView reloadData];
        NSLog(@"data source address: %p", x);
    }];
    
    [RACObserve(self, viewModel.underTaker) subscribeNext:^(id  _Nullable x) {
        NSLog(@"under taker: %@", x);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[[self.viewModel.addItemCommand execute:@(1 + arc4random_uniform(10))] doNext:^(NSNumber *  _Nullable excute) {
            NSLog(@"excute: %@", excute);
        }] subscribeNext:^(NSNumber * _Nullable excute) {
            NSLog(@"excute: %@", excute);
        }];
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count > 0 ? self.viewModel.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.viewModel.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - lazy load

- (TableViewRACViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TableViewRACViewModel alloc] init];
    }
    return _viewModel;
}

@end
