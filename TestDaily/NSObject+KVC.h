//
//  NSObject+KVC.h
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/24.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVC)

-(void)h_setValue:(id)value forKey:(id)key;
-(void)h_setValue:(id)value forKeyPath:(id)keyPath;

-(id)h_valueForKey:(id)key;
-(id)h_valueForKeyPath:(id)keyPath;
@end
