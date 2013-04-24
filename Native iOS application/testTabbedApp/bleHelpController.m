//
//  bleHelpController.m
//  TRÅLE
//
//  Created by Kristina Heyerdahl Elfving on 10.03.13.
//  Copyright (c) 2013 Kristina Heyerdahl Elfving. All rights reserved.
//

#import "bleHelpController.h"

@interface bleHelpController ()

@end

@implementation bleHelpController

@synthesize helpTextView;
@synthesize helpTextView2;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [helpTextView flashScrollIndicators];
    [helpTextView2 flashScrollIndicators];

    
    [helpTextView setText:[NSString stringWithFormat:@"This application was developed for and customized to the TRÅLE sensor. It is also usable with other devices which support Bluetooth Smart, but some features may not be available. The application can only run on Smart Phones that is Blutooth Smart Ready. Multiple Bluetooth Smart peripherals can be connected to the application at the same time. The application supports peripherals with a health thermometer sensor.\n\nThe application consists, in addition to this one, of three views. The first view controls peripheral search and connection. The second manages the connected peripherals, and the third displayes the health temperature. "]];
    
    [helpTextView2 setText:[NSString stringWithFormat:@"In the connect view, press the button labeled ´Scan´. By pressing the button, the application will start a scan for peripherals with Blutooth Smart. The peripherals that are discovered will appear in the picker. To connect to a peripheral, choose it in the picker and press the button labeled ´Connect <peripheral name>´. The connection will never time out, meaning that if the peripheral is currently unavailable, the application will still connect to it when it becomes available. Press the button labeled ´Discover services´ to do a service scan. To disconnect a peripheral choose it again in the picker and press ´Disconnect <peripheral name>´. \n\nThe peripheral view shows all the peripherals that is currently connected. Choose a peripheral in the picker to display battery level and available services. Available services means the services implemented by this application, and this label will be empty if the peripheral does not support health thermometer. More services may be implemented in later versions of the application. \n\nThe health thermometer view shows the health temperature if the peripheral supports this service. To display the themperature the peripheral must first be chosen in the picker in the peripheral view, then the ´Notify temperature´ button in the health thermometer view pressed."]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [helpTextView flashScrollIndicators];
    [helpTextView2 flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



- (void)viewDidUnload {
    [self setHelpTextView:nil];
    [self setHelpTextView2:nil];
    [super viewDidUnload];
}
    
@end
