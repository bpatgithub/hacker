//
//  Clicker.h
//  Clicker
//
//  Created by George Polak on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Clicker : NSObject {
    NSString *_name;
    
    NSInteger _clicks;
}

@property (nonatomic, strong) NSString *name;

- (void)doClick;
- (NSInteger)clickCount;
- (void)reset;

@end
