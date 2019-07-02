//
//  ZHPeripheralManager.h
//  BTF
//
//  Created by aimoke on 15/9/6.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTFBlocks.h"

@interface BTFPeripheralManager : NSObject
@property (nonatomic, readonly) BOOL isAdvertizing;
@property (nonatomic, readonly) CBManagerState state;
@property (nonatomic, copy) BTFObjectChagedBlock onStateUpdated;
@property (nonatomic, copy) BTFPeripheralManagerStatedChangedBlock onWillRestoreState;
@property (nonatomic, copy) BTFCentralSubscriptionBlock onSubscribedBlock;
@property (nonatomic, copy) BTFCentralSubscriptionBlock onUnsubscribedBlock;
@property (nonatomic, copy) BTFCentralReadRequestBlock onReceivedReadRequest;
@property (nonatomic, copy) BTFCentralWriteRequestBlock onReceiveWriteRequest;
@property (nonatomic, copy) BTFObjectChagedBlock onReadToUpdateSubscribers;

@property (nonatomic, strong) NSArray * services;
@property (nonatomic, strong) NSMutableArray *addedServices;
@property (nonatomic, strong) CBPeripheralManager * peripheralManager;

#pragma mark INIT Methods
+(BTFPeripheralManager *)sharedBTFPeripheralManager;


- (instancetype)initWithQueue:(dispatch_queue_t)queue;
- (instancetype)initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *)options NS_AVAILABLE(NA, 7_0);

#pragma mark Adding and Removing Services
- (void)addService:(CBMutableService *)service onFinish:(BTFSpecifiedServiceUpdatedBlock) onfinish;
- (void)removeService:(CBMutableService *)service;
- (void)removeAllServices;


#pragma mark Managing Advertising

- (void)startAdvertisingBTF:(NSDictionary *)advertisementData onStarted:(BTFObjectChagedBlock) onstarted;
- (void)stopAdvertisingBTF;


#pragma mark Sending Updates of a Characteristic’s Value

- (BOOL)updateValue:(NSData *)value forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:(NSArray *)centrals;

#pragma mark Responding to Read and Write Requests

- (void)respondToRequest:(CBATTRequest *)request withResult:(CBATTError)result;
#pragma mark Setting Connection Latency

- (void)setDesiredConnectionLatency:(CBPeripheralManagerConnectionLatency)latency forCentral:(CBCentral *)central;
@end
