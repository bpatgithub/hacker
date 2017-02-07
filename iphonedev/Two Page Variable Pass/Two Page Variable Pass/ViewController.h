//
//  ViewController.h
//  Two Page Variable Pass
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"

@interface ViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UILabel *_label;
    Clicker *_clicker;  // assign _cliker object to Clicker class
}

- (id)initWithClicker:(Clicker *)clicker;  //defining clicker object access
-(IBAction)click:(UIButton *)sender;       //defining action


@end
