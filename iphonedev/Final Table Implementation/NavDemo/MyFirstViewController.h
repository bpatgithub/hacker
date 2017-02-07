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

@interface MyFirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    Clicker *_clicker1;
    Clicker *_clicker2;
    Clicker *_clicker3;
}

- (IBAction)pushNewView;

@end
