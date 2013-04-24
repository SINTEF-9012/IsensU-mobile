//
//  bleConnect.m
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 01.10.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//


// Searches for and connects to BLE hardware


#import "bleConnect.h"


@implementation bleConnect


@synthesize cBReady;
@synthesize delegate;
@synthesize cBCM;


@synthesize foundPeripherals;
@synthesize connectedPeripherals;

@synthesize savedPeripherals;



// hvilken status har BLE hardwaren på ipaden/iphonen
// cBReady = true hvis BLE hardware finnes på enheten og er skrudd på og klar
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    // alloc the array foundPeripherals and connectedPeripherals
    self.foundPeripherals = [[NSMutableArray alloc] initWithObjects:nil];
    self.connectedPeripherals = [[NSMutableArray alloc] initWithObjects:nil];

    self.savedPeripherals = [[NSArray alloc] initWithObjects:nil];

    
    self.cBReady = false;
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            
            self.cBReady = true;
            
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}

/*------------DISCOVER-------------*/

// after Scan for peripherals-button is pushed, starts scanning
// when a BLE peripheral is discovered
// this callback method is for each found peripheral that matches
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"bleConnect. Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.UUID, advertisementData);
  
    
    //NSLog(@"Advertisementdata for peripheral %@", advertisementData.allValues);
    if(advertisementData.allValues ){
        
    }
    NSLog(@"peripheral UUID: %@", peripheral.UUID);

    NSString *tempName;
    
    // sometimes the name of the peripheral can be nil
    if(peripheral.name == nil){
        tempName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
        
    }
    else{
        tempName = peripheral.name;
    }
    
    if (peripheral.name == nil) {
        NSLog(@"name nil");

    }
    
    
    // if the peripheral is not already discovered
    else if (![foundPeripherals containsObject:peripheral]) {
        
        // if the name is nil
        if(peripheral.name == nil){
            [foundPeripherals removeObject:peripheral];

        }
        
        [foundPeripherals addObject:peripheral];
        //[discoveryDelegate discoveryDidRefresh];
        
        
        //- (void) foundPeripheral:(CBPeripheral *)p advertisementData:(NSDictionary *)advertisementData

        [self.delegate foundPeripheral:peripheral advertisementData:advertisementData];
        
        
        NSLog(@"adding peripheral %@", tempName);

        
    }

}


/*-----------CONNECT-----------*/


// connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Connected to peripheral: %@ with UUID: %@",peripheral,peripheral.UUID);
    
    // if the peripheral is not already connected
    if (![connectedPeripherals containsObject:peripheral]) {
        [connectedPeripherals addObject:peripheral];
        
        
        //NSLog(@"bleConnect didconnectperipheral", peripheral.name);
    
        //bleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //appDelegate.pName = peripheral.name;
    
        // so the peripheral can be accessed from the other views
        //appDelegate.peripheralG = peripheral;
    
        [self.delegate connectedPeripheral:peripheral];
    }
    /*if (![savedPeripherals containsObject:peripheral.UUID]) {
        [savedPeripherals arrayByAddingObject:peripheral.UUID];
        
        
        //NSLog(@"bleConnect didconnectperipheral", peripheral.name);
        
        //bleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //appDelegate.pName = peripheral.name;
        
        // so the peripheral can be accessed from the other views
        //appDelegate.peripheralG = peripheral;
        
    }*/

    
    //[self.delegate connectedPeripheral:peripheral];
    
    
}
// was not able to connect to peripheral
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Connection failed to peripheral: %@ with UUID: %@",peripheral,peripheral.UUID);

    [self.delegate failConnectPeripheral:peripheral];



}

// if disconnected
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Disconnected from peripheral: %@ with UUID: %@",peripheral,peripheral.UUID);
    //Do something when a peripheral is disconnected.
    
    
    // fjerne fra lista
    
    
    
    if ([connectedPeripherals containsObject:peripheral]) {
        [connectedPeripherals removeObject:peripheral];
        NSLog(@"Removed %@ from list of connected peripherals.", peripheral.name);
        
    }
    
    
    [self.delegate disconnectedPeripheral:peripheral];
    
    
    //bleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //appDelegate.pName = nil;

}

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    NSLog(@"Currently connected peripherals :");
    int i = 0;
    for(CBPeripheral *peripheral in peripherals) {
        NSLog(@"[%d] - peripheral : %@ with UUID : %@",i,peripheral,peripheral.UUID);
        //Do something on each connected peripheral.
    }
    
}

- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"Currently known peripherals:");
    
    int i = 0;
    for(CBPeripheral *peripheral in peripherals) {
        NSLog(@"[%d] - peripheral : %@ with UUID : %@",i,peripheral,peripheral.UUID);
        //Do something on each known peripheral.
    }
}



@end
