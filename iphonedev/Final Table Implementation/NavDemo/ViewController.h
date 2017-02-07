//
//  ViewController.h
//  Exercise1
//
//  Created by George Polak on 6/21/12.
//  Copyright (c) 2012 Skyhook Wireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"

@interface ViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UILabel *_label;
    
//    NSInteger _clicks;
    Clicker *_clicker;
}

- (id)initWithClicker:(Clicker *)clicker;

- (IBAction)click:(UIButton *)sender;

//- (IBAction)doClick;
//- (IBAction)doReset;

@end
