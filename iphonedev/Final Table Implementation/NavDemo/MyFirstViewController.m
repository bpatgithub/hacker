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

- (void)viewDidLoad
{
     [super viewDidLoad];
    
    _clicker1 = [[Clicker alloc] initWithClickCount:0];
    _clicker2 = [[Clicker alloc] initWithClickCount:0];
    _clicker3 = [[Clicker alloc] initWithClickCount:0];
    
//    self.title = @"First View";
//    
//	// Do any additional setup after loading the view, typically from a nib.
//}
//
}

//-(void)loadView
//{
//    UITableView *tableView = [[UITableView alloc]
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Clicker";
    }
                
    Clicker *clicker;
    if (indexPath.row == 0)
                clicker = _clicker1;
    else if (indexPath.row == 1)
                clicker = _clicker2;
    else if (indexPath.row == 2)
                clicker = _clicker3;
                
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", clicker.clicks];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
        ViewController *vc;
        if (indexPath.row == 0)
            vc = [[ViewController alloc] initWithClicker:_clicker1];
        else if (indexPath.row == 1)
            vc = [[ViewController alloc] initWithClicker:_clicker2];
        else if (indexPath.row == 2)
            vc = [[ViewController alloc] initWithClicker:_clicker3];
    
       [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
