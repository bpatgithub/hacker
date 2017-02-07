//
//  ClickerDataOps.h
//  Clicker
//
//  Created by Patel, Bhavesh on 1/26/13.
//
//

#import <Foundation/Foundation.h>

@interface ClickerDataOps : NSObject <NSCoding>
{
    NSString *clickerValue;
}

@property (nonatomic, strong) NSString *clickerValue;

@end
