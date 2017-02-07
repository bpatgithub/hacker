//
//  ViewController.m
//  Two Page Variable Pass
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshLabel];
	// Do any additional setup after loading the view, typically from a nib.
}

- (id)initWithClicker:(Clicker *)clicker;  //defining clicker object access
{
    self = [super initWithNibName:nil bundle:nil];  //nil because .h,.m and .xib has sane names
    if (self) { //never fails but good to check
        _clicker = clicker;
    }
    return self;
}

-(void) refreshLabel {
    NSString *myString = [NSString stringWithFormat:@"%i", _clicker.clicks];
    _label.text = myString;
}

-(IBAction)click:(UIButton *)sender       //defining action
{
    if (sender.tag == 0)
    {
        [_clicker increment];
    }
    else if (sender.tag == 1) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Reset"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Reset"
                                                  otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
    [self refreshLabel];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.cancelButtonIndex != buttonIndex)
    {
        [_clicker reset];
        [self refreshLabel];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
