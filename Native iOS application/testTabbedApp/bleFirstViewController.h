//
//  bleFirstViewController.h
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 15.09.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bleConnect.h"
#import "bleDeviceControl.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "bleAppDelegate.h"

//#import "bleSecondViewController.h"

@interface bleFirstViewController : UIViewController <bleConnectDelegate, bleDeviceControlDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property bleAppDelegate *appDelegate;

//@property bleSecondViewController *secondView;


@property (strong, nonatomic) bleConnect *CBC;
@property (strong, nonatomic) bleDeviceControl *CBP;

@property (strong, nonatomic) CBPeripheral *peripheral;


@property (strong, nonatomic) IBOutlet UIButton *scanButton;
- (IBAction)scanButtonPress:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectButtonPress:(id)sender;


@property (strong, nonatomic) IBOutlet UITextView *firstViewText;

@property (strong, nonatomic) IBOutlet UIButton *clearLogButton;
- (IBAction)clearLogButtonPress:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *savedSensorsButton;
- (IBAction)savedSensorsButtonPress:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *scanServicesButton;
- (IBAction)scanServicesButtonPress:(id)sender;

@property (strong, nonatomic) IBOutlet UIProgressView *progressViewBar;


@property (strong, nonatomic) IBOutlet UIPickerView *peripheralPicker;

@property NSMutableArray *foundPeripheralsName;



@end
