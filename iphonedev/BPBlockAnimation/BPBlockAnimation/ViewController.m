//
//  ViewController.m
//  BPBlockAnimation
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (IBAction)arrowMove:(UIButton *)sender
{
    int chance;
    
        CGFloat y = 0;
    
        chance = arc4random() % 5;
    
        if (chance == 1)
            y = 217;
        else if (chance == 2)
            y = 200;
        else if (chance == 3)
            y = 300;
        else if (chance == 4)
            y = 400;
        else if (chance == 5)
            y = 500;


//    CGFloat delta = fabsf(_lastChoice - chance);
  //  CGFloat duration = delta / 4 / 3;
   // _lastChoice = chance;
    
    sender.enabled = NO;
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = _myArrow.frame;
        frame.origin.y = y;
        _myArrow.frame = frame;
    } completion:^(BOOL finished) {
    sender.enabled = YES;
    }];
}
     
@end