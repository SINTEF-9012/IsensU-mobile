//
//  bleThirdViewController.m
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 03.12.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

// This class controls the third view, for showing output from the healt thermometer in a peripheral

#import "bleThirdViewController.h"

//@interface bleThirdViewController ()
//@end

@implementation bleThirdViewController

@synthesize CBP;
@synthesize CBC;
@synthesize temperatureButton;
@synthesize appDelegate;
@synthesize pName;
@synthesize peripheralName;
@synthesize temperatureInterval;
@synthesize thirdTextView;
@synthesize peripheral;

@synthesize temperatureTextView;
@synthesize peripheralView;
@synthesize supportedView;


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    self.CBP = appDelegate.CBP;
    
    if(appDelegate.CBP == NULL){
        NSLog(@"ThirdViewController error - object is null");
    }
       
    // KVO - adding observer for temperature
    [CBP addObserver:self forKeyPath:@"temperature" options:NSKeyValueObservingOptionNew context:nil];

    
}


// starts each time the view appears
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //appDelegate = [[UIApplication sharedApplication] delegate];
    
    // not chosen a peripheral
    if(self.CBP.currentPeripheral == nil){
        // temperatureButton deactivated
        [temperatureButton setEnabled:false];
        
        [thirdTextView setText:[NSString stringWithFormat:@"Choose peripheral in peripheral view\n"]];
        [peripheralView setText:[NSString stringWithFormat:@"-\n"]];
        [self setValueTemperatureTextView:[NSString stringWithFormat:@"-"]];
        [supportedView setText:[NSString stringWithFormat:@"-"]];

        [peripheralView setText:[NSString stringWithFormat:@"No connected peripheral chosen"]];


    }
    
    // a connected peripheral chosen
    else if(self.CBP.currentPeripheral.isConnected){
        
        // temperatureButton activated if the peripheral supports health thermometer
        // check if health thermometer is supported
        bool ht = false;
        for (CBPeripheral *p in self.CBP.healththermometerPeripherals) {
            
            if ([p.name isEqual:self.CBP.currentPeripheral.name]) {
                ht = true;
            }
        }
        if(ht){
            [temperatureButton setEnabled:true];
            [supportedView setText:[NSString stringWithFormat:@"Health thermometer supported by %@", self.CBP.currentPeripheral.name]];

        }
        else{
            [temperatureButton setEnabled:false];
            [self setValueTemperatureTextView:[NSString stringWithFormat:@"-"]];

            [supportedView setText:[NSString stringWithFormat:@"Health thermometer not supported by peripheral"]];
        }
        
        
        
        
        
        

        [thirdTextView setText:[NSString stringWithFormat:@"Connected to %@\r\n",self.CBP.currentPeripheral.name]];
        [peripheralView setText:[NSString stringWithFormat:@"%@", self.CBP.currentPeripheral.name]];

        
        
        
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);

}


- (void)viewDidUnload {
    [self setTemperatureButton:nil];
    [self setTemperatureInterval:nil];
    [self setThirdTextView:nil];
    [self setTemperatureTextView:nil];
    [self setTemperatureTextView:nil];
    [self setPeripheralView:nil];
    [self setSupportedView:nil];
    [super viewDidUnload];
}

// The temperatureButton is clicked
// Not enabled unless peripheral supports health thermometer
- (IBAction)temperatureButtonClick:(id)sender {
    

    NSLog(@"Temperature button clicked.");
    
    
    // TODO:
    
    // skrive 2 til configuration-characteristic
    //unsigned char data = 0x02;
    //[self.CBP writeCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2902" data:[NSData dataWithBytes:&data length:1]];
    
    // eller kan man bare lese?
    
    
    self.CBP = appDelegate.CBP;
    self.CBP.delegate = appDelegate.CBP.delegate;
    //self.CBP.currentPeripheral = appDelegate.CBP.currentPeripheral;
    
    
    
    //[self.CBP readCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2a1c"];    
    [self.CBP setNotificationForCharacteristic:self.CBP.currentPeripheral sUUID:@"1809" cUUID:@"2a1c" enable:TRUE];

    
}

// Key-value observation - when the temperature is updated
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)CBP change:(NSDictionary *)change context:(void *)context
{
    
    NSLog(@"ThirdViewController - CBP.temperature is updated");

    if ([keyPath isEqualToString:@"temperature"] )
    {

        // her jukser jeg litt, må sjekke mer... vet ikke hva som skjer hvis jeg er koblet til flere med health thermometer
        
        // må slå opp i dictonarien og finne riktig temperatur i forhold til currentP
        
        // må også sjekke om den man er koblet til har healt thermometer
        
        
        // Update temperature
        if(self.CBP.currentPeripheral != nil){
            [self setValueTemperatureTextView:[NSString stringWithFormat:@"%@",self.CBP.temperature]];

        }
        
    }
}


// set intervals.....
- (IBAction)temperatureIntervalClick:(id)sender {
    NSLog(@"Interval changed, value is now %f", temperatureInterval.value);
    
    [thirdTextView setText:[NSString stringWithFormat:@"Interval value is now %f \r%@", temperatureInterval.value,thirdTextView.text]];
    
    
    //NSData *data = @"0x07D0";
    //[self.CBP writeCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2a21" data:[NSData dataWithBytes:&data length:1]];

    //NSLog(@"data %d", data);

    
    
    //[self.CBP writeCharacteristic:self.CBP.cBCP sUUID:@"1809" cUUID:@"2a21" data:[NSData dataWithBytes:&data length:2]];
    
    //[self.CBP writeCharacteristic:self.CBP.currentPeripheral sUUID:@"1809" cUUID:@"2a21" data:[NSData dataWithBytes:@"2000" length:2]];

    uint16_t val = 2;
    NSData * valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
    
    [self.CBP writeCharacteristic:self.CBP.currentPeripheral sUUID:@"1809" cUUID:@"2a21" data:valData];

    //[self.CBP.currentPeripheral writeValue:valData forCharacteristic:characteristicWithUUID:@"2a21" type:CBCharacteristicWriteWithResponse];
    NSLog(@"Found a Temperature Measurement Interval Characteristic - Write interval value");

}


-(void) servicesRead {
    [thirdTextView setText:[NSString stringWithFormat:@"Reading services\r%@",thirdTextView.text]];
    
    
}


- (void) updatedCharacteristic:(CBPeripheral *)peripheral sUUID:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID data:(NSData *)data
{
    NSLog(@"updatedCharacteristic in viewController, %@, %@", data, cUUID);
    
    
    
    [thirdTextView setText:[NSString stringWithFormat:@"%@Reading value: \r\n", thirdTextView.text]];
    
}



-(void)setValueTemperatureTextView:(NSString *)degree
{
  
    NSLog(@"thirdview setValueTemperatureTextView %@", degree);
    
    [temperatureTextView setText:[NSString stringWithFormat:@"%@ \r\n", degree]];

    
}




@end
