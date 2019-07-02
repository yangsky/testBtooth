//
//  BTFManager.m
//  BTF
//
//  Created by aimoke on 15/8/31.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#import "BTFManager.h"

@implementation BTFManager
+(BTFManager *)sharedBTFManager
{
    static BTFManager *_bleManagerFactory = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        _bleManagerFactory = [[BTFManager alloc]init];
    });
    return _bleManagerFactory;
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.connectPeripheral = nil;
    }
    return self;
}

@end
