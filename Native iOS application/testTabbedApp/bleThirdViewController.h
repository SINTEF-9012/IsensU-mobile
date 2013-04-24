//
//  bleThirdViewController.h
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 03.12.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "bleAppDelegate.h"
#import "bleConnect.h"
#import "bleDeviceControl.h"


@interface bleThirdViewController : UIViewController <bleDeviceControlDelegate>

-(void)setValueTemperatureTextView:(NSString *)temperature;



@property bleAppDelegate *appDelegate;
@property (strong, nonatomic) bleDeviceControl *CBP;
@property (strong, nonatomic) bleConnect *CBC;

@property NSString *pName;
@property NSString *peripheralName;
@property (strong, nonatomic) CBPeripheral *peripheral;

@property (strong, nonatomic) IBOutlet UIButton *temperatureButton;
- (IBAction)temperatureButtonClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIStepper *temperatureInterval;
- (IBAction)temperatureIntervalClick:(id)sender;


@property (strong, nonatomic) IBOutlet UITextView *thirdTextView;


@property (strong, nonatomic) IBOutlet UITextView *temperatureTextView;

@property (strong, nonatomic) IBOutlet UITextView *peripheralView;

@property (strong, nonatomic) IBOutlet UITextView *supportedView;



@end
