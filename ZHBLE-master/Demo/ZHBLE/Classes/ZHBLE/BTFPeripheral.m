//
//  BTFPeripheral.m
//  BLE_iOS
//
//  Created by aimoke on 15/7/16.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#import "BTFPeripheral.h"
@interface BTFPeripheral()<CBPeripheralDelegate>
@property (nonatomic, copy)   BTFObjectChagedBlock didFinishServiceDiscovery;
@property (nonatomic, copy)   BTFPeripheralUpdateRSSIBlock rssiUpdated;
@property (nonatomic, strong) NSMutableDictionary * servicesFindingIncludeService; //callbacks for finding included Services of specified Service
@property (nonatomic, strong) NSMutableDictionary * characteristicsDiscoveredBlocks; //callbacks for finding Characteristics
@property (nonatomic, strong) NSMutableDictionary * descriptorDiscoveredBlocks;
@property (nonatomic, strong) NSMutableDictionary * characteristicsValueUpdatedBlocks; //read value callbacks
@property (nonatomic, strong) NSMutableDictionary * descriptorValueUpdatedBlocks;
@property (nonatomic, strong) NSMutableDictionary * characteristicValueWrtieBlocks; // write value callbacks for Characteristic
@property (nonatomic, strong) NSMutableDictionary * descriptorValueWrtieBlocks; // write value callbacks for Descriptor
@property (nonatomic, strong) NSMutableDictionary * characteristicsNotifyBlocks; //for Characteristics Notification
@end

@implementation BTFPeripheral

#pragma mark - Life cycle
-(void)dealloc
{
    _peripheral.delegate = nil;
}
#pragma mark － initialize methods
-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        self.servicesFindingIncludeService = [NSMutableDictionary dictionary];
        
        self.characteristicsDiscoveredBlocks = [NSMutableDictionary dictionary];
        self.descriptorDiscoveredBlocks = [NSMutableDictionary dictionary];
        
        self.characteristicsValueUpdatedBlocks =[NSMutableDictionary dictionary];
        self.descriptorValueUpdatedBlocks  =[NSMutableDictionary dictionary];
        
        self.characteristicValueWrtieBlocks =[NSMutableDictionary dictionary];
        self.descriptorValueWrtieBlocks =[NSMutableDictionary dictionary];
        
        
        self.characteristicsNotifyBlocks = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark propertys

-(NSString *)name
{
    if (!_name) {
        self.name = _peripheral.name;
    }
    return _name;
}

-(NSUUID *)identifier
{
    if (!_identifier) {
        @try {
            self.identifier = _peripheral.identifier;
        }
        @catch (NSException *exception) {
            //iOS 6
            NSString *uuidStr = _peripheral.identifier.UUIDString;
            self.identifier = [[NSUUID alloc]initWithUUIDString:uuidStr];
            NSLog(@"iOS6 identifier");
        }
        @finally {
            
        }
    }
    return _identifier;
}

-(NSNumber *)RSSI
{
    if (!_RSSI && self.state == CBPeripheralStateConnected) {
        [self readRSSIOnFinish:nil];
    }
    return _RSSI;
}

-(CBPeripheralState)state
{
    return self.peripheral.state;
}

-(NSArray *)services
{
    return _peripheral.services;
}

#pragma mark discovery services
-(void)discoverServices:(NSArray *)serviceUUIDs onFinish:(BTFObjectChagedBlock)discoverFinished
{
    NSAssert(discoverFinished !=nil, @"block finished must not be nil");
    self.didFinishServiceDiscovery = discoverFinished;
    if (_peripheral.state == CBPeripheralStateConnected){
        [_peripheral discoverServices:serviceUUIDs];
    }
    
}

-(void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service onFinish:(BTFSpecifiedServiceUpdatedBlock)finished
{
    NSAssert(finished!=nil, @"block finished must'not be nil!");
    _servicesFindingIncludeService[service.UUID] = finished;
    if (_peripheral.state == CBPeripheralStateConnected){
        [_peripheral discoverIncludedServices:includedServiceUUIDs forService:service];
    }
    
    
}

#pragma mark Discovering Characteristics and Characteristic Descriptors
-(void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service onFinish:(BTFSpecifiedServiceUpdatedBlock)onfinish
{
    NSAssert(onfinish!=nil, @"block onfinish must'not be nil!");
    _characteristicsDiscoveredBlocks[service.UUID] = onfinish;
    if (_peripheral.state == CBPeripheralStateConnected){
        [_peripheral discoverCharacteristics:characteristicUUIDs forService:service];
    }
}

-(void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic onFinish:(BTFCharacteristicChangeBlock)onfinish
{
    NSAssert(onfinish!=nil, @"block onfinish must'not be nil!");
    _descriptorDiscoveredBlocks[characteristic.UUID] = onfinish;
    if (_peripheral.state == CBPeripheralStateConnected){
        [_peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
    
}


#pragma mark Reading Characteristic and Characteristic Descriptor Values
-(void)readValueForCharacteristic:(CBCharacteristic *)characteristic onFinish:(BTFCharacteristicChangeBlock)onUpdate
{
    NSAssert(onUpdate!=nil, @"block onUpdate must'not be nil!");
    _characteristicsValueUpdatedBlocks[characteristic.UUID] = onUpdate;
    if (_peripheral.state == CBPeripheralStateConnected){
        [_peripheral readValueForCharacteristic:characteristic];
    }
    
}

-(void)readValueForDescriptor:(CBDescriptor *)descriptor onFinish:(BTFDescriptorChangedBlock)onUpdate
{
    NSAssert(onUpdate!=nil, @"block onUpdate must'not be nil!");
    _descriptorValueUpdatedBlocks[descriptor.UUID] = onUpdate;
    if (_peripheral.state == CBPeripheralStateConnected){
        [_peripheral readValueForDescriptor:descriptor];
    }
    
}

#pragma mark Writing Characteristic and Characteristic Descriptor Values
-(void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type onFinish:(BTFCharacteristicChangeBlock)onfinish
{
    if (type == CBCharacteristicWriteWithResponse) {
        NSAssert(onfinish!=nil, @"block onfinish must'not be nil!");
        _characteristicValueWrtieBlocks[characteristic.UUID] = onfinish;
        
    }
    if (_peripheral.state == CBPeripheralStateConnected) {
        [_peripheral writeValue:data forCharacteristic:characteristic type:type];
    }
    
}

-(void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor onFinish:(BTFDescriptorChangedBlock)onfinish
{
    if (onfinish) {
        _descriptorValueWrtieBlocks[descriptor.UUID] = onfinish;
        
    }
    if (_peripheral.state == CBPeripheralStateConnected)
    {
        [_peripheral writeValue:data forDescriptor:descriptor];
    }
    
}


#pragma mark Setting Notifications for a Characteristic’s Value
-(void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic onUpdated:(BTFCharacteristicChangeBlock)onUpdated
{
    if (enabled) {
        NSAssert(onUpdated!=nil, @"block onUpdated must'not be nil!");
        self.characteristicsNotifyBlocks[characteristic.UUID] =  onUpdated;
        
    }else{
        [self.characteristicsNotifyBlocks removeObjectForKey:characteristic.UUID];
    }
    if (_peripheral.state == CBPeripheralStateConnected) {
        [_peripheral setNotifyValue:enabled forCharacteristic:characteristic];
    }
    
}


#pragma mark ReadRSSI
-(void)readRSSIOnFinish:(BTFPeripheralUpdateRSSIBlock)onUpdated
{
    if (_peripheral && (_peripheral.state == CBPeripheralStateConnected)) {
        self.rssiUpdated = onUpdated;
        [_peripheral readRSSI];
    }
}

#pragma mark - Delegate
#pragma mark service discovery
-(void)peripheral:(CBPeripheral *)peripheral diddiscoverServices:(NSError *)error
{
    if (error) {
        [self cleanup];
    }
    if (peripheral == _peripheral) {
        if (self.didFinishServiceDiscovery) {
            self.didFinishServiceDiscovery(error);
            self.didFinishServiceDiscovery = nil;
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral diddiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        [self cleanup];
    }
    if (peripheral == _peripheral) {
        BTFSpecifiedServiceUpdatedBlock onfound = _servicesFindingIncludeService[service.UUID];
        if (onfound) {
            onfound(service,error);
            [_servicesFindingIncludeService removeObjectForKey:service.UUID];
        }
    }
}

#pragma mark Characteristic
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (peripheral ==_peripheral) {
        BTFSpecifiedServiceUpdatedBlock onfound = _characteristicsDiscoveredBlocks[service.UUID];
        if (onfound) {
            onfound(service,error);
            [_characteristicsDiscoveredBlocks removeObjectForKey:service.UUID];
            
        }
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral) {
        BTFCharacteristicChangeBlock onfound = _descriptorDiscoveredBlocks[characteristic.UUID];
        if (onfound) {
            onfound(characteristic,error);
            [_descriptorDiscoveredBlocks removeObjectForKey:characteristic.UUID];
        }
    }
    
}

#pragma mark Retrieving Characteristic and Characteristic Descriptor Values
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral) {
        BTFCharacteristicChangeBlock onupdate = _characteristicsValueUpdatedBlocks[characteristic.UUID];
        if (onupdate) {
            onupdate(characteristic,error);
            [_characteristicsValueUpdatedBlocks removeObjectForKey:characteristic.UUID];
        }else{
            onupdate = self.characteristicsNotifyBlocks[characteristic.UUID];
            if (onupdate) {
                onupdate(characteristic,error);
            }
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (peripheral == _peripheral) {
        BTFDescriptorChangedBlock onupdate = _descriptorValueUpdatedBlocks[descriptor.UUID];
        if (onupdate) {
            onupdate(descriptor,error);
            [_descriptorValueUpdatedBlocks removeObjectForKey:descriptor.UUID];
        }
    }
}

#pragma mark Writing Characteristic and Characteristic Descriptor Values
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral) {
        if ([characteristic.UUID.UUIDString isEqualToString:@"00006387-3C17-D293-8E48-14FE2E4DA212"]) {
            NSLog(@"receive DFU Trans Data responese");
        }
        BTFCharacteristicChangeBlock onwrite = _characteristicValueWrtieBlocks[characteristic.UUID];
        if (onwrite) {
            onwrite(characteristic,error);
            [_characteristicValueWrtieBlocks removeObjectForKey:characteristic.UUID];
        }
    }
}

#pragma mark Managing Notifications for a Characteristic’s Value
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral ==_peripheral && self.notificationStateChanged) {
        self.notificationStateChanged(characteristic,error);
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    if (peripheral == _peripheral) {
        self.RSSI = RSSI;
        if (self.rssiUpdated) {
            self.rssiUpdated(error,RSSI);
            self.rssiUpdated = nil;
        }
    }
}


#pragma mark Monitoring Changes to a Peripheral’s Name or Services

-(void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    if (peripheral ==_peripheral && self.onServiceModified) {
        self.onServiceModified(invalidatedServices);
    }
}

-(void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    if (peripheral == _peripheral && self.onNameUpdated) {
        self.onNameUpdated(nil);
    }
}

#pragma mark clearup
-(void)cleanup
{
    if (self.peripheral.state == CBPeripheralStateConnected) {
        return;
    }
    if (self.peripheral.services != nil) {
        for (CBService *service in self.peripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if (characteristic.isNotifying) {
                        [self.peripheral setNotifyValue:NO forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
}



@end
