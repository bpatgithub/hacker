//
//  ViewController.m
//  BPmap
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "ViewController.h"
#import "Store.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager startUpdatingLocation];
    
    toggle = YES;
}

- (IBAction)mark:(UIBarButtonItem *)sender
{
    Store *store = [[Store alloc] init];
    store.name = @"Starbucks";
    store.location = _map.centerCoordinate;
    
    [_map addAnnotation:store];
    
   }

- (IBAction)stopLocating:(UIBarButtonItem *)sender
{    
    
    if (toggle == YES) {
        [_manager stopUpdatingLocation];
        toggle = NO;
    }
    else {
        toggle = YES;
        [_manager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
    
    [_map setRegion:region animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
