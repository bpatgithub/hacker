//
//  ViewController.h
//  NavDemo
//
//  Created by IBC on 1/25/13.
//  Copyright (c) 2013 IBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Clicker.h"

@interface MyFirstViewController : UIViewController
{
    Clicker *_clicker;
}

- (IBAction)pushNewView;

@end
