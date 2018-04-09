//
//  ViewController.m
//  UIAlertControllerCustom
//
//  Created by WJ on 2018/4/8.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import "ViewController.h"
#import "AlertControllerCustom.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    // 中间弹出
//    [[AlertControllerCustom shareInstance] showType:UIAlertControllerStyleAlert title:@"中间弹出" message:@"中间弹出" cancelTitle:@"取消" titleArray:@[@"123", @"234"] viewController:self view:nil confirm:^(NSInteger buttonTag) {
//
//        if (buttonTag == -1) {
//            NSLog(@"取消");
//        }
//        else {
//            NSLog(@"123");
//        }
//    }];
    
    [[AlertControllerCustom shareInstance] showType:UIAlertControllerStyleActionSheet title:@"" message:nil cancelTitle:@"取消" titleArray:@[@"123", @"234", @"2342", @"23242", @"1213"] viewController:self view:nil confirm:^(NSInteger buttonTag) {
        
        if (buttonTag == -1) {
            NSLog(@"取消");
        }
        else {
            NSLog(@"123");
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
