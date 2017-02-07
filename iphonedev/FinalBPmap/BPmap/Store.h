//
//  Store.h
//  BPmap
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Store : NSObject <MKAnnotation>
{
    NSString *_name;
    NSInteger _phoneNo;
    CLLocationCoordinate2D _location;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger phoneNo;
@property (nonatomic) CLLocationCoordinate2D location;

@end
