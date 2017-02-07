//
//  ViewController.h
//  BPDataOps
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSString * data;
    NSString * saveMessage;
}

//@property (nonatomic) IBOutlet UILabel * data;
@property (nonatomic) IBOutlet UILabel * saveMessage;

-(IBAction)savePressed;

@end
