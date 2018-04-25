//
//  NSObject+KVC.m
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/24.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import "NSObject+KVC.h"
#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation NSObject (KVC)
    -(void)h_setValue:(id)value forKey:(id)key{
        
        NSString* setterKey = [NSString stringWithFormat:@"set%@:",[key capitalizedString]];
        
        
        
//        struct objc_object class = {
//            .isa = object_getClass(self)//已废除
//        };
//
        SEL setterSel = NSSelectorFromString(setterKey);
        
        NSAssert(![self hasSelector:setterSel], @"%@并没有实现%@方法",object_getClass(self),setterKey);
        
        ((void(*)(id,SEL, id))objc_msgSend)(self,setterSel,value);
        
    
        
    }
    
    -(void)h_setValue:(id)value forKeyPath:(id)keyPath{
        NSArray* keys = [keyPath componentsSeparatedByString:@"."];
        
        
        
        
        id object = self;
        
        
        for(int i=0;i<keys.count;i++){
            NSString* key = keys[i];
            
            
            if(i < keys.count-1){
                
                
                NSString* getter = key;
                
                SEL getterSel = NSSelectorFromString(getter);
                NSAssert([self hasSelector:getterSel], @"%@并没有实现%@方法",object_getClass(self),getter);
                
                id (*objc_msgSend_hyp)(id, SEL) = (void *)objc_msgSend;
//                object = objc_msgSend_hyp(object,getterSel);
                
                object = objc_msgSend_hyp(object,getterSel);
                
            }else{
                NSString* setterKey = [NSString stringWithFormat:@"set%@:",[key capitalizedString]];
                SEL setterSel = NSSelectorFromString(setterKey);
                
                NSAssert([self hasSelector:setterSel], @"%@并没有实现%@方法",object_getClass(self),setterKey);
                
                void (*objc_msgSend_hyp)(id, SEL,id) = (void *)objc_msgSend;
                objc_msgSend_hyp(object,setterSel,value);
                
            }
 
        }
        
        
        
    }
    
    -(id)h_valueForKey:(id)key{
        SEL getterSel = NSSelectorFromString(key);
        NSAssert([self hasSelector:getterSel], @"%@并没有实现%@方法",object_getClass(self),key);
        id (* objc_msgSend_hyp)(id,SEL) = (void*) objc_msgSend;
        return objc_msgSend_hyp(self,getterSel);
    }
    -(id)h_valueForKeyPath:(id)keyPath{
        NSArray* keys = [keyPath componentsSeparatedByString:@"."];
        id object = self;
        
        
        for(int i=0;i<keys.count;i++){
            NSString* key = keys[i];
            SEL getterSel = NSSelectorFromString(key);
            NSAssert([self hasSelector:getterSel], @"%@并没有实现%@方法",object_getClass(self),keyPath);
            id (* objc_msgSend_hyp)(id,SEL) = (void*) objc_msgSend;
            
            if(i < keys.count-1){
        
                object = objc_msgSend_hyp(object,getterSel);
            }else{
                return objc_msgSend_hyp(object,getterSel);
            }
        }
        return nil;
    }
@end
