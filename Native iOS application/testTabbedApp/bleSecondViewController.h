//
//  bleSecondViewController.h
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 15.09.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "bleAppDelegate.h"
//#import "bleFirstViewController.h"

#import "bleConnect.h"
#import "bleDeviceControl.h"



@interface bleSecondViewController : UIViewController  <bleDeviceControlDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *secondViewText;

//@property (strong, nonatomic) bleFirstViewController *firstView;

@property (strong, nonatomic) bleConnect *CBC;
@property (strong, nonatomic) bleDeviceControl *CBP;

@property (strong, nonatomic) CBPeripheral *peripheral;


@property bleAppDelegate *appDelegate;

@property NSString *peripheralName;



@property (strong, nonatomic) IBOutlet UIPickerView *connectedPeripheralPicker;

@property NSMutableArray *connectedP;

@property (strong, nonatomic) IBOutlet UITextView *batteryView;

@property (strong, nonatomic) IBOutlet UITextView *servicesView;

@property (strong, nonatomic) IBOutlet UITextView *isConnectedView;

@end
