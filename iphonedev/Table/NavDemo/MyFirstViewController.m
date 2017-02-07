//
//  ViewController.m
//  NavDemo
//
//  Created by IBC on 1/25/13.
//  Copyright (c) 2013 IBC. All rights reserved.
//

#import "MyFirstViewController.h"

@interface MyFirstViewController ()

@end


@implementation MyFirstViewController

- (IBAction)pushNewView
{
//    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
//    vc.clicker = _clicker;
    
    ViewController *vc = [[ViewController alloc] initWithClicker:_clicker];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _clicker = [[Clicker alloc] initWithClickCount:0];
    
    self.title = @"First View";
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
