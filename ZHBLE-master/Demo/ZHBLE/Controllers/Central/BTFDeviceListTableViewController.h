//
//  BTFDeviceListTableViewController.h
//  BTF
//
//  Created by aimoke on 15/7/17.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTF.h"
@interface BTFDeviceListTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *connectedDeviceArray;
@property (nonatomic, strong) NSMutableArray *findDeviceArray;
@property (nonatomic, strong) BTFCentral *central;
@property (nonatomic, strong) BTFPeripheral *connectedPeripheral;



@end
