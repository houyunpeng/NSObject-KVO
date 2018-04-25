//
//  NSObject+KVO.h
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/23.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)
//自定义实现带有block返回的KVO
-(void)h_addObserver:(NSObject*)observer forKey:(NSString*)key complete:(void(^)(id observedObject, NSString *observedKey, id oldValue, id newValue))complete;


-(void)h_removeObserver:(NSObject *)observer forKey:(NSString *)key;
    
    
-(BOOL)hasSelector:(SEL)selector;
@end
