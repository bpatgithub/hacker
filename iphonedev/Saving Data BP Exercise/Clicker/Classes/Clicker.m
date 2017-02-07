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

@synthesize clickerValue = _clickerValue;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _clickerValue = [aDecoder decodeObjectForKey:@"kClickerValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_clickerValue forKey:@"kClickerValue"];
}

// get path
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                     NSUserDomainMask,
                                                     YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
NSString *saveFile = [documentsDirectory stringByAppendingPathComponent:@"ClickerData.dat"];


@end

