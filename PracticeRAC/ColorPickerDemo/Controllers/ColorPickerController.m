//
//  ColorPickerController.m
//  PracticeRAC
//
//  Created by 郑一楠 on 2017/4/9.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "ColorPickerController.h"

@interface ColorPickerController ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet UITextField *redField;
@property (weak, nonatomic) IBOutlet UITextField *greenField;
@property (weak, nonatomic) IBOutlet UITextField *blueField;

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (assign, nonatomic) CGFloat r;
@property (assign, nonatomic) CGFloat g;
@property (assign, nonatomic) CGFloat b;

@end

@implementation ColorPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.redField.text = @"0.500";
    self.greenField.text = @"0.500";
    self.blueField.text = @"0.500";
    RACSignal *rSignal = [self bindSlider:self.redSlider withTextField:self.redField];
    RACSignal *gSignal = [self bindSlider:self.greenSlider withTextField:self.greenField];
    RACSignal *bSignal = [self bindSlider:self.blueSlider withTextField:self.blueField];
    
    // combineLatest 需要所有信号都有新值
    RACSignal *colorSignal = [[RACSignal combineLatest:@[rSignal, gSignal, bSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1];
    }];
    
#if 0
    @weakify(self);
    [colorSignal subscribeNext:^(UIColor *  _Nullable color) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.colorView.backgroundColor = color;
        });
    }];
#endif
    
    RAC(self.colorView, backgroundColor) = colorSignal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (RACSignal *)bindSlider:(UISlider *)slider withTextField:(UITextField *)textField {
    
    // 使用通道终端进行双向绑定
    RACChannelTerminal *sliderChannelTerminal = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textChannelTerminal = [textField rac_newTextChannel];
    
    // slider 返回的浮点数非常长, 需先进行格式化
    [[sliderChannelTerminal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.3f", [value floatValue]];
    }] subscribe:textChannelTerminal];
    [textChannelTerminal subscribe:sliderChannelTerminal];
    
    RACSignal *textSignal = textField.rac_textSignal;
    
    // merge 不管先后顺序, 因为 combinelatest 需要所有信号都有新值, 所以在赋值的时候通过 merge textFild 的输入内容, 让其触发一次新值, 这样合并之后, 初始都触发了一次
    return [[sliderChannelTerminal merge:textChannelTerminal] merge:textSignal];
}

@end
