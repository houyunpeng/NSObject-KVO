//
//  ObservationInfo.h
//  TestDaily
//
//  Created by 侯云鹏 on 2018/4/23.
//  Copyright © 2018年 侯云鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(id, NSString *, id, id);

@interface ObservationInfo : NSObject

    @property(nonatomic,strong)NSObject* observer;
    @property(nonatomic,copy)NSString* key;
    @property(nonatomic,copy)completeBlock block;
    
@end
