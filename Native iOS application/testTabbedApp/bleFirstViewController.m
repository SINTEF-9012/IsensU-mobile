//
//  bleFirstViewController.m
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 15.09.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

// This class controls the first view, the "Connect to peripheral" view


#import "bleFirstViewController.h"


//@interface bleFirstViewController ()
//@end

@implementation bleFirstViewController

@synthesize CBC;
@synthesize CBP;
@synthesize peripheral;
@synthesize appDelegate;

@synthesize scanButton;
@synthesize connectButton;
@synthesize firstViewText;
@synthesize scanServicesButton;
@synthesize peripheralPicker;
@synthesize foundPeripheralsName;
@synthesize savedSensorsButton;


// when the view is loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Initializing BLE");
    [firstViewText setText:[NSString stringWithFormat:@"%@Initializing...\r\n",firstViewText.text]];
    
    self.CBC = [bleConnect alloc];
    self.CBP = [bleDeviceControl alloc];
    if (self.CBC) {
        self.CBC.cBCM = [[CBCentralManager alloc] initWithDelegate:self.CBC queue:nil];
        self.CBC.delegate = self;
        
    }
    if(self.CBP){
        self.CBP.delegate = self;
    }
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.CBP = self.CBP;
    
    
    appDelegate.CBC = self.CBC;
    
    
    
    // pickerview:
    peripheralPicker.delegate = self;
    // populate array for the picker
    foundPeripheralsName = [[NSMutableArray alloc] initWithObjects:@"-", nil];
    
    
    [connectButton setEnabled:false];
    [scanServicesButton setEnabled:false];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [firstViewText flashScrollIndicators];
}


// release when view is unloaded
- (void)viewDidUnload
{
    [self setConnectButton:nil];
    [self setScanButton:nil];
    [self setFirstViewText:nil];
    [self setScanServicesButton:nil];
    [self setProgressViewBar:nil];
    [self setClearLogButton:nil];
    [self setPeripheralPicker:nil];
    [self setSavedSensorsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

// clears the log when clearLog-button is pushed
- (IBAction)clearLogButtonPress:(id)sender {
    
    [firstViewText setText:nil];
    
}

/*
// TODO
// hva gjør denne igjen?
- (void) updateLog:(NSString *)text {
    [firstViewText setText:[NSString stringWithFormat:@"%@%@\r\n",firstViewText.text,text]];
}
*/

/*------------ FUNCTIONS FOR THE PICKER ---------------*/


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return foundPeripheralsName.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [foundPeripheralsName objectAtIndex:row];
}

// When a row in the pickerview is chosen
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // find the name of the peripheral on the right row in the array
    NSString *chosenPeripheral = [foundPeripheralsName objectAtIndex:row];
    
    // if the string is -, no peripheral is chosen, but should change buttons
    if ([chosenPeripheral isEqual: @"-"]) {
        [self.connectButton setTitle:[NSString stringWithFormat:@"Choose a sensor to connect"]forState:UIControlStateNormal];

        [scanServicesButton setEnabled:false];
        [connectButton setEnabled:false];
        [firstViewText setText:[NSString stringWithFormat:@"- \r\%@\r", firstViewText.text]];

    }
    else if([chosenPeripheral isEqual: @"Name not found"]){
        [self.connectButton setTitle:[NSString stringWithFormat:@"Can not connect to this sensor."]forState:UIControlStateNormal];
        
        [scanServicesButton setEnabled:false];
        [connectButton setEnabled:false];
        [firstViewText setText:[NSString stringWithFormat:@"Can not connect to this sensor. Try restarting it. \r\%@\r", firstViewText.text]];
    }
    else if (![chosenPeripheral isEqual: @"-"]) {
        
   
        // show info for the chosen peripheral
    
        // find the name of the peripheral on the right row in the array
        NSString *pickerPeripheral = [foundPeripheralsName objectAtIndex:row];
        
        NSLog(@"bleFirstViewController picker chose %@", chosenPeripheral);
        [firstViewText setText:[NSString stringWithFormat:@"Showing info for sensor %@\r\%@\r", pickerPeripheral, firstViewText.text]];
        
        
        // connect to the peripheral that is chosen
        NSMutableArray *temp = self.CBC.foundPeripherals;

        // find the right one
        for (CBPeripheral *p in temp) {

            if ([p.name isEqual:chosenPeripheral]) {
                self.CBP.chosenPeripheral = p;
            }
        }
    
        // Change titile of connect button
        // Must chect if the peripheral already is connected or not
        // Not connected - could connect
        if (!self.CBP.chosenPeripheral.isConnected) {
            [self.connectButton setTitle:[NSString stringWithFormat:@"Connect %@", self.CBP.chosenPeripheral.name]forState:UIControlStateNormal];
            [connectButton setEnabled:true];
            [scanServicesButton setEnabled:false];


        }
        // Connected - could disconnect
        if (self.CBP.chosenPeripheral.isConnected) {
            
            [self.connectButton setTitle:[NSString stringWithFormat:@"Disconnect %@", self.CBP.chosenPeripheral.name]forState:UIControlStateNormal];
            [connectButton setEnabled:true];
            [scanServicesButton setEnabled:true];

        }
    }
    
}

/*------------ SCAN ---------------*/

// when the scan-button is pressed
- (IBAction)scanButtonPress:(id)sender {
    
    //NSLog(@"title on label scanbutton: %@", scanButton.titleLabel.text);
    

    // if ready to start scanning
    if (self.CBC.cBReady & ([scanButton.titleLabel.text isEqual:@"Start scan"])) {
        // BLE hardware is ready start scanning for peripherals
        NSLog(@"Button pressed, start scanning ...");
        [self.scanButton setTitle:@"Stop scan" forState:UIControlStateNormal];
        [firstViewText setText:[NSString stringWithFormat:@"Scanning for Bluetooth Smart sensors... \r\%@\r", firstViewText.text]];

        // scanning:
        // both options nil - looks for any BLE devices
        [self.CBC.cBCM scanForPeripheralsWithServices:nil options:nil];
            
        // TODO:
        // add scanning with options

        }
    
    // if already scanning and button is pressed, should stop scan
    else if ([scanButton.titleLabel.text isEqual:@"Stop scan"]) {
        NSLog(@"Stopped scanning.");

        [self.scanButton setTitle:@"Start scan" forState:UIControlStateNormal];
        [firstViewText setText:[NSString stringWithFormat:@"Stopped scanning for sensors. \r\%@\r", firstViewText.text]];

        [self.CBC.cBCM stopScan];

    }
}

- (IBAction)savedSensorsButtonPress:(id)sender {
    
    [self.CBC.cBCM retrievePeripherals:self.CBC.savedPeripherals];
    
    
    
}

// when a BLE peripheral is found
// this is set in centralmanager:didDiscoverPeripheral
- (void) foundPeripheral:(CBPeripheral *)p advertisementData:(NSDictionary *)advertisementData
{
    
    // sets the CBP.peripheral to the one i just found:
    //self.CBP.cBCP = p;
    
    
    
    NSString *tempName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];

    
    NSLog(@"bleFirstViewController.foundPeripheral %@", tempName);
    
    
    [firstViewText setText:[NSString stringWithFormat:@"Found Bluetooth Smart sensor: %@\r\%@\r", p.name, firstViewText.text]];
        
    if([p.name isEqual:nil]){
        NSLog(@"ERROR - firstViewController. peripheral is nil");
        [firstViewText setText:[NSString stringWithFormat:@"Error, could not connect sensor. Try again."]];

    }
    else{
        if(p.name == nil){
            
            [foundPeripheralsName addObject:@"Name not found"];

        }
        else{
            [foundPeripheralsName addObject:p.name];

        }

    }


    // reload peripheralPicker
    [peripheralPicker reloadAllComponents];

    
}

// TODO
// fix stop scan?
- (void) stopScan {
    
    
}




/*-------------CONNECT--------------*/


// when the connectbutton is pressed
- (IBAction)connectButtonPress:(id)sender {
    
    NSLog(@"pressed connectButton");
    
    
    if(self.CBP.chosenPeripheral) {
            if(!self.CBP.chosenPeripheral.isConnected) {
 
            
                
                [firstViewText setText:[NSString stringWithFormat:@"Trying to connect to %@...\r%@", self.CBP.chosenPeripheral.name, firstViewText.text]];


                // connecting to peripheral
                [self.CBC.cBCM connectPeripheral:self.CBP.chosenPeripheral options: @{CBConnectPeripheralOptionNotifyOnConnectionKey: @NO,
                    CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                    CBConnectPeripheralOptionNotifyOnNotificationKey: @NO}];
                
                                                
                [self.connectButton setTitle:[NSString stringWithFormat:@"Disconnect %@", self.CBP.chosenPeripheral.name]forState:UIControlStateNormal];
                
                
            }
            else {
                // don´t connect
                [self.CBC.cBCM cancelPeripheralConnection:self.CBP.chosenPeripheral];
                [self.connectButton setTitle:@"Choose a sensor to connect" forState:UIControlStateNormal];
                
                // TODO
                // hvis man disconnecter fra en peripheral skal scanservices button følge med..
                [self.scanServicesButton setTitle:@"Scan for services" forState:UIControlStateNormal];
                //[scanServicesButton setEnabled:false];

            }
        }
}

// has connected to peripheral
-(void) connectedPeripheral:(CBPeripheral *)p
{
    [scanServicesButton setEnabled:true];
    NSLog(@"bleFirstViewController.connectedPeripheral");
    
    // include rssi check
    //[NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(updateRSSITimer:) userInfo:nil repeats:NO];
    
    
    [firstViewText setText:[NSString stringWithFormat:@"Connected to %@\r%@", p.name, firstViewText.text]];
    
    
    // put the peripheral in the batterylevel nsdictionary
    [self.CBP.peripheralBatteryLevels setObject:@"-" forKey:[NSValue valueWithNonretainedObject:p]];
    
    NSLog(@"firstViewController batterylevels %@ %@",self.CBP.peripheralBatteryLevels.allValues, self.CBP.peripheralBatteryLevels.allKeys);

    
    
    // scan services
    //[self.CBP.currentPeripheral discoverServices:[CBUUID UUIDWithString:@"1809"]];

    //[self.CBP.currentPeripheral discoverServices:[NSArray arrayWithObject: [CBUUID UUIDWithString:@"180f"]]];

    //[self.CBP.chosenPeripheral discoverServices: nil];

    
    
    NSLog(@"service scan for temperature and battery");
    
    [self.CBP.chosenPeripheral setDelegate:self.CBP];
    
    // kaller discoverServices
    // hvis nil - alle services hvis funnet. ellers kan servicen spesifiseres
    // 1809 er health thermometer
   
    [self.CBP.chosenPeripheral discoverServices:[NSArray arrayWithObject: [CBUUID UUIDWithString:@"1809"]]];

    [self.CBP.chosenPeripheral discoverServices:[NSArray arrayWithObject: [CBUUID UUIDWithString:@"180f"]]];
    
    [firstViewText setText:[NSString stringWithFormat:@"Scanning for services\r%@",firstViewText.text]];
    
    

    
    
}
-(void) failConnectPeripheral:(CBPeripheral *)p
{
    NSLog(@"bleFirstViewController.failConnectPeripheral");
    [firstViewText setText:[NSString stringWithFormat:@"Failed to connect to %@\r%@", p.name, firstViewText.text]];
    
    
    [self.connectButton setTitle:[NSString stringWithFormat:@"Connect %@", self.CBP.chosenPeripheral.name]forState:UIControlStateNormal];

    [connectButton setEnabled:true];

    
    
}


-(void) disconnectedPeripheral:(CBPeripheral *)p
{
    
    // do something if the disconnection was unintentional - the button eas not clicked
    // should reconnect
    
    
    
    [scanServicesButton setEnabled:false];
    
    [self.connectButton setTitle:[NSString stringWithFormat:@"Choose a peripheral to connect"]forState:UIControlStateNormal];
    
    
    NSLog(@"bleFirstViewController.disconnectedPeripheral");
    
    [firstViewText setText:[NSString stringWithFormat:@"Disconnected \r%@",firstViewText.text]];
    
}



/*-------------SERVICES--------------*/



- (IBAction)scanServicesButtonPress:(id)sender {
    NSLog(@"Starting Service Scan !");
    
    [self.CBP.chosenPeripheral setDelegate:self.CBP];
    
    // kaller discoverServices
    // hvis nil - alle services hvis funnet. ellers kan servicen spesifiseres
    // 1809 er health thermometer
    //[self.CBP.cBCP discoverServices:[NSArray arrayWithObject: [CBUUID UUIDWithString:@"1809"]]];
    [self.CBP.chosenPeripheral discoverServices: nil];

    
    [self.scanServicesButton setTitle:@"Scanning for services" forState:UIControlStateNormal];
    [firstViewText setText:[NSString stringWithFormat:@"Scanning for services\r%@",firstViewText.text]];


}


-(void) servicesRead {
    [firstViewText setText:[NSString stringWithFormat:@"Reading services\r%@",firstViewText.text]];

    
}


/*
-(void) updatedRSSI:(CBPeripheral *)peripheral {
    NSLog(@"RSSI updated : %d",self.peripheral.RSSI.intValue);
    int barValue = self.peripheral.RSSI.intValue;
    barValue +=100;
    if (barValue > 100) barValue = 100;
    else if (barValue < 0) barValue = 0;
    //[RSSIBar setProgress:(float)((float)barValue / (float)100)];
    
    //Trigger next round of measurements in 5 seconds :
    [NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(updateRSSITimer:) userInfo:nil repeats:NO];
    
}*/

/*
// TODO
// hva i all verden er dette??
- (void) updateRSSITimer:(NSTimer *)timer {
    if (self.CBP.currentPeripheral.isConnected) {
        [self.CBP.currentPeripheral readRSSI];
    }
}
*/




/*------------CHARACTERISTICS----------------*/


- (void) updatedCharacteristic:(CBPeripheral *)peripheral sUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID data:(NSData *)data
{
    NSLog(@"updatedCharacteristic in viewController, %@, %@", data, cUUID);
    
    
    
    [firstViewText setText:[NSString stringWithFormat:@"%@Reading value: \r\n",firstViewText.text]];

    //[self updateCMLog:@"updatedCharacteristic in viewController"];
    //[self updateCMLog:[NSString stringWithFormat:@"Updated characteristic %@ - %@ | %@",sUUID,cUUID,data]];
}


/*
// read characteristic
- (IBAction)readCButtonPush:(id)sender {
    NSLog(@"firstviewcontroller.readcbuttonclick");
    
    // leser fra health thermometer
    // 2a1c is temperature measurement
    [self.CBP readCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2a1c"];
    
    //[firstViewText setText:[NSString stringWithFormat:@"Read characteristics \r\n%@",firstViewText.text]];

    
}
- (IBAction)writeCButtonPush:(id)sender {
    NSLog(@"firstviewcontroller.writecbuttonclick");

    unsigned char data = 0x02;
    [self.CBP writeCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2902" data:[NSData dataWithBytes:&data length:1]];
    
}

- (IBAction)notifyCButtonPush:(id)sender {
    NSLog(@"firstview notifyBP, CBP");
    [self.CBP setNotificationForCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2a1c" enable:TRUE];
    
}
*/

@end