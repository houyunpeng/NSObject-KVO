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
#import "NSObject+KVC.h"
#import "FIrstViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface ViewController ()
{
    TestModel* _model;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[TestModel alloc] init];
    _model.name = @"hyp";
    _model.model = [[TestSubModel alloc] init];
    _model.model.name = @"abcd";

    
    
    //自定义实现带有block返回的KVO
//    [_model h_addObserver:self forKey:@"name" complete:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
//        NSLog(@"%@---%@-----%@----%@",observedObject,observedKey,oldValue,newValue);
//    }];
//    [_model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"---dafadf");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    FIrstViewController* first = [[FIrstViewController alloc] init];
//    first.model = _model;
//    [self.navigationController pushViewController:first animated:YES];
    
    
  
//    [_model setName:@"azzzzzz"];
    
    NSLog(@"1");

//    [_model h_setValue:@"hyp" forKey:@"name"];
    
    int a = arc4random()%100;
    
    
//    [_model h_setValue:[NSString stringWithFormat:@"hyp---%d",a] forKeyPath:@"model.name"];
//    NSLog(@"_model.model.name=%@",_model.model.name);

    NSString* name1 = [_model h_valueForKey:@"name"];
    NSString* name2 = [_model h_valueForKeyPath:@"model.name"];
    
//    id obj = [_model valueForKey:@".cxx_destruct"];
    NSLog(@"obj");
    
}

    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
