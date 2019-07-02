//
//  BTFManager.h
//  BTF
//
//  Created by aimoke on 15/8/31.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface BTFManager : NSObject

@property (nonatomic, strong) CBPeripheral *connectPeripheral;//current Connected device

+(BTFManager *)sharedBTFManager;

@end
