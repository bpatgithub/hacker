//
//  Clicker.m
//  Clicker
//
//  Created by George Polak on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Clicker.h"


@implementation Clicker

@synthesize name = _name;

- (id)init {
    if (self = [super init]) {
        _clicks = 0;
        _name = @"New Clicker";
    }
    
    return self;
}

- (void)doClick {
    _clicks++;
}

- (NSInteger)clickCount {
    return _clicks;
}

- (void)reset {
    _clicks = 0;
}


@end
