    //
//  AddClickerViewController.m
//  Clicker
//
//  Created by George Polak on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddClickerViewController.h"


@implementation AddClickerViewController

@synthesize delegate = _delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Clicker";
    
    [_nameField becomeFirstResponder];
}

- (IBAction)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done
{
    Clicker *newClicker = [[Clicker alloc] init];
    if (_nameField.text && [_nameField.text length] > 0)
        newClicker.name = _nameField.text;
    
    if ([self.delegate respondsToSelector:@selector(addClickerViewController:didFinishWithClicker:)])
        [self.delegate addClickerViewController:self didFinishWithClicker:newClicker];
        
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
