//
//  Clicker.h
//  Exercise1
//
//  Created by IBC on 1/25/13.
//  Copyright (c) 2013 Skyhook Wireless. All rights reserved.
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
