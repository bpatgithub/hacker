//
//  Clicker.m
//  Two Page Variable Pass
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "Clicker.h"

@implementation Clicker

@synthesize clicks = _clicks;

-(id)init
{
    self = [super init];
    if (self)
    {
        _clicks = 0;
    }
    return self;
}

- (id)initWithClickCount:(NSInteger)clickCount
{
    self = [super init];
    if (self)
    {
        _clicks = clickCount;
    }
}

- (void)increment
{
    _clicks++;
}

- (void)reset
{
    _clicks = 0;
}

@end
