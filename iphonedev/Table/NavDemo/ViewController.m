//
//  ViewController.m
//  Exercise1
//
//  Created by George Polak on 6/21/12.
//  Copyright (c) 2012 Skyhook Wireless. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController


- (id)initWithClicker:(Clicker *)clicker
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _clicker = clicker;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refreshLabel];
}

- (void)refreshLabel
{
    NSString *myString = [NSString stringWithFormat:@"%i", _clicker.clicks];
    _label.text = myString;
}

- (IBAction)click:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        [_clicker increment];
    }
    else if (sender.tag == 1)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Reset"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Reset"
                                                  otherButtonTitles:nil];
        
        [sheet showInView:self.view];
    }
    
    [self refreshLabel];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex)
    {
        [_clicker reset];
        [self refreshLabel];
    }
}

//- (IBAction)doClick
//{
//    _clicks++;
//    
//    [self refreshLabel];
//}
//
//- (IBAction)doReset
//{    
//    _clicks = 0;
//    
//    [self refreshLabel];
//}

@end
