//
//  Store.m
//  BPmap
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "Store.h"

@implementation Store

@synthesize name = _name;
@synthesize phoneNo = _phoneNo;
@synthesize location = _location;

- (CLLocationCoordinate2D)coordinate
{
    return _location;
}

- (NSString *)title
{
    return _name;
}

@end
