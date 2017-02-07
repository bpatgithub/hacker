//
//  Plant.h
//  BPReadXML
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plant : NSObject {
    NSString *_common;
    NSString *_botanical;
    NSString *_light;
    NSString *_price;
    NSString *_avail;
}

@property (nonatomic, strong) NSString *common;
@property (nonatomic, strong) NSString *botanical;
@property (nonatomic, strong) NSString *light;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *avail;

@end