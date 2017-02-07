//
//  ViewController.h
//  firstexercise
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"

@interface ViewController : UIViewController
{
    IBOutlet UILabel *_label;
    
    Clicker *myClickObject;
}

- (IBAction)countButtonClicked;

- (IBAction)resetButtonClicked;

@end
