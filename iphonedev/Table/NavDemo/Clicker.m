//
//  Clicker.m
//  Exercise1
//
//  Created by IBC on 1/25/13.
//  Copyright (c) 2013 Skyhook Wireless. All rights reserved.
//

#import "Clicker.h"

@implementation Clicker

@synthesize clicks = _clicks;

- (id)init
{
    self = [super init];
    if (self)
    {
        _clicks = 10;
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
    
    return self;
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
