//
//  SecondViewController.m
//  firstexercise
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//


#import "SecondViewController.h"

@interface SecondViewController () <UIActionSheetDelegate>

@end

@implementation SecondViewController



- (void)viewDidLoad
{
    myClickObject = [[Clicker alloc] init];
    
    
    UIBarButtonItem *addRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Right"
        style:UIBarButtonItemStylePlain target:nil
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self
        action:@selector(sayHello:)];
    
    self.navigationItem.rightBarButtonItem = addRightButton;
}

- (void)sayHello
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hello" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [alert show];
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
