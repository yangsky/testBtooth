//
//  BTFPeripheralserviceTableViewController.h
//  BTF
//
//  Created by aimoke on 15/7/20.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTF.h"

@interface BTFPeripheralserviceTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *serviceArray;
@property (nonatomic, strong) NSMutableArray *characteristicArray;

@property (nonatomic, strong) BTFPeripheral *connectedPeripheral;
@property (nonatomic, strong) NSString *testString;

@end
