//
//  Clicker.m
//  firstexercise
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "Clicker.h"

@implementation Clicker

@synthesize count;

- (void)incCount
{
    count++;
}

- (void)resetCount
{
    count = 0;
}

@end

