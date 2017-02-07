//
//  ViewController.m
//  firstexercise
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//


#import "ViewController.h"

@interface ViewController () <UIActionSheetDelegate>

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
    UIActionSheet *popupConfirm = [[UIActionSheet alloc] initWithTitle:@"Reset" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset" otherButtonTitles:nil];
    
    [popupConfirm showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [myClickObject resetCount];
        
        NSString *countString =
        [NSString stringWithFormat:@"%i", myClickObject.count];
        
        _label.text = countString;

    }
        
}
@end
