//
//  ViewController.h
//  BPmap
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *_manager;
    IBOutlet MKMapView *_map;    
    BOOL toggle;
}

- (IBAction)mark:(UIBarButtonItem *)sender;
- (IBAction)stopLocating:(UIBarButtonItem *)sender;

@end
