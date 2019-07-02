//
//  BTFDeviceListTableViewController.m
//  BTF
//
//  Created by aimoke on 15/7/17.
//  Copyright (c) 2015年 zhuo. All rights reserved.
//


#define bleCellIdentifier @"searchBleCellIdentifier"

#import "BTFDeviceListTableViewController.h"
#import "BTFPeripheralserviceTableViewController.h"
#import "Constant.h"
#import "BTFStoredPeripherals.h"

@interface BTFDeviceListTableViewController ()

@end

@implementation BTFDeviceListTableViewController


#pragma mark - ViewLife cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan devices";
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    NSDictionary * opts = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
    {
        opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
    }
    self.central = [BTFCentral sharedBTFCentral];
    NSArray *storedArray = [BTFStoredPeripherals genIdentifiers];
    NSLog(@"storedIdentifier:%@",storedArray);
    NSArray *peripherayArray = nil;
    if (storedArray.count>0) {
       peripherayArray = [self.central retrievePeriphearlsWithIdentifiersBTF:storedArray];
    }
    self.connectedDeviceArray = [NSMutableArray arrayWithArray:peripherayArray];
    self.findDeviceArray = [NSMutableArray array];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scanBTF];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.central stopScan];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Interface
-(void)scanBTF
{
    WEAKSELF;
    NSArray *identifiers = [BTFStoredPeripherals genIdentifiers];
    NSLog(@"identifiers:%@",identifiers);

    NSArray *conectedPeripherals = [self.central retrievePeriphearlsWithIdentifiersBTF:identifiers];
    NSLog(@"have connceted peripheral:%@",conectedPeripherals);
    
    [conectedPeripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        BTFPeripheral *peripheral = obj;
        [weakSelf addPeripheralBTFToConnectedDevice:peripheral];
    }];
    
    //CBUUID *uuid = [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID];// You can use it test custom services
    NSArray *uuids = nil;//@[uuid];
    
    [self.central scanPeripheralWithServicesBTF:uuids options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @(YES)} onUpdated:^(BTFPeripheral *peripheral,NSDictionary *data){
        if (peripheral) {
            
             [weakSelf addPeripheralBTFToFindDevice:peripheral];
        }
       
    }];

}


-(void)addPeripheralBTFToFindDevice:(BTFPeripheral *)peripheral
{
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    for (BTFPeripheral *BTFPeripheral in self.findDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[BTFPeripheral.identifier UUIDString]]) {
            return;
        }
    }
    for (BTFPeripheral *BTFPeripheral in self.connectedDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[BTFPeripheral.identifier UUIDString]]) {
            return;
        }
    }
    [self.findDeviceArray addObject:peripheral];
    [self.tableView reloadData];
    
}

-(void)deletePeripheralInFindDevice:(BTFPeripheral *)peripheral
{
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    for (BTFPeripheral *BTFPeripheral in self.findDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[BTFPeripheral.identifier UUIDString]]) {
            [self.findDeviceArray removeObject:BTFPeripheral];
            [self.tableView reloadData];
            return;
        }
    }
   
}


-(void)addPeripheralBTFToConnectedDevice:(BTFPeripheral *)peripheral
{
    
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    
    for (BTFPeripheral *BTFPeripheral in self.connectedDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[BTFPeripheral.identifier UUIDString]]) {
            return;
        }
    }
    [self.connectedDeviceArray addObject:peripheral];
    [self.tableView reloadData];

}

-(void)deletePeripheralInConnectedDevice:(BTFPeripheral *)peripheral
{
    NSAssert(peripheral !=nil, @"peripheral can not nil");
    
    for (BTFPeripheral *BTFPeripheral in self.connectedDeviceArray) {
        if ([[peripheral.identifier UUIDString] isEqualToString:[BTFPeripheral.identifier  UUIDString] ]) {
            [self.connectedDeviceArray removeObject:BTFPeripheral];
            [self.tableView reloadData];
            return;
        }
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.connectedDeviceArray.count;
            break;
        case 1:
           return  self.findDeviceArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bleCellIdentifier forIndexPath:indexPath];
    
    BTFPeripheral *peripherial = nil;
    switch (indexPath.section) {
        case 0:
        {
            peripherial = [self.connectedDeviceArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = @"Connected";
        }
            break;
        case 1:
        {
            peripherial = [self.findDeviceArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = nil;
        }
            break;
            
        default:
            break;
    }
    if (peripherial.name && peripherial.name.length>0) {
         cell.textLabel.text = peripherial.name;
    }else
        cell.textLabel.text = [peripherial.identifier UUIDString];
   
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"My devices";
            break;
        case 1:
            return  @"Other devices";
            break;
            
        default:
            break;
    }
    return 0;

}


#pragma mark - tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTFPeripheral *peripheral = nil;
    switch (indexPath.section) {
        case 0:{
             peripheral = [self.connectedDeviceArray objectAtIndex:indexPath.row];
            //[self pushWithPeripheralBTF:peripheral];
        }
           
            break;
         case 1:
        {
             peripheral = [self.findDeviceArray objectAtIndex:indexPath.row];
            
        }
           
            break;
        default:
            break;
    }
    WEAKSELF;
    [self.central connectPeripheralBTF:peripheral options:nil onFinished:^(BTFPeripheral *peripheral, NSError *error){
        weakSelf.connectedPeripheral = peripheral;
        [weakSelf deletePeripheralInFindDevice:peripheral];
        [weakSelf addPeripheralBTFToConnectedDevice:peripheral];
        
        [peripheral.peripheral.services enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
            CBService *service = obj;
            NSLog(@"serviceUUID:%@",[service.UUID UUIDString]);
        }];
        [weakSelf pushWithPeripheralBTF:peripheral];
        [self.tableView reloadData];

    }];
}


#pragma mark - Push
-(void)pushWithPeripheralBTF:(BTFPeripheral *)peripheral
{
    [self performSegueWithIdentifier:@"serviceViewController" sender:peripheral];
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BTFPeripheralserviceTableViewController *serviceVC = [segue destinationViewController];
    BTFPeripheral *peripheral = (BTFPeripheral*)sender;
    
    serviceVC.connectedPeripheral = peripheral;
    serviceVC.title = peripheral.name;
    
}


@end
