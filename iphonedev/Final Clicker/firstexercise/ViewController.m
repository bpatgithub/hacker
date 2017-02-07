//
//  ViewController.m
//  firstexercise
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    myClickObject = [[Clicker alloc] init];
}

- (IBAction)countButtonClicked
{
    
    [myClickObject incCount];
    
    //count = myClickObject.count;
    
    NSString *countString =
     [NSString stringWithFormat:@"%i", myClickObject.count];
    
    _label.text = countString;
     
}

- (IBAction)resetButtonClicked
{
    
    [myClickObject resetCount];
    
    //count = _myClickObject.count;
    
    //_label.text = @"hello";
    NSString *countString =
    [NSString stringWithFormat:@"%i", myClickObject.count];
    
    _label.text = countString;
    
}
@end
