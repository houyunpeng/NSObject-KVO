//
//  FIrstViewController.m
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/23.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import "FIrstViewController.h"
#import "NSObject+KVO.h"
@interface FIrstViewController ()

@end

@implementation FIrstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_model h_addObserver:self forKey:@"name" complete:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@" first:   %@---%@-----%@----%@",observedObject,observedKey,oldValue,newValue);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
    {
        _model.name = [_model.name stringByAppendingString:@"na"];
    }
    -(void)dealloc
    {
        [_model h_removeObserver:self forKey:@"name"];
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
