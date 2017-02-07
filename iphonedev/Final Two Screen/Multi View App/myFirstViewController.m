//
//  ViewController.m
//  Multi View App
//
//  Created by Patel, Bhavesh on 1/25/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "myFirstViewController.h"
#import "SecondViewController.h"

@interface myFirstViewController ()

@end

@implementation myFirstViewController

- (IBAction)pushNewView
{
    SecondViewController *svc = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"First Window";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
