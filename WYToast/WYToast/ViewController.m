//
//  ViewController.m
//  WYToast
//
//  Created by 杨新威 on 2018/3/1.
//  Copyright © 2018年 杨新威. All rights reserved.
//

#import "ViewController.h"
#import "WYToast.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [WYToast showWithToast:@"密码错误"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
