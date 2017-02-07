//
//  AddClickerViewController.h
//  Clicker
//
//  Created by George Polak on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"

@protocol AddClickerViewControllerDelegate;

@interface AddClickerViewController : UIViewController
{   
    IBOutlet UITextField *_nameField;
    
    __weak id<AddClickerViewControllerDelegate> _delegate;
}


@property (nonatomic, weak) id<AddClickerViewControllerDelegate> delegate;

- (IBAction)cancel;
- (IBAction)done;

@end


@protocol AddClickerViewControllerDelegate <NSObject>

@optional
- (void)addClickerViewController:(AddClickerViewController *)vc didFinishWithClicker:(Clicker *)clicker;

@end
