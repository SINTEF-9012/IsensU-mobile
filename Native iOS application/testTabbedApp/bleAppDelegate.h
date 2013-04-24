//
//  bleAppDelegate.h
//  testTabbedApp
//
//  Created by Kristina Heyerdahl Elfving on 15.09.12.
//  Copyright (c) 2012 Kristina Heyerdahl Elfving. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/Corebluetooth.h>
#import "bleDeviceControl.h"
#import "bleConnect.h"

//#define bleDeviceControl \
((CBP *)[UIApplication sharedApplication].delegate)

@interface bleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) bleDeviceControl *CBP;


@property (strong, nonatomic) bleConnect *CBC;


@property int temperature;


@end
