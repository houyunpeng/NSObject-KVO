//
//  NSObject+KVO.m
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/23.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import "ObservationInfo.h"
#import <objc/message.h>
#define kPGKVOAssociatedObservers @"observerArrKey"

@implementation NSObject (KVO)

    

    
-(void)h_addObserver:(NSObject *)observer forKey:(NSString *)key complete:(completeBlock)complete
{
    SEL setterSel = NSSelectorFromString([self setterSELString:key]);
    Method setterMethod = class_getInstanceMethod([self class], setterSel);
    
    if(!setterMethod){
       NSAssert(NO, @"没有实现%@方法",NSStringFromSelector(setterSel));
    }
    
    Class class = object_getClass(self);
    NSString* className = NSStringFromClass(class);
    
    if(![className hasPrefix:@"hyp_"]){
        class = [self makeKvoClassWithOriginalClassName:className];
        object_setClass(self, class);
    }
    
    if(![self hasSelector:setterSel]){
        const char *types = method_getTypeEncoding(setterMethod);
        
//        Method methodClass = class_getInstanceMethod(class, setterSel);
        class_addMethod(class, setterSel, (IMP)kvo_setter, types);
    }
    
    NSMutableArray* observerArr = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));
    
    if(!observerArr){
        observerArr = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    ObservationInfo* info = [[ObservationInfo alloc] init];
    info.observer = observer;
    info.key = key;
    info.block = complete;
    
    [observerArr addObject:info];
    
    
}
    
    static void kvo_setter(id self,SEL _cmd,id newValue){
        NSString* setterName = NSStringFromSelector(_cmd);
        NSString* getterName = [self getterNameFromSetter:setterName];
        if(!getterName){
            NSAssert(NO, @"没有实现%@方法",getterName);
        }
        
        id oldValue = [self valueForKey:getterName];
        
        struct objc_super superclazz = {
            .receiver = self,
            .super_class = class_getSuperclass(object_getClass(self))

        };
         void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
        objc_msgSendSuperCasted(&superclazz, _cmd, newValue);

        NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));
        for (ObservationInfo *each in observers) {
            if ([each.key isEqualToString:getterName]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    each.block(self, getterName, oldValue, newValue);
                });
            }
        }
    }
    
    -(NSString*)getterNameFromSetter:(NSString*)settername{
        
        if([settername hasPrefix:@"set"]){
            NSString* methodString = [settername stringByReplacingOccurrencesOfString:@"set" withString:@""];
            methodString = [methodString stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            NSString* firstChar = [methodString substringToIndex:1];
            methodString = [NSString stringWithFormat:@"%@%@",[firstChar lowercaseString],[methodString substringFromIndex:1]];
            
            return methodString;
        }
        return [NSString stringWithFormat:@"get%@",[settername capitalizedString]];
    }

-(void)h_removeObserver:(NSObject *)observer forKey:(NSString *)key
{
    
    NSMutableArray* observerArr = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));
    
    ObservationInfo* observationInfo;
    for (ObservationInfo* obs in observerArr) {
        if( obs.observer == observer && [obs.key isEqualToString:key]){
            observationInfo = obs;
            break;
        }
    }
    
    [observerArr removeObject:observationInfo];
    
}
    
    -(BOOL)hasSelector:(SEL)selector
    {
        NSString* oriSelString = NSStringFromSelector(selector);
        unsigned int  count;
        Method* methods = class_copyMethodList([self class], &count);
        
        for(int i = 0;i < count;i++){
            
            Method m = methods[i];
            SEL sel = method_getName(m);
            NSString* selString = NSStringFromSelector(sel);
            if([selString isEqualToString:oriSelString]){
                return YES;
            }
            
        }
        return NO;
        
    }
    
    
    -(Class)makeKvoClassWithOriginalClassName:(NSString*)class{
        NSString* className = [NSString stringWithFormat:@"hyp_%@",class];
        Class clazz = NSClassFromString(className);
        if(clazz){
            return clazz;
        }
        
        Class oriClass = object_getClass(self);
        Class kvoClass = objc_allocateClassPair(oriClass, className.UTF8String, 0);
        Method classMethod = class_getClassMethod(oriClass, @selector(class));
        
        const char* types = method_getTypeEncoding(classMethod);
        
        Method methodClass = class_getInstanceMethod(kvoClass, @selector(class));
        
        
        
        class_addMethod(kvoClass, @selector(class), method_getImplementation(methodClass), types);
        objc_registerClassPair(kvoClass);
        return kvoClass;
        
    }
    
    
    
    
    
    
    
    -(NSString*) setterSELString:(NSString*)s
    {
        return [NSString stringWithFormat:@"set%@:",[s capitalizedString]];
    }
    
@end
