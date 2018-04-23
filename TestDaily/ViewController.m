//
//  ViewController.m
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/20.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
#import "NSObject+KVO.h"
#import "FIrstViewController.h"
@interface ViewController ()
{
    TestModel* _model;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[TestModel alloc] init];
    _model.name = @"adfa";
    [_model h_addObserver:self forKey:@"name" complete:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@"%@---%@-----%@----%@",observedObject,observedKey,oldValue,newValue);
    }];
//    [_model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"---dafadf");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//        _model.name = [_model.name stringByAppendingString:@"na"];
    FIrstViewController* first = [[FIrstViewController alloc] init];
    first.model = _model;
    [self.navigationController pushViewController:first animated:YES];
    
}
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
