//
//  BTFPeripheralTableViewController.h
//  BTF
//
//  Created by aimoke on 16/7/27.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTF.h"


@interface BTFPeripheralTableViewController : UITableViewController
@property (nonatomic ,strong) BTFPeripheralManager *peripheralManager;
@property (nonatomic ,strong) CBCentral *conntectedCentral;
@property (nonatomic ,strong) NSMutableDictionary *subscribedCharacteristicDic;

@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong,  nonatomic)CBMutableService *transferService;
@end
