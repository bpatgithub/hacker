//
//  Clicker.h
//  Two Page Variable Pass
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clicker : NSObject
{
    NSInteger _clicks;
}

@property (nonatomic, readonly) NSInteger clicks;

- (id)initWithClickCount:(NSInteger)clickCount;

- (void)increment;
- (void)reset;

@end
