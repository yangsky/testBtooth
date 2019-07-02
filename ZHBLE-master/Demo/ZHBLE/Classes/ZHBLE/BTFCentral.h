//
//  BTFCentral.h
//  BLE_iOS
//
//  Created by aimoke on 15/7/15.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTFBlocks.h"
@class BTFPeripheral;

@interface BTFCentral : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *peripherals;
@property (nonatomic, readonly) CBManagerState state;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) CBCentralManager * manager;

@property (nonatomic, copy) BTFPeripheralUpdatedBlock onPeripheralUpdated;
@property (nonatomic, copy) BTFPeripheralDisConnectionBlock disConnectionBlock;
@property (nonatomic, copy) BTFCentralStateDidUpdatedBlock centralStateUpdateBlock;
@property (nonatomic, assign) BOOL scanStarted;
@property (nonatomic, strong) NSMutableArray * connectingPeripherals;
@property (nonatomic, strong) NSMutableArray * connectedPeripherals;
@property (nonatomic, strong) NSDictionary * initializedOptions;
@property (nonatomic, strong) NSMutableDictionary * connectionFinishBlocks;

#pragma mark initial Methods
+(BTFCentral *)sharedBTFCentral;

-(instancetype)initWithQueue:(dispatch_queue_t)queue;

-(instancetype)initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *)options;

#pragma mark scan or stopScan methods

/**
 Scan Peripheral with Services

 *  @param serviceUUIDs scan service uuids
 *  @param options options
 *  @param onUpdateBlock call back
 */
-(void)scanPeripheralWithServicesBTF:(NSArray *)serviceUUIDs options:(NSDictionary *)options onUpdated:(BTFPeripheralUpdatedBlock) onUpdateBlock;

/**
 *  stop scan
 */
-(void)stopScan;

#pragma mark Establishing or Canceling Connection
-(void)connectPeripheralBTF:(BTFPeripheral *)peripheral options:(NSDictionary *)options onFinished:(BTFPeripheralConnectionBlock) finished;
-(void)cancelPeripheralConnectionBTF:(BTFPeripheral *)peripheral onFinished:(BTFPeripheralConnectionBlock) ondisconnected;


#pragma mark retrieving Lists of Peripherals
-(NSArray *)retrieveConnectedPeripheralsWithServicesBTF:(NSArray *)serviceUUIDs NS_AVAILABLE(NA, 7_0);

-(NSArray *)retrievePeriphearlsWithIdentifiersBTF:(NSArray *)identifiers NS_AVAILABLE(NA, 7_0);


@end
