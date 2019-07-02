//
//  BTFBlocks.h
//  BLE_iOS
//
//  Created by aimoke on 15/7/16.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#ifndef BLE_iOS_BTFBlocks_h
#define BLE_iOS_BTFBlocks_h


#endif

#import <CoreBluetooth/CoreBluetooth.h>
@class BTFPeripheral;

//Central
typedef void (^BTFCharacteristicChangeBlock)(CBCharacteristic *characteristic,NSError *error);
typedef void (^BTFDescriptorChangedBlock)(CBDescriptor * descriptor, NSError * error);
typedef void (^BTFSpecifiedServiceUpdatedBlock)(CBService *service, NSError *error);
typedef void (^BTFObjectChagedBlock)(NSError *error);
typedef void (^BTFServicesUpdated)(NSArray *service);
typedef void (^BTFPeripheralUpdatedBlock)(BTFPeripheral *peripheral,NSDictionary *advertizeData);
typedef void (^BTFPeripheralConnectionBlock)(BTFPeripheral *peripheral, NSError*error);
typedef void (^BTFPeripheralDisConnectionBlock)(BTFPeripheral *peripheral, NSError*error);
typedef void (^BTFPeripheralUpdateRSSIBlock)(NSError *error, NSNumber *RSSI);
typedef void (^BTFCentralStateDidUpdatedBlock)(CBCentralManager *central);
//Peripheral
typedef void (^BTFPeripheralManagerStatedChangedBlock)(NSDictionary *state);
typedef void (^BTFCentralSubscriptionBlock)(CBCentral *central, CBCharacteristic *characteristic);
typedef void (^BTFCentralReadRequestBlock)(CBATTRequest *readRequest);
typedef void (^BTFCentralWriteRequestBlock)(NSArray *writeRequests);
