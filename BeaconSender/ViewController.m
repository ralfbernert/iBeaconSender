//
//  ViewController.m
//  BeaconSender
//
//  Created by Ralf Bernert on 31.10.13.
//
//

#import "ViewController.h"
@import CoreFoundation;
@import CoreLocation;


static NSString *kBeaconRegionUUID = @"09a8845d-e3d5-48d5-8544-87216d1155d0";
static NSInteger kBeaconRSSI = -60;


@interface ViewController ()


@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITableView *selectionTableView;

@property (strong, nonatomic) NSArray *beaconNames;

@property (strong, nonatomic) CBPeripheralManager *theCBPeripheralManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statusLabel.text = @"Please choose an sender";
    
    self.beaconNames = @[@[@"iBeacon 1", @"iBeacon 2", @"iBeacon 3", @"iBeacon 4", @"iBeacon 5"],
                         @[@"iBeacon 1", @"iBeacon 2", @"iBeacon 3", @"iBeacon 4", @"iBeacon 5"]];
    
}


#pragma mark - UITableViewDataSource delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.beaconNames count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.beaconNames objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Group %li - %@", indexPath.section + 1, [[self.beaconNames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // update text label
    self.statusLabel.text = [NSString stringWithFormat:@"%@ sending..", [NSString stringWithFormat:@"iBeacon %li", indexPath.row + 1]];
    
    [self createAdvertisingBeaconWithPower:[NSNumber numberWithInteger:kBeaconRSSI] major:indexPath.section + 1 mino:indexPath.row + 1];
}


#pragma mark - iBeacon creation

- (void)createAdvertisingBeaconWithPower:(NSNumber *)rssi major:(CLBeaconMajorValue)major mino:(CLBeaconMinorValue)minor
{
    // check if instance of CBPeripheralManager already exists
    if (!self.theCBPeripheralManager) {
        
        // if not, create one
        self.theCBPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
    } else {
        
        // if yes stop sending
        [self.theCBPeripheralManager stopAdvertising];
        
    }
    
    // create CLBeaconRegion with UUID, group ID (major) and beacon ID (minor)
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:kBeaconRegionUUID];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID
                                                                           major:major
                                                                           minor:minor
                                                                      identifier:@"com.bernertmedia.beaconsender"];
    
    // create dictionary with RSSI (received signal strength indicator) is a measurement
    // of the power present in the sender's radio signal
    NSDictionary *toBroadcast = [beaconRegion peripheralDataWithMeasuredPower:rssi];
    
    // start sending
    [self.theCBPeripheralManager startAdvertising:toBroadcast];
}


#pragma mark - CBPeripheralManager delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // @required delegate methods, but we don't need it
}





@end
