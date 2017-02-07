//
//  ClickerViewController.h
//  Clicker
//
//  Created by George Polak on 8/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"

@interface ClickerViewController : UIViewController {
    IBOutlet UILabel *_label;
    
    Clicker *_clicker;
}

@property (nonatomic, strong) Clicker *clicker;

- (IBAction)doClick;
- (IBAction)doReset;

@end

