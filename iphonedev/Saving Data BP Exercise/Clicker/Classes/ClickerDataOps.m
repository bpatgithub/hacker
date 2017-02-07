//
//  ClickerDataOps.m
//  Clicker
//
//  Created by Patel, Bhavesh on 1/26/13.
//
//

#import "ClickerDataOps.h"

@implementation ClickerDataOps

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
