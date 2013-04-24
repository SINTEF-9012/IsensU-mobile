//
//  bleSecondViewController.m
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 15.09.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

// This class controls the second view, for showing info about a peripheral

#import "bleSecondViewController.h"

//@interface bleSecondViewController ()
//@end

@implementation bleSecondViewController

@synthesize secondViewText;
@synthesize appDelegate;
@synthesize peripheralName;
@synthesize connectedPeripheralPicker;
@synthesize connectedP;
@synthesize batteryView;
@synthesize servicesView;
@synthesize isConnectedView;

@synthesize peripheral;
@synthesize CBC;
@synthesize CBP;


- (void)viewDidLoad
{
    [super viewDidLoad];    
    appDelegate = [[UIApplication sharedApplication] delegate];    
    self.CBP = appDelegate.CBP;
    self.CBC = appDelegate.CBC;

    // Pickerview:
    connectedPeripheralPicker.delegate = self;
    
    // populate array for the picker
    connectedP = [[NSMutableArray alloc] initWithObjects:@"-", nil];
    
    /*
    // KVO - adding observer for temperature
    //[CBP addObserver:self forKeyPath:@"battery" options:NSKeyValueObservingOptionNew context:nil];
    
    
    NSString *contextP = self.CBP.currentPeripheral.name;

    
    //[self.CBP addObserver:self forKeyPath:@"battery" options:NSKeyValueObservingOptionNew context:(__bridge void *)(contextP)];

    [self.CBP addObserver:self forKeyPath:@"battery" options:NSKeyValueObservingOptionNew context:];
    
    NSLog(@"add oberserver for battery %@",self.CBP.currentPeripheral.name);
        */
    


}

// starts each time the view appears
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    //peripheralName = appDelegate.pName;

    [connectedP removeAllObjects];
    [connectedP addObject:@"-"];
    
    // the picker should show all connected peripherals
    NSMutableArray *temp = self.CBC.connectedPeripherals;

    
    // add connected peripherals 
    for (CBPeripheral *p in temp) {
        /*if (![connectedP containsObject:p.name]) {
            [connectedP addObject:p.name];
            NSLog(@"Adding to picker with connected peripherals: %@", p.name);
        
        }
        // if the peripheral is in the picker but is not connected anymore
        if(){
            
        }*/
        [connectedP addObject:p.name];
         
    }
    
    // reload peripheralPicker
    [connectedPeripheralPicker reloadAllComponents];
    
    
    // is the peripheral is disconnected - should remove the info
    // fungerer dette? burde jeg ikke heller sjekke om den er connected? nå sjekker jeg om det er en current
    if(self.CBP.currentPeripheral == nil){
        [secondViewText setText:[NSString stringWithFormat:@"Not connected to any sensor."]];
        [batteryView setText:[NSString stringWithFormat:@"-"]];
        [servicesView setText:[NSString stringWithFormat:@"-"]];

    }
    // there is one or more peripherals connected
    else {
        if(self.CBP.currentPeripheral.isConnected){
            [isConnectedView setText:[NSString stringWithFormat:@"%@ is connected", self.CBP.currentPeripheral.name]];

        }
        else{
            [isConnectedView setText:[NSString stringWithFormat:@"-"]];

            
        }
        
        if([self.CBP.healththermometerPeripherals containsObject:self.CBP.currentPeripheral]){
            [servicesView setText:[NSString stringWithFormat:@"Health thermometer (1809)"]];
            
        }
        else {
            [servicesView setText:[NSString stringWithFormat:@"-"]];

        }
        
        // henter batteriet i nsdictionary. key er peripheral
        NSString *currentBattery = [self.CBP.peripheralBatteryLevels objectForKey:[NSValue valueWithNonretainedObject:self.CBP.currentPeripheral]];
        NSString *procent = @"%";

        if(currentBattery == nil){
            currentBattery = @"n/a";
            procent = @"";
        }
        [batteryView setText:[NSString stringWithFormat:@"%@ %@ ", currentBattery, procent]];

        

        
    }
}

// Key-value observation - when the battery is updated
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj change:(NSDictionary *)change context:(void *)context
{
    //[batteryView setText:[NSString stringWithFormat:@"hjkbjkb"]];
    
    
    //[self.CBP.peripheralBatteryLevels setobject:self.CBP.battery forkey:[NSValue valueWithNonretainedObject:self.CBP.currentPeripheral]];

    
    //[self.CBP.peripheralBatteryLevels objectForKey:[NSValue valueWithNonretainedObject:self.CBP.currentPeripheral]];
    
    NSString *peripheralContext = (__bridge NSString *)(context);
    NSLog(@"nå dreper jeg snart noen %@", peripheralContext);

    
    
    NSLog(@"SecondViewController - CBP.battery is updated");

    if ([keyPath isEqualToString:@"battery"])
    {
        
        
        // batteriet er oppdatert. jeg vil lagre batterilevel i nsdictionary på riktig peripheral
        // finne riktig peripheral i nsdictionary, har navnet
        // lagre temp

        
        // putte verdien til riktig peripheral i dictionary
        
        
        
        // the battery is updated in the view
        CBPeripheral *p = nil;

        for (CBPeripheral *save in self.CBC.connectedPeripherals)
        {
            if([save.name isEqual:peripheralContext]){
                p = save;
            }
        }
        if(p == nil){
            NSLog(@"Could not retrive peripheral.....");
        }
        else{
            [self.CBP.peripheralBatteryLevels setObject:self.CBP.battery forKey:[NSValue valueWithNonretainedObject:p]];
            NSLog(@"satt value %@ for %@", self.CBP.battery, p.name);
            
            // henter batteriet i nsdictionary. key er peripheral
            //NSString *currentBattery = [self.CBP.peripheralBatteryLevels objectForKey:[NSValue valueWithNonretainedObject:self.CBP.currentPeripheral]];
            
            
            
            
            
            
            
            // find the right peripheral
            
            // find the peripherals batterylevel
            
            
            
            
            NSLog(@" batterylevels %@",self.CBP.peripheralBatteryLevels.allValues);
            
            
            
            
            
            // write value if the current peripheral batterylevel is the one updated
            if([peripheralContext isEqual: self.CBP.currentPeripheral.name]){
                
                
                // find the right peripheral using context
                
                // find the peripheral batterylevel
                
                CBPeripheral *p = nil;
                
                for (CBPeripheral *item in self.CBC.connectedPeripherals)
                {
                    if([item.name isEqual:peripheralContext]){
                        p = item;
                    }
                }
                if(p == nil){
                    NSLog(@"Could not retrive peripheral.....");
                }
                else{
                    NSString *currentBattery = [self.CBP.peripheralBatteryLevels objectForKey:[NSValue valueWithNonretainedObject:p]];
                    
                    
                    NSString *procent = @"%";
                    if(currentBattery == nil){
                        currentBattery = @"n/a";
                        procent = @"";
                    }
                    [batteryView setText:[NSString stringWithFormat:@"%@ %@ ", currentBattery, procent]];
                    
                    
                }


            }
            
        }
        
        
    }
}


- (void)viewDidUnload
{
    [self setSecondViewText:nil];
    [self setConnectedPeripheralPicker:nil];
    [self setBatteryView:nil];
    [self setServicesView:nil];
    [self setIsConnectedView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);

}



-(void) servicesRead {
    [secondViewText setText:[NSString stringWithFormat:@"Reading services\r"]];
    
    
}


- (void) updatedCharacteristic:(CBPeripheral *)peripheral sUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID data:(NSData *)data
{
    NSLog(@"updatedCharacteristic in viewController, %@, %@", data, cUUID);
    
    
    
    [secondViewText setText:[NSString stringWithFormat:@"Reading value: \r\n"]];
    
}

/*------------ FUNCTIONS FOR THE PICKER ---------------*/


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return connectedP.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [connectedP objectAtIndex:row];
}

// When a row in the pickerview is chosen
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // find the name of the peripheral on the right row in the array
    NSString *chosenPeripheral = [connectedP objectAtIndex:row];
    
    // if the string is -, no peripheral is chosen, should not do anything
    if ([chosenPeripheral isEqual: @"-"]) {
        
        [batteryView setText:[NSString stringWithFormat:@"-"]];
        [isConnectedView setText:[NSString stringWithFormat:@"-"]];

        [servicesView setText:[NSString stringWithFormat:@"-"]];
        [secondViewText setText:[NSString stringWithFormat:@"-"]];

        // using this in thirdViewController to show right peripheral
        self.CBP.currentPeripheral = nil;
        
        // her satt jeg også healtthermometerperiperals til nil

        
    }
    // a peripheral is chosen - show info
    if (![chosenPeripheral isEqual: @"-"]) {
        
        // find the name of the peripheral on the right row in the array
        NSString *chosenPeripheral = [connectedP objectAtIndex:row];
        
        NSLog(@"bleSecondViewController picker chose %@", chosenPeripheral);
        [secondViewText setText:[NSString stringWithFormat:@"Showing info for sensor %@", chosenPeripheral]];
        
        
        // find info about the peripheral that is chosen
        NSMutableArray *temp = self.CBC.connectedPeripherals;
        
        // find the right peripheral
        for (CBPeripheral *p in temp) {
            
            if ([p.name isEqual:chosenPeripheral]) {
                self.CBP.currentPeripheral = p;
                
                // using this in thirdViewController to check if the peripheral has a health thermometer
                for (CBPeripheral *htp in self.CBP.healththermometerPeripherals) {
                    if ([htp.name isEqual:chosenPeripheral]) {
                        
                        // TODO
                        
                        //self.CBP.htcBCP = htp;

                    }
                
                }
                
                if(p.isConnected){
                    [isConnectedView setText:[NSString stringWithFormat:@"%@ is connected", p.name]];
                    
                }
            }
        }
        
        // Not connected - something wrong
        //if (!self.CBP.cBCP.isConnected) {
        if (!self.CBP.currentPeripheral.isConnected) {

            
            NSLog(@"Disconnected from %@", self.CBP.currentPeripheral.name);
            [secondViewText setText:[NSString stringWithFormat:@"Error - disconnected from %@", self.CBP.currentPeripheral.name]];

        }
        // Connected - show info
        //if (self.CBP.cBCP.isConnected) {
        if (self.CBP.currentPeripheral.isConnected) {
            
            // get manifacturer name string
            //[self.CBP readCharacteristic:self.CBP.cBCP sUUID:@"180a" cUUID:@"2a29"];
            
            
            
            
            
            
            
            
            
            
            // check battery level
            
            // KVO - adding observer for temperature
            NSString *contextP = self.CBP.currentPeripheral.name;
            
            [self.CBP addObserver:self forKeyPath:@"battery" options:NSKeyValueObservingOptionNew context:(__bridge void *)(contextP)];
                        
            NSLog(@"add oberserver for battery %@",self.CBP.currentPeripheral.name);

            
            
            
            [self.CBP setNotificationForCharacteristic:self.CBP.currentPeripheral sUUID:@"180f" enable:TRUE];
            // write temperature again, or it will not show
            NSString *procent = @"%";
            
            // hente ut riktig peripheral - det er cuurentPreipheral?
            // hente riktig batteri for den peripheralen
            // skrive det ut
            
            NSString *currentBattery = [self.CBP.peripheralBatteryLevels objectForKey:[NSValue valueWithNonretainedObject:self.CBP.currentPeripheral]];

            if(currentBattery == nil){
                currentBattery = @"n/a";
                procent = @"";
            }
            [batteryView setText:[NSString stringWithFormat:@"%@ %@ ", currentBattery, procent]];

            NSLog(@"PICKEEER: %@ %@", self.CBP.currentPeripheral.name, currentBattery);
            
            for(id key in self.CBP.peripheralBatteryLevels) {
                id value = [self.CBP.peripheralBatteryLevels objectForKey:key];
                NSLog(@"arrayverdier %@", value);
            }
            
            
            //[self.CBP readCharacteristic:self.CBP.cBCP sUUID:@"180f" cUUID:@"2a1c"];
            
            
            // bruke read value isteden??
            
            
            
            // check for supported services:
            
            // check if the peripheral has a health thermometer
            /*for (CBPeripheral *p in self.CBP.healththermometerPeripherals) {
                
                if ([p.name isEqual:chosenPeripheral]) {

                    [servicesView setText:[NSString stringWithFormat:@"Health thermometer (1809)"]];

             
                }
            }*/
            if([self.CBP.healththermometerPeripherals containsObject:self.CBP.currentPeripheral]){
                [servicesView setText:[NSString stringWithFormat:@"Health thermometer (1809)"]];

            }
            else{
                [servicesView setText:[NSString stringWithFormat:@"-"]];

            }
   
            // write other values:
           [self.CBP readCharacteristic:self.CBP.currentPeripheral sUUID:@"180a" cUUID:@"2a29"];

            
            
        }
    }
    
}


@end
